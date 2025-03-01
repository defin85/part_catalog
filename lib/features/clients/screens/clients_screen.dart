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

  Future<Client?> _showClientDialog(BuildContext context,
      {Client? client}) async {
    // Реализация диалога добавления/редактирования клиента
    // ...
    return showDialog<Client>(
      context: context,
      builder: (BuildContext context) {
        // Существующий код диалога
        return AlertDialog(
            // ...
            );
      },
    );
  }
}
