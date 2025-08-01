import 'dart:async'; // Для Timer

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/providers/core_providers.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/core/utils/log_messages.dart';
// Импортируем бизнес-модель (композитор)
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/features/references/clients/models/client_type.dart';
// Импортируем провайдеры
import 'package:part_catalog/features/references/clients/providers/client_providers.dart';
import 'package:part_catalog/features/references/clients/services/client_service.dart';
// Импортируем сервисы для обновления в service_locator при сбросе БД
import 'package:part_catalog/features/references/vehicles/services/car_service.dart';

// Преобразуем в ConsumerStatefulWidget
class ClientsScreen extends ConsumerStatefulWidget {
  const ClientsScreen({super.key});

  @override
  ConsumerState<ClientsScreen> createState() => _ClientsScreenState();
}

// Преобразуем State в ConsumerState
class _ClientsScreenState extends ConsumerState<ClientsScreen> {
  // Удаляем прямое получение сервиса, будем использовать ref
  // final ClientService _clientService = locator<ClientService>();

  // Объявляем логгер как late final и инициализируем в initState
  late final Logger _logger;

  // Удаляем _isDbError, состояние ошибки будет в AsyncValue
  // bool _isDbError = false;
  final TextEditingController _searchController = TextEditingController();
  // Удаляем BehaviorSubject и подписку
  // final _searchSubject = BehaviorSubject<String?>.seeded(null);
  // StreamSubscription? _searchSubscription;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Инициализируем логгер здесь, где ref доступен
    _logger = ref.read(clientsLoggerProvider);
    _searchController.addListener(_onSearchChanged);
    // Удаляем подписку на BehaviorSubject
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    // Удаляем закрытие BehaviorSubject и отмену подписки
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text;
      // Вызываем метод поиска у Notifier'а
      ref.read(clientsNotifierProvider.notifier).searchClients(query);
    });
  }

  // Удаляем _getClientStream, будем использовать ref.watch(clientsNotifierProvider)

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    // Получаем состояние списка клиентов через ref.watch
    final clientsAsyncValue = ref.watch(clientsNotifierProvider);

    // Обработка ошибки БД (если она приводит к ошибке в Notifier)
    // Можно сделать более специфично, проверяя тип ошибки в .when()
    // if (_isDbError) { ... } - Удаляем этот блок

    return Scaffold(
      appBar: AppBar(
        title: Text(t.clients.screenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                // Передаем ref в делегат
                delegate: ClientSearchDelegate(ref, _editClient),
              );
            },
          ),
          // Кнопка сброса БД (можно оставить или перенести в настройки)
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            tooltip: t.core.resetDatabase,
            onPressed: () => _showResetConfirmation(context),
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
                          // Вызываем поиск с пустой строкой
                          ref
                              .read(clientsNotifierProvider.notifier)
                              .searchClients(null);
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          // Список клиентов
          Expanded(
            // Используем .when для обработки состояний AsyncValue
            child: clientsAsyncValue.when(
              data: (clients) {
                if (clients.isEmpty) {
                  return Center(
                    child: Text(_searchController.text.isEmpty
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
                          _confirmDeletion(context, client),
                      onDismissed: (direction) =>
                          _deleteClient(context, client),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getClientTypeColor(client.type),
                          child: Icon(
                            _getClientTypeIcon(client.type),
                            color: Colors.white,
                          ),
                        ),
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
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) {
                _logger.e(LogMessages.dataLoadingError,
                    error: error, stackTrace: stackTrace);
                // Проверяем ошибку БД (если она специфична)
                if (error.toString().contains('no such table')) {
                  // Можно показать кнопку сброса прямо здесь
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(t.core.dataLoadingError),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _showResetConfirmation(context),
                          child: Text(t.core.resetDatabase),
                        )
                      ],
                    ),
                  );
                }
                // Показываем общую ошибку загрузки данных
                return Center(
                  child: Text(
                    t.core.errorLoadingData(error: error.toString()),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addClient,
        tooltip: t.clients.add,
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- Методы для действий ---

  Future<void> _showResetConfirmation(BuildContext context) async {
    // Захватываем ВСЕ необходимые значения из context ПЕРЕД await
    final t = context.t;
    final currentColorScheme = Theme.of(context).colorScheme;
    // Захватываем ScaffoldMessengerState здесь, до await
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(t.core.confirmResetDatabaseTitle),
          content: Text(t.core.confirmResetDatabaseMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(t.common.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(t.core.resetDatabase,
                  style: TextStyle(color: currentColorScheme.error)),
            ),
          ],
        );
      },
    );

    // Проверяем, смонтирован ли виджет, после await
    if (!mounted) return;

    if (confirmed == true) {
      // Передаем захваченные scaffoldMessenger и t, а не context
      await _resetDatabase(scaffoldMessenger, t);
    }
  }

  Future<void> _resetDatabase(
      ScaffoldMessengerState scaffoldMessenger, Translations t) async {
    // final scaffoldMessenger = ScaffoldMessenger.of(context); // Больше не используется context
    // final t = context.t; // Больше не используется context

    try {
      final db = locator<AppDatabase>();
      await db.resetDatabase();

      // Обновляем экземпляры в сервис-локаторе
      locator.unregister<AppDatabase>();
      locator.registerSingleton<AppDatabase>(AppDatabase());

      locator.unregister<ClientService>();
      locator.unregister<CarService>();
      locator.registerLazySingleton<ClientService>(
          () => ClientService(locator<AppDatabase>()));
      locator.registerLazySingleton<CarService>(
          () => CarService(locator<AppDatabase>()));

      // Инвалидируем провайдеры Riverpod
      ref.invalidate(clientServiceProvider);
      ref.invalidate(clientsNotifierProvider);
      // Инвалидируйте другие связанные провайдеры, если они есть

      if (mounted) {
        // mounted здесь - это свойство ConsumerState
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text(t.core.resetDatabaseSuccess)));
      }
    } catch (e, s) {
      _logger.e(LogMessages.databaseResetError, error: e, stackTrace: s);
      if (mounted) {
        // mounted здесь - это свойство ConsumerState
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(t.core.resetDatabaseError(error: e.toString()))));
      }
    }
  }

  Future<bool?> _confirmDeletion(
      BuildContext context, ClientModelComposite client) async {
    final t = context.t;
    // Захватываем цветовую схему из исходного контекста, если она нужна для стиля кнопки в диалоге
    // final currentColorScheme = Theme.of(context).colorScheme;

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            // dialogContext - новый, валидный контекст для билдера диалога
            return AlertDialog(
              title: Text(t.common.confirmDeletion),
              content: Text(t.clients.confirmDelete(name: client.displayName)),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(t.common.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(t.common.delete,
                      style: TextStyle(
                          color: Theme.of(dialogContext)
                              .colorScheme
                              .error)), // Используем dialogContext для Theme
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _deleteClient(
      BuildContext context, ClientModelComposite client) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final t = context.t;
    final clientUuid = client.uuid;
    final displayName = client.displayName; // Сохраняем для Snackbar

    try {
      // Вызываем метод Notifier'а
      await ref.read(clientsNotifierProvider.notifier).deleteClient(clientUuid);

      // Показываем Snackbar об успехе с отменой
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(t.clients.clientDeleted(name: displayName)),
            action: SnackBarAction(
              label: t.common.undo,
              onPressed: () => _restoreClient(
                  context, clientUuid, displayName), // Передаем UUID и имя
            ),
          ),
        );
      }
    } catch (e, s) {
      // Ошибки теперь обрабатываются здесь, т.к. Notifier их пробрасывает
      _logger.e(LogMessages.clientDeleteError.replaceAll('{uuid}', clientUuid),
          error: e, stackTrace: s);
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(t.clients.deleteError(error: e.toString()))),
        );
      }
    }
  }

  Future<void> _restoreClient(
      BuildContext context, String clientUuid, String displayName) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final t = context.t;

    try {
      // Вызываем метод Notifier'а
      await ref
          .read(clientsNotifierProvider.notifier)
          .restoreClient(clientUuid);
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(t.clients.clientRestored(name: displayName))),
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
    // Захватываем ScaffoldMessenger и Translations до await
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final t = context.t;

    final newClient = await _showClientDialog(context, ref: ref);

    if (!mounted) return; // Проверка после await

    if (newClient != null) {
      try {
        await ref.read(clientsNotifierProvider.notifier).addClient(newClient);
        if (mounted) {
          // Дополнительная проверка mounted перед использованием scaffoldMessenger
          scaffoldMessenger.showSnackBar(SnackBar(
              content:
                  Text(t.clients.clientAdded(name: newClient.displayName))));
        }
      } catch (e, s) {
        _logger.e(LogMessages.clientAddError, error: e, stackTrace: s);
        if (mounted) {
          // Дополнительная проверка mounted
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(t.clients.addError(error: e.toString()))),
          );
        }
      }
    }
  }

  Future<void> _editClient(ClientModelComposite client) async {
    // Захватываем ScaffoldMessenger и Translations до await
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final t = context.t;

    final updatedClient =
        await _showClientDialog(context, client: client, ref: ref);

    if (!mounted) return; // Проверка после await

    if (updatedClient != null) {
      try {
        await ref
            .read(clientsNotifierProvider.notifier)
            .updateClient(updatedClient);
        if (mounted) {
          // Дополнительная проверка mounted
          scaffoldMessenger.showSnackBar(SnackBar(
              content: Text(
                  t.clients.clientUpdated(name: updatedClient.displayName))));
        }
      } catch (e, s) {
        _logger.e(
            LogMessages.clientUpdateError.replaceAll('{uuid}', client.uuid),
            error: e,
            stackTrace: s);
        if (mounted) {
          // Дополнительная проверка mounted
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(t.clients.updateError(error: e.toString()))),
          );
        }
      }
    }
  }

  // --- Вспомогательные методы ---

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

  /// Показывает диалог для добавления/редактирования клиента.
  /// Принимает [WidgetRef] для доступа к провайдерам.
  Future<ClientModelComposite?> _showClientDialog(BuildContext context,
      {ClientModelComposite? client, required WidgetRef ref}) async {
    // Добавляем ref
    final t = context.t;
    final bool isEditing = client != null;

    final nameController = TextEditingController(text: client?.displayName);
    final codeController = TextEditingController(text: client?.code);
    final contactInfoController =
        TextEditingController(text: client?.contactInfo);
    final additionalInfoController =
        TextEditingController(text: client?.additionalInfo);
    ClientType selectedType = client?.type ?? ClientType.physical;

    final formKey = GlobalKey<FormState>();
    // Локальное состояние для асинхронной валидации кода
    bool codeCheckLoading = false;
    bool isCodeUnique = true;

    return showDialog<ClientModelComposite>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          // Асинхронная валидация уникальности кода с использованием isClientCodeUniqueProvider
          Future<void> checkCodeUniqueness(String value) async {
            if (value.isNotEmpty && value != client?.code) {
              setStateDialog(() {
                codeCheckLoading = true; // Показываем индикатор
                isCodeUnique = true; // Сбрасываем предыдущую ошибку
              });
              try {
                // Используем ref для доступа к провайдеру
                final unique = await ref.read(isClientCodeUniqueProvider(
                  code: value,
                  excludeUuid: client?.uuid,
                ).future);
                if (mounted) {
                  // Проверяем mounted перед setStateDialog
                  setStateDialog(() {
                    isCodeUnique = unique;
                    codeCheckLoading = false;
                  });
                }
              } catch (e) {
                if (mounted) {
                  setStateDialog(() {
                    isCodeUnique = false; // Считаем не уникальным при ошибке
                    codeCheckLoading = false;
                  });
                }
                // Логируем ошибку проверки
                _logger.e('Error checking code uniqueness', error: e);
              }
            } else {
              if (mounted) {
                setStateDialog(() {
                  isCodeUnique = true;
                  codeCheckLoading = false;
                });
              }
            }
          }

          // Валидация всей формы
          bool validateFullForm() {
            return (formKey.currentState?.validate() ?? false) &&
                isCodeUnique &&
                !codeCheckLoading;
          }

          return AlertDialog(
            title: Text(isEditing ? t.clients.edit : t.clients.add),
            content: Form(
              key: formKey,
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
                              Text(_getClientTypeDisplayName(context, type)),
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
                        // Показываем индикатор загрузки или ошибку
                        suffixIcon: codeCheckLoading
                            ? const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2.0)),
                              )
                            : (!isCodeUnique
                                ? const Icon(Icons.error, color: Colors.red)
                                : null),
                        errorText:
                            !isCodeUnique ? t.clients.codeNotUnique : null,
                        // Убираем errorMaxLines, т.к. используем suffixIcon для индикации ошибки
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return t.clients.codeRequired;
                        }
                        return null;
                      },
                      onChanged: (value) async {
                        // Добавляем debounce для проверки кода
                        _debounce?.cancel();
                        _debounce =
                            Timer(const Duration(milliseconds: 400), () async {
                          await checkCodeUniqueness(value);
                          // Обновляем состояние кнопки после проверки
                          setStateDialog(() {});
                        });
                        // Обновляем состояние кнопки сразу при изменении
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
                      onChanged: (_) => setStateDialog(() {}),
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
                      onChanged: (_) => setStateDialog(() {}),
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
                      onChanged: (_) => setStateDialog(() {}),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(t.common.cancel),
              ),
              TextButton(
                onPressed: validateFullForm()
                    ? () {
                        final result = isEditing
                            ? client
                                .copyWithCoreData(
                                  // Используем лямбда-функцию для обновления coreData
                                  (core) => core.copyWith(
                                    code: codeController.text.trim(),
                                    displayName: nameController.text.trim(),
                                    modifiedAt: DateTime.now(),
                                  ),
                                )
                                .copyWithClientData(
                                  // Используем лямбда-функцию для обновления clientData
                                  (clientSpecific) => clientSpecific.copyWith(
                                    type: selectedType,
                                    contactInfo:
                                        contactInfoController.text.trim(),
                                    additionalInfo: additionalInfoController
                                            .text
                                            .trim()
                                            .isEmpty
                                        ? null
                                        : additionalInfoController.text.trim(),
                                  ),
                                )
                            : ClientModelComposite.create(
                                code: codeController.text.trim(),
                                displayName: nameController.text.trim(),
                                type: selectedType,
                                contactInfo: contactInfoController.text.trim(),
                                additionalInfo:
                                    additionalInfoController.text.trim().isEmpty
                                        ? null
                                        : additionalInfoController.text.trim(),
                              );
                        Navigator.of(dialogContext).pop(result);
                      }
                    : null,
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
class ClientSearchDelegate extends SearchDelegate<ClientModelComposite?> {
  // Принимаем WidgetRef вместо ClientService
  final WidgetRef ref;
  final Function(ClientModelComposite) _onClientSelected;

  ClientSearchDelegate(this.ref, this._onClientSelected);

  // Получаем логгер через ref
  Logger get _logger => ref.read(clientsLoggerProvider);

  @override
  String get searchFieldLabel => t.clients.search;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          tooltip: t.common.clear,
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        close(context, null);
      },
    );
  }

  // Результаты поиска
  @override
  Widget buildResults(BuildContext context) {
    // Используем FutureBuilder и получаем сервис через ref.read
    return FutureBuilder<List<ClientModelComposite>>(
      // Вызываем поиск через сервис, полученный из провайдера
      future: ref.read(clientServiceProvider).searchClients(query),
      builder: (context, snapshot) {
        final t = context.t;

        if (query.isEmpty) {
          return Center(child: Text(t.clients.startTyping));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          _logger.e(LogMessages.clientSearchError.replaceAll('{query}', query),
              error: snapshot.error, stackTrace: snapshot.stackTrace);
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
                close(context, client);
                _onClientSelected(client);
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
    if (query.isEmpty) {
      return Center(child: Text(context.t.clients.startTyping));
    }
    // Можно добавить логику показа недавних запросов или сразу результаты
    return buildResults(context);
  }

  // --- Вспомогательные методы для иконок/цветов ---
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

// Удаляем расширение ClientModelCompositeCopyWith, т.к. оно уже должно быть
// в файле client_model_composite.dart или сгенерировано @freezed, если используется.
// Если его там нет, его нужно добавить в соответствующий файл.
