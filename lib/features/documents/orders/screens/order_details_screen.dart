import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Импорт Riverpod
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
// --- Обновленные импорты ---
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/utils/log_messages.dart';
import 'package:part_catalog/features/core/document_status.dart';
import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:part_catalog/features/core/i_document_item_entity.dart';
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/documents/orders/models/order_part_model_composite.dart';
import 'package:part_catalog/features/documents/orders/models/order_service_model_composite.dart';
import 'package:part_catalog/features/documents/orders/screens/order_form_screen.dart';
// Импортируем провайдеры
import 'package:part_catalog/features/documents/orders/providers/order_providers.dart';
import 'package:part_catalog/core/providers/core_providers.dart'; // Для appLoggerProvider

// Преобразуем в ConsumerWidget
class OrderDetailsScreen extends ConsumerWidget {
  final String orderUuid;

  const OrderDetailsScreen({
    super.key,
    required this.orderUuid,
  });

  // Удаляем State, initState, dispose

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Добавляем WidgetRef
    final theme = Theme.of(context);
    final t = context.t; // Для краткости
    // Получаем логгер через ref
    final logger = ref.watch(ordersLoggerProvider);

    // Следим за состоянием заказа через провайдер
    final orderAsyncValue = ref.watch(orderDetailsStreamProvider(orderUuid));

    return Scaffold(
      appBar: AppBar(
        title: Text(t.orders.orderDetailsTitle),
        actions: [
          // Кнопки действий будут доступны только после загрузки данных
          orderAsyncValue.when(
            data: (order) {
              if (order.isDeleted) {
                return const SizedBox
                    .shrink(); // Не показывать кнопки, если удалено
              }
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: t.common.edit,
                    onPressed: () =>
                        _editOrder(context, order), // Передаем context
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: t.common.delete,
                    onPressed: () => _confirmDelete(context, ref, order,
                        logger), // Передаем context, ref, logger
                  ),
                ],
              );
            },
            loading: () => const Padding(
              // Показываем заглушку во время загрузки
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, __) =>
                const SizedBox.shrink(), // Не показываем кнопки при ошибке
          ),
        ],
      ),
      body: orderAsyncValue.when(
        data: (order) {
          if (order.isDeleted) {
            // Отображение, если заказ удален
            return Center(
              child: Text(
                t.orders.orderNotFound, // Или "Заказ удален"
              ),
            );
          }
          // Основной контент экрана
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок и статус
                _buildHeader(context, order, theme, t), // Передаем context
                const Divider(height: 32),

                // Информация о клиенте и автомобиле
                _buildClientAndCarInfo(
                    context, ref, order, theme, t), // Передаем context, ref
                const Divider(height: 32),

                // Описание проблемы
                if (order.description != null && order.description!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.orders.problemDescription,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(order.description!), // Уже проверили на null
                      const Divider(height: 32),
                    ],
                  ),

                // Запчасти
                _buildItemsList(context, ref, order, theme, t,
                    BaseItemType.part, logger), // Передаем context, ref, logger
                const SizedBox(height: 24),

                // Работы/услуги
                _buildItemsList(
                    context,
                    ref,
                    order,
                    theme,
                    t,
                    BaseItemType.service,
                    logger), // Передаем context, ref, logger
                const SizedBox(height: 24),

                // Итого и дата
                _buildTotalAndDates(
                    context, order, theme, t), // Передаем context
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          logger.e(LogMessages.orderDetailsStreamBuilderError,
              error: error, stackTrace: stackTrace);
          return Center(
            child: Text(
              t.common.dataLoadingError,
              style: const TextStyle(color: Colors.red),
            ),
          );
        },
      ),
      // Нижняя панель с кнопкой действия
      bottomNavigationBar: orderAsyncValue.maybeWhen(
        data: (order) {
          if (order.isDeleted) {
            return const SizedBox.shrink();
          }
          final nextStatusAction = _getNextStatusAction(order.status, t);
          if (nextStatusAction == null) {
            return const SizedBox.shrink(); // Нет доступных действий
          }

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _changeStatus(
                        context,
                        ref,
                        order,
                        nextStatusAction.status,
                        logger), // Передаем context, ref, logger
                    style: ElevatedButton.styleFrom(
                      backgroundColor: nextStatusAction.color,
                    ),
                    child: Text(nextStatusAction.text),
                  ),
                ),
              ],
            ),
          );
        },
        orElse: () =>
            const SizedBox.shrink(), // Не показывать панель при загрузке/ошибке
      ),
    );
  }

  // --- Методы построения UI (теперь принимают BuildContext) ---

  Widget _buildHeader(BuildContext context, OrderModelComposite order,
      ThemeData theme, Translations t) {
    final dateFormat = DateFormat(
        'dd.MM.yyyy HH:mm', Localizations.localeOf(context).toString());

    // ... остальной код метода без изменений ...
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                // Используем code из coreData
                t.orders.orderNumberFormat(number: order.code),
                style: theme.textTheme.headlineSmall,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                // Используем color из DocumentStatus
                color: order.status.color.withAlpha((255 * 0.2).round()),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                // Используем displayName из DocumentStatus
                order.status.displayName,
                style: TextStyle(
                  color: order.status.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Используем documentDate из docData
        Text(
          t.orders.createdAtDate(date: dateFormat.format(order.documentDate)),
          style: theme.textTheme.bodyMedium,
        ),
        // Используем scheduledDate из docData
        if (order.docData.scheduledDate != null)
          Text(
            t.orders.scheduledForDate(
                date: dateFormat.format(order.docData.scheduledDate!)),
            style: theme.textTheme.bodyMedium,
          ),
        // Используем completedAt из docData
        if (order.docData.completedAt != null)
          Text(
            t.orders.completedAtDate(
                date: dateFormat.format(order.docData.completedAt!)),
            style: theme.textTheme.bodyMedium,
          ),
      ],
    );
  }

  // Используем ref для получения данных клиента/авто через провайдеры
  Widget _buildClientAndCarInfo(BuildContext context, WidgetRef ref,
      OrderModelComposite order, ThemeData theme, Translations t) {
    // Получаем данные клиента через провайдер
    final clientAsyncValue = ref.watch(orderClientProvider(order.clientId));
    // Получаем данные автомобиля через провайдер
    final carAsyncValue = ref.watch(orderCarProvider(order.carId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.orders.clientInfoTitle,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        // Отображение информации о клиенте
        clientAsyncValue.when(
          data: (client) {
            if (client != null) {
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(client.displayName),
                subtitle: Text(client.contactInfo), // Пример
                dense: true,
                contentPadding: EdgeInsets.zero,
                // TODO: Добавить onTap для перехода к клиенту
              );
            } else if (order.clientId != null) {
              // Клиент был, но не загрузился
              return ListTile(
                leading:
                    const Icon(Icons.person_off_outlined, color: Colors.grey),
                title: Text(t.clients.clientNotFound,
                    style: const TextStyle(color: Colors.grey)),
                dense: true,
                contentPadding: EdgeInsets.zero,
              );
            } else {
              // Клиент не был выбран
              return ListTile(
                leading:
                    const Icon(Icons.person_off_outlined, color: Colors.grey),
                title: Text(t.clients.clientNotSelected,
                    style: const TextStyle(color: Colors.grey)),
                dense: true,
                contentPadding: EdgeInsets.zero,
              );
            }
          },
          loading: () => ListTile(
            leading: const Icon(Icons.person),
            title: Text(t.orders.loadingClient),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          error: (e, s) => ListTile(
            // Отображаем ошибку загрузки клиента
            leading: const Icon(Icons.error_outline, color: Colors.red),
            title: Text(t.errors.dataLoadingError,
                style: const TextStyle(color: Colors.red)),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),

        // Отображение информации об автомобиле
        carAsyncValue.when(
          data: (car) {
            if (car != null) {
              return ListTile(
                leading: const Icon(Icons.directions_car),
                title: Text(car.displayName),
                subtitle:
                    Text('${car.vin} / ${car.displayLicensePlate}'), // Пример
                dense: true,
                contentPadding: EdgeInsets.zero,
                // TODO: Добавить onTap для перехода к автомобилю
              );
            } else if (order.carId != null) {
              // Авто было, но не загрузилось
              return ListTile(
                leading:
                    const Icon(Icons.no_transfer_outlined, color: Colors.grey),
                title: Text(t.vehicles.vehicleNotFound,
                    style: const TextStyle(color: Colors.grey)),
                dense: true,
                contentPadding: EdgeInsets.zero,
              );
            } else {
              // Авто не было выбрано
              return ListTile(
                leading:
                    const Icon(Icons.no_transfer_outlined, color: Colors.grey),
                title: Text(t.vehicles.vehicleNotSelected,
                    style: const TextStyle(color: Colors.grey)),
                dense: true,
                contentPadding: EdgeInsets.zero,
              );
            }
          },
          loading: () => ListTile(
            leading: const Icon(Icons.directions_car),
            title: Text(t.orders.loadingVehicle),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          error: (e, s) => ListTile(
            // Отображаем ошибку загрузки авто
            leading: const Icon(Icons.error_outline, color: Colors.red),
            title: Text(t.errors.dataLoadingError,
                style: const TextStyle(color: Colors.red)),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList(
      BuildContext context,
      WidgetRef ref,
      OrderModelComposite order,
      ThemeData theme,
      Translations t,
      BaseItemType itemType,
      Logger logger) {
    // Добавляем ref, logger
    final currencyFormat = NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      symbol: '₽', // TODO: Сделать символ валюты настраиваемым
      decimalDigits: 2,
    );

    final items = order.getItemsByType(itemType);
    final String title = itemType == BaseItemType.part
        ? t.orders.partsList
        : t.orders.servicesList;
    final String noItemsText = itemType == BaseItemType.part
        ? t.orders.noPartsAdded
        : t.orders.noServicesAdded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: Text(t.common.add),
              onPressed: () => itemType == BaseItemType.part
                  ? _addPart(context, order, logger) // Передаем context, logger
                  : _addService(
                      context, order, logger), // Передаем context, logger
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(noItemsText, style: theme.textTheme.bodySmall),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              // Передаем context, ref, logger в _buildItemTile
              return _buildItemTile(
                  context, ref, order, item, currencyFormat, theme, t, logger);
            },
          ),
      ],
    );
  }

  Widget _buildItemTile(
      BuildContext context,
      WidgetRef ref,
      OrderModelComposite order,
      IDocumentItemEntity item,
      NumberFormat currencyFormat,
      ThemeData theme,
      Translations t,
      Logger logger) {
    // Добавляем ref, logger
    final title = item.name;
    final subtitle = item is OrderPartModelComposite
        ? '${item.partNumber}${item.brand != null ? ' (${item.brand})' : ''}'
        : (item as OrderServiceModelComposite).description ??
            ''; // Описание услуги
    final quantity = item.quantity ?? 1.0;
    final price = item.price ?? 0.0;
    final total = item.totalPrice ?? 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormat.format(total),
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (quantity != 1.0 || price != total)
              Text(
                // Заменяем t.locale на Localizations.localeOf(context).toString()
                '${NumberFormat.decimalPatternDigits(locale: Localizations.localeOf(context).toString(), decimalDigits: 2).format(quantity)} x ${currencyFormat.format(price)}',
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
        leading: item is OrderPartModelComposite
            ? _buildPartStatusChip(item, t)
            : _buildServiceStatusChip(item as OrderServiceModelComposite, t),
        onTap: () =>
            _editItem(context, order, item, logger), // Передаем context, logger
        onLongPress: () => _confirmRemoveItem(context, ref, order, item, t,
            logger), // Передаем context, ref, logger
      ),
    );
  }

  // _buildPartStatusChip и _buildServiceStatusChip остаются без изменений

  Widget _buildPartStatusChip(OrderPartModelComposite part, Translations t) {
    IconData icon;
    Color color;
    String label;

    if (part.isReceived) {
      icon = Icons.check_circle;
      color = Colors.green;
      label = t.parts.statusReceived;
    } else if (part.isOrdered) {
      icon = Icons.local_shipping;
      color = Colors.orange;
      label = t.parts.statusOrdered;
    } else {
      icon = Icons.hourglass_empty;
      color = Colors.grey;
      label = t.parts.statusNotOrdered;
    }

    return Tooltip(
      message: label,
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildServiceStatusChip(
      OrderServiceModelComposite service, Translations t) {
    IconData icon;
    Color color;
    String label;

    if (service.isCompleted) {
      icon = Icons.check_circle;
      color = Colors.green;
      label = t.services.statusCompleted;
    } else {
      icon = Icons.build_circle_outlined;
      color = Colors.grey;
      label = t.services.statusNotCompleted;
    }
    return Tooltip(
      message: label,
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildTotalAndDates(BuildContext context, OrderModelComposite order,
      ThemeData theme, Translations t) {
    final currencyFormat = NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      symbol: '₽',
      decimalDigits: 2,
    );
    final dateFormat = DateFormat(
        'dd.MM.yyyy HH:mm', Localizations.localeOf(context).toString());

    // Расчет общей суммы
    final totalAmount = order.items
        .fold<double>(0.0, (sum, item) => sum + (item.totalPrice ?? 0.0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              t.orders.totalAmount,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(width: 16),
            Text(
              currencyFormat.format(totalAmount),
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Используем documentDate из docData
        Text(
          '${t.common.createdAt}: ${dateFormat.format(order.documentDate)}',
          style: theme.textTheme.bodySmall,
        ),
        // Используем modifiedAt из coreData
        if (order.modifiedAt != null)
          Text(
            '${t.common.modifiedAt}: ${dateFormat.format(order.modifiedAt!)}',
            style: theme.textTheme.bodySmall,
          ),
      ],
    );
  }

  // --- Методы действий (теперь принимают BuildContext и WidgetRef) ---

  void _editOrder(BuildContext context, OrderModelComposite order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderFormScreen(orderUuid: order.uuid),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref,
      OrderModelComposite order, Logger logger) async {
    // Получаем сервис через ref
    final orderService = ref.read(orderServiceProvider);
    // Store BuildContext-dependent variables before the async gap.
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final currentContext = context; // Capture context if needed for t
    final t = currentContext.t; // Use captured context for t

    final confirmed = await showDialog<bool>(
      context: currentContext, // Use captured context
      builder: (context) => AlertDialog(
        title: Text(t.common.confirmationTitle),
        content: Text(t.orders.confirmOrderDeletion),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(t.common.delete,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    // Check mounted after the first await - В ConsumerWidget нет mounted, проверка не нужна
    if (confirmed == true) {
      try {
        await orderService.deleteOrder(order.uuid);

        // Check mounted again - не нужно

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(t.orders.orderDeletedSuccess),
            backgroundColor: Colors.green,
          ),
        );
        // Закрыть экран после удаления
        navigator.pop(); // Use captured navigator
      } catch (e, s) {
        logger.e(
            LogMessages.orderDeleteErrorDetails
                .replaceAll('{uuid}', order.uuid),
            error: e,
            stackTrace: s);

        // Check mounted in the catch block - не нужно

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(t.orders.orderDeleteError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _changeStatus(
      BuildContext context,
      WidgetRef ref,
      OrderModelComposite order,
      DocumentStatus nextStatus,
      Logger logger) async {
    // Store BuildContext-dependent variables before the async gap.
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final currentContext = context; // Capture context if needed for t
    final t = currentContext.t; // Use captured context for t

    // Получаем сервис через ref
    final orderService = ref.read(orderServiceProvider);
    try {
      await orderService.changeOrderStatus(order.uuid, nextStatus);
      // Сообщение об успехе не показываем, т.к. UI обновится через Stream
    } catch (e, s) {
      logger.e(
          LogMessages.orderStatusChangeErrorDetails
              .replaceAll('{uuid}', order.uuid)
              .replaceAll('{status}', nextStatus.toString()),
          error: e,
          stackTrace: s);
      // Check mounted - не нужно в ConsumerWidget
      // Используем сохраненный scaffoldMessenger
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(t.orders.statusChangeError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // TODO: Реализовать навигацию или диалоги для добавления/редактирования
  void _addPart(
      BuildContext context, OrderModelComposite order, Logger logger) {
    logger.w(LogMessages.orderAddPartNotImplemented);
    // Navigator.push(context, MaterialPageRoute(builder: (_) => PartFormScreen(orderUuid: order.uuid)));
    final t = context.t;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t.common
            .featureNotImplemented(featureName: t.orders.addPartFeature))));
  }

  void _addService(
      BuildContext context, OrderModelComposite order, Logger logger) {
    logger.w(LogMessages.orderAddServiceNotImplemented);
    // Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceFormScreen(orderUuid: order.uuid)));
    final t = context.t;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t.common
            .featureNotImplemented(featureName: t.orders.addServiceFeature))));
  }

  void _editItem(BuildContext context, OrderModelComposite order,
      IDocumentItemEntity item, Logger logger) {
    logger.w(LogMessages.orderEditItemNotImplemented
        .replaceAll('{runtimeType}', item.runtimeType.toString()));
    final t = context.t;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t.common
            .editingNotImplemented(itemType: item.runtimeType.toString()))));
    // if (item is OrderPartModelComposite) {
    //   Navigator.push(context, MaterialPageRoute(builder: (_) => PartFormScreen(orderUuid: order.uuid, partUuid: item.uuid)));
    // } else if (item is OrderServiceModelComposite) {
    //   Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceFormScreen(orderUuid: order.uuid, serviceUuid: item.uuid)));
    // }
  }

  Future<void> _confirmRemoveItem(
      BuildContext context,
      WidgetRef ref,
      OrderModelComposite order,
      IDocumentItemEntity item,
      Translations t,
      Logger logger) async {
    // Получаем сервис через ref
    final orderService = ref.read(orderServiceProvider);
    // Store BuildContext-dependent variables before the async gap.
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final currentContext = context; // Capture context if needed for t

    final String confirmationText = item is OrderPartModelComposite
        ? t.orders.confirmPartDeletion(name: item.name)
        : t.orders.confirmServiceDeletion(name: item.name);

    final confirmed = await showDialog<bool>(
      context: currentContext, // Use captured context
      builder: (context) => AlertDialog(
        title: Text(t.common.confirmationTitle),
        content: Text(confirmationText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(t.common.remove,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    // Check mounted - не нужно
    if (confirmed == true) {
      try {
        await orderService.removeItemFromOrder(item.uuid, order.uuid);

        // Check mounted - не нужно

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(item is OrderPartModelComposite
                ? t.orders.partRemovedSuccess
                : t.orders.serviceRemovedSuccess),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e, s) {
        logger.e(
            LogMessages.orderRemoveItemErrorDetails
                .replaceAll('{itemUuid}', item.uuid)
                .replaceAll('{orderUuid}', order.uuid),
            error: e,
            stackTrace: s);

        // Check mounted - не нужно

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(item is OrderPartModelComposite
                ? t.orders.partRemoveError
                : t.orders.serviceRemoveError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- Вспомогательные функции (остаются без изменений) ---

  ({String text, Color color, DocumentStatus status})? _getNextStatusAction(
      DocumentStatus currentStatus, Translations t) {
    switch (currentStatus) {
      case DocumentStatus.newDoc:
        return (
          text: t.orders.startWorkAction,
          color: Colors.orange,
          status: DocumentStatus.inProgress
        );
      case DocumentStatus.inProgress:
        // TODO: Добавить логику проверки ожидания запчастей
        return (
          text: t.orders.markReadyAction,
          color: Colors.teal,
          status: DocumentStatus.readyForPickup
        );
      case DocumentStatus.waitingForParts:
        return (
          text: t.orders.resumeWorkAction,
          color: Colors.orange,
          status: DocumentStatus.inProgress
        );
      case DocumentStatus.readyForPickup:
        return (
          text: t.orders.completeOrderAction,
          color: Colors.green,
          status: DocumentStatus.completed
        );
      case DocumentStatus.completed:
      case DocumentStatus.cancelled:
      case DocumentStatus
            .posted: // Считаем проведенный завершенным для UI действий
      case DocumentStatus.unknown:
        return null; // Нет действий для этих статусов
    }
  }
}
