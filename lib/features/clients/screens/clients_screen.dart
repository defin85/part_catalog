import 'package:flutter/material.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/clients/models/client.dart';
import 'package:part_catalog/features/clients/models/client_type.dart';
import 'package:part_catalog/features/clients/services/client_service.dart';
import 'package:part_catalog/features/vehicles/services/car_service.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final ClientService _clientService = locator<ClientService>();
  bool _isDbError = false;

  @override
  Widget build(BuildContext context) {
    if (_isDbError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ошибка базы данных')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Ошибка доступа к базе данных'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Получаем ScaffoldMessengerState до асинхронной операции
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  try {
                    // Сбрасываем базу данных
                    final db = locator<AppDatabase>();
                    await db.resetDatabase();

                    // Обновляем экземпляры в сервис-локаторе
                    locator.unregister<AppDatabase>();
                    locator.registerSingleton<AppDatabase>(AppDatabase());

                    // Обновляем все сервисы, зависящие от БД
                    locator.unregister<ClientService>();
                    locator.unregister<CarService>();
                    locator.registerLazySingleton<ClientService>(
                        () => ClientService(locator<AppDatabase>()));
                    locator.registerLazySingleton<CarService>(
                        () => CarService(locator<AppDatabase>()));

                    setState(() {
                      _isDbError = false;
                    });

                    // Используем сохраненный scaffoldMessenger
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                          content: Text('База данных успешно сброшена')),
                    );
                  } catch (e) {
                    // Показываем сообщение об ошибке
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                          content: Text('Ошибка при сбросе базы данных: $e')),
                    );
                  }
                },
                child: const Text('Сбросить базу данных'),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Клиенты'),
      ),
      // Используем StreamBuilder для реактивного обновления списка клиентов
      body: StreamBuilder<List<Client>>(
        // Подписываемся на поток данных из сервиса
        stream: _clientService.watchClients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Проверяем, связана ли ошибка с отсутствием таблицы
            if (snapshot.error.toString().contains('no such table')) {
              // Устанавливаем флаг ошибки БД, который перерисует виджет
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isDbError = true;
                });
              });
            }
            return Center(
              child: Text(
                'Ошибка загрузки данных: ${snapshot.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          final clients = snapshot.data ?? [];

          if (clients.isEmpty) {
            return const Center(
              child: Text(
                  'Список клиентов пуст. Добавьте клиента, нажав на кнопку "+"'),
            );
          }

          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];
              return Dismissible(
                key: Key(client.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Удалить клиента?'),
                            content: Text(
                                'Вы действительно хотите удалить клиента ${client.name}?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Отмена'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Удалить'),
                              ),
                            ],
                          );
                        },
                      ) ??
                      false;
                },
                onDismissed: (direction) async {
                  // Получаем ScaffoldMessengerState до асинхронной операции
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  await _clientService.deleteClient(client.id);
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Клиент ${client.name} удален')),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: client.type == ClientType.physical
                        ? Colors.blue
                        : Colors.orange,
                    child: Icon(
                      client.type == ClientType.physical
                          ? Icons.person
                          : Icons.business,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(client.name),
                  subtitle: Text(client.contactInfo),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _editClient(client),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addClient,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addClient() async {
    final client = await _showClientDialog(context);
    if (client != null) {
      await _clientService.addClient(client);
    }
  }

  Future<void> _editClient(Client client) async {
    final updatedClient = await _showClientDialog(context, client: client);
    if (updatedClient != null) {
      await _clientService.updateClient(updatedClient);
    }
  }

  /// Показывает диалог для добавления/редактирования клиента.
  ///
  /// [client] - существующий клиент для редактирования, null для нового клиента.
  ///
  /// Возвращает новый или обновленный объект [Client] или null, если отменено.
  Future<Client?> _showClientDialog(BuildContext context,
      {Client? client}) async {
    // Создаём контроллеры для полей ввода с начальными значениями из клиента (если есть)
    final nameController = TextEditingController(text: client?.name);
    final contactInfoController =
        TextEditingController(text: client?.contactInfo);
    final additionalInfoController =
        TextEditingController(text: client?.additionalInfo);

    // Начальное значение типа клиента
    ClientType selectedType = client?.type ?? ClientType.physical;

    // Состояние валидации формы
    bool isValid =
        client != null; // для новых клиентов изначально невалидная форма

    // Создаём ключ для формы (для валидации)
    final formKey = GlobalKey<FormState>();

    return showDialog<Client>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          // Функция валидации формы
          void validateForm() {
            setState(() {
              isValid = formKey.currentState?.validate() ?? false;
            });
          }

          return AlertDialog(
            title: Text(
                client == null ? 'Добавить клиента' : 'Редактировать клиента'),
            content: Form(
              key: formKey,
              onChanged: validateForm,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Выпадающий список для типа клиента
                    DropdownButtonFormField<ClientType>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Тип клиента',
                        prefixIcon: Icon(Icons.category),
                        border: OutlineInputBorder(),
                      ),
                      items: ClientType.values.map((type) {
                        IconData iconData;
                        Color iconColor;

                        switch (type) {
                          case ClientType.physical:
                            iconData = Icons.person;
                            iconColor = Colors.blue;
                            break;
                          case ClientType.legal:
                            iconData = Icons.business;
                            iconColor = Colors.orange;
                            break;
                          case ClientType.individualEntrepreneur:
                            iconData = Icons.business_center;
                            iconColor = Colors.green;
                            break;
                          case ClientType.other:
                            iconData = Icons.help_outline;
                            iconColor = Colors.grey;
                            break;
                        }

                        return DropdownMenuItem<ClientType>(
                          value: type,
                          child: Row(
                            children: [
                              Icon(iconData, color: iconColor, size: 18),
                              const SizedBox(width: 8),
                              Text(type.displayName),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (ClientType? value) {
                        if (value != null) {
                          setState(() {
                            selectedType = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Поле ввода имени/наименования клиента
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: selectedType == ClientType.physical
                            ? 'ФИО клиента'
                            : 'Наименование организации',
                        prefixIcon: Icon(
                          selectedType == ClientType.physical
                              ? Icons.person
                              : Icons.business,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Поле обязательно для заполнения';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),

                    // Поле ввода контактной информации
                    TextFormField(
                      controller: contactInfoController,
                      decoration: const InputDecoration(
                        labelText: 'Контактная информация',
                        prefixIcon: Icon(Icons.contact_phone),
                        hintText: 'Телефон, email, адрес',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Поле обязательно для заполнения';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),

                    // Поле ввода дополнительной информации (опционально)
                    TextFormField(
                      controller: additionalInfoController,
                      decoration: const InputDecoration(
                        labelText: 'Дополнительная информация',
                        prefixIcon: Icon(Icons.info_outline),
                        hintText: 'Примечания, особые условия и т.д.',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: isValid
                    ? () {
                        // Создаем объект клиента из введенных данных
                        final result = Client(
                          id: client?.id ??
                              0, // 0 для новых клиентов (ID присвоит БД)
                          type: selectedType,
                          name: nameController.text.trim(),
                          contactInfo: contactInfoController.text.trim(),
                          additionalInfo:
                              additionalInfoController.text.trim().isNotEmpty
                                  ? additionalInfoController.text.trim()
                                  : null,
                        );
                        Navigator.of(context).pop(result);
                      }
                    : null, // Если форма невалидна, кнопка будет неактивна
                child: Text(client == null ? 'Добавить' : 'Сохранить'),
              ),
            ],
          );
        });
      },
    );
  }
}
