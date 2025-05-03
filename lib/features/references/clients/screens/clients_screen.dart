import 'package:flutter/material.dart';
import 'package:part_catalog/core/database/database.dart'; // Для сброса БД
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/service_locator.dart';
// Импортируем бизнес-модель (композитор)
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/features/references/clients/models/client_type.dart';
import 'package:part_catalog/features/references/clients/services/client_service.dart';
// Импортируем сервисы для обновления в service_locator при сбросе БД
import 'package:part_catalog/features/references/vehicles/services/car_service.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/core/utils/logger_config.dart'; // Используем настроенный логгер
import 'package:part_catalog/core/utils/log_messages.dart';
import 'package:rxdart/rxdart.dart'; // Для debounce
import 'dart:async'; // Для Timer

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  // Получаем сервис через locator (или Provider, если настроен)
  final ClientService _clientService = locator<ClientService>();
  final Logger _logger =
      AppLoggers.clientsLogger; // Используем настроенный логгер
  bool _isDbError = false;
  final TextEditingController _searchController = TextEditingController();
  final _searchSubject = BehaviorSubject<String?>.seeded(null);
  StreamSubscription? _searchSubscription;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Подписка на изменения поиска с debounce
    _searchSubscription = _searchSubject
        .debounceTime(const Duration(milliseconds: 300))
        .listen((query) {
      // Здесь можно было бы вызывать поиск, если бы он был асинхронным
      // и не зависел от StreamBuilder. В данном случае просто обновляем UI.
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchSubject.close();
    _searchSubscription?.cancel();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text;
      // Обновляем BehaviorSubject, который вызовет setState в listener'е
      if (_searchSubject.value != query) {
        _searchSubject.add(query.isEmpty ? null : query);
      }
    });
  }

  Stream<List<ClientModelComposite>> _getClientStream() {
    final query = _searchSubject.value;
    if (query == null || query.isEmpty) {
      return _clientService.watchClients();
    } else {
      // Для поиска используем Future, обернутый в Stream
      // Это не идеально для реактивности, но проще для текущей структуры
      // В идеале, поиск тоже должен быть Stream в сервисе/репозитории
      return Stream.fromFuture(_clientService.searchClients(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Получаем локализованные строки один раз в build
    final t = context.t;

    if (_isDbError) {
      return Scaffold(
        appBar: AppBar(title: Text(t.core.error)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(t.core.dataLoadingError),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    _resetDatabase(context), // Выносим в отдельный метод
                child: Text(t.core.resetDatabase),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.clients.screenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ClientSearchDelegate(_clientService, _editClient),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Поле поиска
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: t.clients.search,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          // _onSearchChanged(); // Вызываем, чтобы обновить BehaviorSubject
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          // Список клиентов
          Expanded(
            child: StreamBuilder<List<ClientModelComposite>>(
              // Используем _getClientStream для получения нужного потока
              stream: _getClientStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _searchSubject.value == null) {
                  // Показываем индикатор только при первой загрузке
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  _logger.e(LogMessages.dataLoadingError,
                      error: snapshot.error, stackTrace: snapshot.stackTrace);
                  // Проверяем ошибку БД
                  if (snapshot.error.toString().contains('no such table')) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _isDbError = true;
                        });
                      }
                    });
                    return const SizedBox
                        .shrink(); // Не показываем ошибку, пока перерисовывается
                  }
                  // Показываем ошибку загрузки данных
                  return Center(
                    child: Text(
                      t.core.errorLoadingData(error: snapshot.error.toString()),
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  );
                }

                final clients = snapshot.data ?? [];

                if (clients.isEmpty) {
                  return Center(
                    child: Text(_searchSubject.value == null ||
                            _searchSubject.value!.isEmpty
                        ? t.clients.emptyList
                        : t.clients.noClientsFound),
                  );
                }

                // Используем ListView.separated для разделителей
                return ListView.separated(
                  itemCount: clients.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    return Dismissible(
                      key: Key(client.uuid), // Используем UUID как ключ
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) =>
                          _confirmDeletion(context, client), // Выносим в метод
                      onDismissed: (direction) =>
                          _deleteClient(context, client), // Выносим в метод
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getClientTypeColor(client.type),
                          child: Icon(
                            _getClientTypeIcon(client.type),
                            color: Colors.white,
                          ),
                        ),
                        // Используем поля из ClientModelComposite
                        title: Text(client.displayName),
                        subtitle:
                            Text('${client.code} · ${client.contactInfo}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _editClient(client),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addClient,
        tooltip: t.clients.add, // Добавляем tooltip
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- Методы для действий ---

  Future<void> _resetDatabase(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final t = context.t; // Получаем локализацию

    try {
      final db = locator<AppDatabase>();
      await db.resetDatabase();

      // Обновляем экземпляры в сервис-локаторе
      locator.unregister<AppDatabase>();
      locator.registerSingleton<AppDatabase>(AppDatabase());

      locator.unregister<ClientService>();
      locator.unregister<CarService>(); // Пример, если есть другие сервисы
      locator.registerLazySingleton<ClientService>(
          () => ClientService(locator<AppDatabase>()));
      locator.registerLazySingleton<CarService>(
          () => CarService(locator<AppDatabase>()));

      if (mounted) {
        setState(() {
          _isDbError = false;
        });
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text(t.core.resetDatabaseSuccess)));
      }
    } catch (e, s) {
      _logger.e(LogMessages.databaseResetError, error: e, stackTrace: s);
      if (mounted) {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(t.core.resetDatabaseError(error: e.toString()))));
      }
    }
  }

  Future<bool?> _confirmDeletion(
      BuildContext context, ClientModelComposite client) async {
    final t = context.t;
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            // Используем dialogContext
            return AlertDialog(
              title: Text(t.common.confirmDeletion),
              content: Text(t.clients.confirmDelete(name: client.displayName)),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext)
                      .pop(false), // Используем dialogContext
                  child: Text(t.common.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext)
                      .pop(true), // Используем dialogContext
                  child: Text(t.common.delete,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error)),
                ),
              ],
            );
          },
        ) ??
        false; // Возвращаем false если диалог закрыт без выбора
  }

  Future<void> _deleteClient(
      BuildContext context, ClientModelComposite client) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final t = context.t;
    final clientUuid = client.uuid; // Сохраняем UUID для Snackbar action

    try {
      await _clientService.deleteClient(clientUuid);
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(t.clients.clientDeleted(name: client.displayName)),
            action: SnackBarAction(
              label: t.common.undo,
              onPressed: () =>
                  _restoreClient(context, clientUuid), // Передаем UUID
            ),
          ),
        );
      }
    } catch (e, s) {
      _logger.e(LogMessages.clientDeleteError.replaceAll('{uuid}', clientUuid),
          error: e, stackTrace: s);
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(t.clients.deleteError(error: e.toString()))),
        );
      }
    }
  }

  Future<void> _restoreClient(BuildContext context, String clientUuid) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final t = context.t;

    try {
      await _clientService.restoreClient(clientUuid);
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
              content:
                  Text(t.clients.clientRestored)), // Имя здесь недоступно легко
        );
      }
    } catch (e, s) {
      _logger.e(LogMessages.clientRestoreError.replaceAll('{uuid}', clientUuid),
          error: e, stackTrace: s);
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(t.clients.restoreError(error: e.toString()))),
        );
      }
    }
  }

  Future<void> _addClient() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final t = context.t;

    // Показываем диалог и ждем результат (ClientModelComposite или null)
    final newClient = await _showClientDialog(context);
    if (newClient != null) {
      try {
        await _clientService.addClient(newClient);
        // Опционально: показать сообщение об успехе
        // if (mounted) {
        //   scaffoldMessenger.showSnackBar(SnackBar(content: Text('Клиент ${newClient.displayName} добавлен')));
        // }
      } catch (e, s) {
        _logger.e(LogMessages.clientAddError, error: e, stackTrace: s);
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(t.clients.addError(error: e.toString()))),
          );
        }
      }
    }
  }

  Future<void> _editClient(ClientModelComposite client) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final t = context.t;

    // Показываем диалог с существующим клиентом
    final updatedClient = await _showClientDialog(context, client: client);
    if (updatedClient != null) {
      try {
        await _clientService.updateClient(updatedClient);
        // Опционально: показать сообщение об успехе
        // if (mounted) {
        //   scaffoldMessenger.showSnackBar(SnackBar(content: Text('Клиент ${updatedClient.displayName} обновлен')));
        // }
      } catch (e, s) {
        _logger.e(
            LogMessages.clientUpdateError.replaceAll('{uuid}', client.uuid),
            error: e,
            stackTrace: s);
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(t.clients.updateError(error: e.toString()))),
          );
        }
      }
    }
  }

  // --- Вспомогательные методы ---

  Color _getClientTypeColor(ClientType type) {
    // ... (реализация как в оригинале)
    switch (type) {
      case ClientType.physical:
        return Colors.blue;
      case ClientType.legal:
        return Colors.orange;
      case ClientType.individualEntrepreneur:
        return Colors.green;
      case ClientType.other:
        return Colors.grey;
    }
  }

  IconData _getClientTypeIcon(ClientType type) {
    // ... (реализация как в оригинале)
    switch (type) {
      case ClientType.physical:
        return Icons.person;
      case ClientType.legal:
        return Icons.business;
      case ClientType.individualEntrepreneur:
        return Icons.business_center;
      case ClientType.other:
        return Icons.help_outline;
    }
  }

  /// Показывает диалог для добавления/редактирования клиента.
  /// Работает с [ClientModelComposite].
  Future<ClientModelComposite?> _showClientDialog(BuildContext context,
      {ClientModelComposite? client}) async {
    final t = context.t; // Получаем локализацию
    final bool isEditing = client != null;

    // Используем данные из ClientModelComposite
    final nameController = TextEditingController(text: client?.displayName);
    final codeController = TextEditingController(text: client?.code);
    final contactInfoController =
        TextEditingController(text: client?.contactInfo);
    final additionalInfoController =
        TextEditingController(text: client?.additionalInfo);
    ClientType selectedType = client?.type ?? ClientType.physical;

    final formKey = GlobalKey<FormState>();
    bool isCodeUnique = true; // Флаг для асинхронной валидации кода

    return showDialog<ClientModelComposite>(
      context: context,
      // barrierDismissible: false, // Запретить закрытие по тапу вне диалога
      builder: (BuildContext dialogContext) {
        // Используем dialogContext
        return StatefulBuilder(builder: (context, setStateDialog) {
          // Используем setStateDialog

          // Асинхронная валидация уникальности кода
          Future<void> checkCodeUniqueness(String value) async {
            if (value.isNotEmpty && value != client?.code) {
              final unique = await _clientService.isCodeUnique(value,
                  excludeUuid: client?.uuid);
              if (mounted) {
                // Проверяем mounted перед вызовом setStateDialog
                setStateDialog(() {
                  isCodeUnique = unique;
                });
              }
            } else {
              if (mounted) {
                setStateDialog(() {
                  isCodeUnique = true;
                }); // Считаем уникальным, если пустой или не изменился
              }
            }
          }

          // Валидация всей формы
          bool validateFullForm() {
            return (formKey.currentState?.validate() ?? false) && isCodeUnique;
          }

          return AlertDialog(
            title: Text(isEditing ? t.clients.edit : t.clients.add),
            content: Form(
              key: formKey,
              // onChanged: () => setStateDialog(() {}), // Обновляем состояние для кнопки Save/Add
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- Тип клиента ---
                    DropdownButtonFormField<ClientType>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: t.clients.type,
                        prefixIcon: Icon(_getClientTypeIcon(selectedType),
                            color: _getClientTypeColor(selectedType)),
                        border: const OutlineInputBorder(),
                      ),
                      items: ClientType.values.map((type) {
                        return DropdownMenuItem<ClientType>(
                          value: type,
                          child: Row(
                            children: [
                              Icon(_getClientTypeIcon(type),
                                  color: _getClientTypeColor(type), size: 20),
                              const SizedBox(width: 8),
                              Text(_getClientTypeDisplayName(
                                  context, type)), // Локализованное имя
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (ClientType? value) {
                        if (value != null) {
                          setStateDialog(() {
                            selectedType = value;
                          });
                        }
                      },
                      validator: (value) =>
                          value == null ? t.clients.typeRequired : null,
                    ),
                    const SizedBox(height: 16),

                    // --- Код клиента ---
                    TextFormField(
                      controller: codeController,
                      decoration: InputDecoration(
                        labelText: t.clients.code,
                        prefixIcon: const Icon(Icons.qr_code),
                        border: const OutlineInputBorder(),
                        errorText:
                            !isCodeUnique ? t.clients.codeNotUnique : null,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return t.clients.codeRequired;
                        }
                        // Дополнительная проверка isCodeUnique здесь не нужна, т.к. errorText используется
                        return null;
                      },
                      onChanged: (value) async {
                        await checkCodeUniqueness(value);
                        // Триггерим перерисовку для обновления состояния кнопки Save/Add
                        setStateDialog(() {});
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // --- Имя/Наименование ---
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: selectedType == ClientType.physical
                            ? t.clients.personName
                            : t.clients.companyName,
                        prefixIcon: Icon(selectedType == ClientType.physical
                            ? Icons.person
                            : Icons.business),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return t.clients.nameRequired;
                        }
                        return null;
                      },
                      onChanged: (_) =>
                          setStateDialog(() {}), // Обновляем состояние кнопки
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // --- Контактная информация ---
                    TextFormField(
                      controller: contactInfoController,
                      decoration: InputDecoration(
                        labelText: t.clients.contactInfo,
                        prefixIcon: const Icon(Icons.contact_phone),
                        hintText: t.clients.contactInfoHint,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return t.clients.contactInfoRequired;
                        }
                        return null;
                      },
                      onChanged: (_) =>
                          setStateDialog(() {}), // Обновляем состояние кнопки
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // --- Дополнительная информация ---
                    TextFormField(
                      controller: additionalInfoController,
                      decoration: InputDecoration(
                        labelText: t.clients.additionalInfo,
                        prefixIcon: const Icon(Icons.info_outline),
                        hintText: t.clients.additionalInfoHint,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      // Валидатор не нужен, поле опциональное
                      onChanged: (_) =>
                          setStateDialog(() {}), // Обновляем состояние кнопки
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext)
                    .pop(), // Используем dialogContext
                child: Text(t.common.cancel),
              ),
              TextButton(
                // Делаем кнопку неактивной, если форма невалидна
                onPressed: validateFullForm()
                    ? () {
                        // Создаем или обновляем ClientModelComposite
                        final result = isEditing
                            ? client
                                .withName(nameController.text.trim())
                                .withContactInfo(
                                    contactInfoController.text.trim())
                                .withType(selectedType)
                                .withAdditionalInfo(
                                    additionalInfoController.text.trim().isEmpty
                                        ? null
                                        : additionalInfoController.text.trim())
                                // .withCode(codeController.text.trim()) // Метод withCode не реализован в композиторе, код обновляется через coreData.copyWith
                                // Правильнее обновить coreData и clientData и создать новый композитор
                                .copyWithCoreData(
                                  code: codeController.text.trim(),
                                  displayName: nameController.text.trim(),
                                  modifiedAt: DateTime.now(),
                                )
                                .copyWithClientData(
                                  type: selectedType,
                                  contactInfo:
                                      contactInfoController.text.trim(),
                                  additionalInfo: additionalInfoController.text
                                          .trim()
                                          .isEmpty
                                      ? null
                                      : additionalInfoController.text.trim(),
                                )
                            : ClientModelComposite.create(
                                code: codeController.text.trim(),
                                name:
                                    nameController.text.trim(), // Передаем name
                                type: selectedType,
                                contactInfo: contactInfoController.text.trim(),
                                additionalInfo:
                                    additionalInfoController.text.trim().isEmpty
                                        ? null
                                        : additionalInfoController.text.trim(),
                              );
                        Navigator.of(dialogContext)
                            .pop(result); // Используем dialogContext
                      }
                    : null, // Кнопка неактивна
                child: Text(isEditing ? t.common.save : t.common.add),
              ),
            ],
          );
        });
      },
    );
  }

  /// Получает локализованное имя типа клиента
  String _getClientTypeDisplayName(BuildContext context, ClientType type) {
    final t = context.t;
    switch (type) {
      case ClientType.physical:
        return t.clients.types.physical;
      case ClientType.legal:
        return t.clients.types.legal;
      case ClientType.individualEntrepreneur:
        return t.clients.types.entrepreneur;
      case ClientType.other:
        return t.clients.types.other;
    }
  }
}

// --- Делегат поиска ---

/// Делегат для поиска клиентов с помощью search delegate
/// Работает с [ClientModelComposite].
class ClientSearchDelegate extends SearchDelegate<ClientModelComposite?> {
  final ClientService _clientService;
  final Function(ClientModelComposite)
      _onClientSelected; // Функция обратного вызова при выборе

  ClientSearchDelegate(this._clientService, this._onClientSelected);

  @override
  String get searchFieldLabel => t.clients.search; // Используем глобальный t

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty) // Показываем кнопку очистки только если есть текст
        IconButton(
          icon: const Icon(Icons.clear),
          tooltip: t.common.clear, // Добавляем tooltip
          onPressed: () {
            query = '';
            showSuggestions(context); // Показываем пустые подсказки
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      tooltip: MaterialLocalizations.of(context)
          .backButtonTooltip, // Стандартный tooltip
      onPressed: () {
        close(context, null); // Закрываем поиск без результата
      },
    );
  }

  // Результаты поиска (когда пользователь нажимает Enter)
  @override
  Widget buildResults(BuildContext context) {
    // Используем FutureBuilder для асинхронного поиска
    return FutureBuilder<List<ClientModelComposite>>(
      future: _clientService.searchClients(query), // Вызываем поиск в сервисе
      builder: (context, snapshot) {
        final t = context.t; // Получаем локализацию

        if (query.isEmpty) {
          return Center(child: Text(t.clients.startTyping));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          // Логируем ошибку
          AppLoggers.clientsLogger.e(
              LogMessages.clientSearchError.replaceAll('{query}', query),
              error: snapshot.error,
              stackTrace: snapshot.stackTrace);
          return Center(
            child: Text(
              t.core.errorLoadingData(error: snapshot.error.toString()),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }

        final clients = snapshot.data ?? [];

        if (clients.isEmpty) {
          return Center(child: Text(t.clients.noClientsFound));
        }

        // Отображаем найденных клиентов
        return ListView.separated(
          itemCount: clients.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final client = clients[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: _getClientTypeColor(client.type),
                child:
                    Icon(_getClientTypeIcon(client.type), color: Colors.white),
              ),
              title: Text(client.displayName),
              subtitle: Text('${client.code} · ${client.contactInfo}'),
              onTap: () {
                close(context, client); // Закрываем поиск с выбранным клиентом
                _onClientSelected(client); // Вызываем колбэк
              },
            );
          },
        );
      },
    );
  }

  // Подсказки во время ввода
  @override
  Widget buildSuggestions(BuildContext context) {
    // Можно показывать недавние поиски или просто результаты
    // Пока просто вызываем buildResults
    if (query.isEmpty) {
      return Center(child: Text(context.t.clients.startTyping));
    }
    return buildResults(context);
  }

  // --- Вспомогательные методы для иконок/цветов (дублируются из _ClientsScreenState) ---
  Color _getClientTypeColor(ClientType type) {
    switch (type) {
      case ClientType.physical:
        return Colors.blue;
      case ClientType.legal:
        return Colors.orange;
      case ClientType.individualEntrepreneur:
        return Colors.green;
      case ClientType.other:
        return Colors.grey;
    }
  }

  IconData _getClientTypeIcon(ClientType type) {
    switch (type) {
      case ClientType.physical:
        return Icons.person;
      case ClientType.legal:
        return Icons.business;
      case ClientType.individualEntrepreneur:
        return Icons.business_center;
      case ClientType.other:
        return Icons.help_outline;
    }
  }
}

// Добавление методов copyWith в ClientModelComposite для удобства обновления
// (Это нужно добавить в сам файл client_model_composite.dart)
extension ClientModelCompositeCopyWith on ClientModelComposite {
  ClientModelComposite copyWithCoreData({
    String? uuid,
    String? code,
    String? displayName,
    DateTime? createdAt,
    DateTime? modifiedAt,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return ClientModelComposite.fromData(
      coreData.copyWith(
        uuid: uuid ?? this.uuid,
        code: code ?? this.code,
        displayName: displayName ?? this.displayName,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        // isDeleted вычисляется из deletedAt, но можно передать для явности
        isDeleted: isDeleted ?? (deletedAt != null ? true : this.isDeleted),
      ),
      clientData,
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: itemsMap,
    );
  }

  ClientModelComposite copyWithClientData({
    ClientType? type,
    String? contactInfo,
    String? additionalInfo,
  }) {
    return ClientModelComposite.fromData(
      coreData,
      clientData.copyWith(
        type: type ?? this.type,
        contactInfo: contactInfo ?? this.contactInfo,
        additionalInfo: additionalInfo ?? this.additionalInfo,
      ),
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: itemsMap,
    );
  }
}
