import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/utils/log_messages.dart';
// --- Обновленные импорты ---
import 'package:part_catalog/features/core/document_status.dart';
import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:part_catalog/features/core/i_document_item_entity.dart';
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/documents/orders/models/order_part_model_composite.dart';
import 'package:part_catalog/features/documents/orders/models/order_service_model_composite.dart';
import 'package:part_catalog/features/documents/orders/screens/order_form_screen.dart';
import 'package:part_catalog/features/documents/orders/services/order_service.dart';
// Импорты для получения данных клиента и авто (если нужно)
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/features/references/clients/services/client_service.dart';
import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';
import 'package:part_catalog/features/references/vehicles/services/car_service.dart';
import 'package:part_catalog/core/utils/logger_config.dart'; // Импорт конфигурации логгера

class OrderDetailsScreen extends StatefulWidget {
  final String orderUuid; // Переименовано для ясности

  const OrderDetailsScreen({
    super.key,
    required this.orderUuid,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final _orderService = locator<OrderService>();
  final _clientService = locator<ClientService>(); // Добавлено
  final _carService = locator<CarService>(); // Добавлено
  final _logger = AppLoggers.ordersLogger; // Используем логгер

  late Stream<OrderModelComposite> _orderStream;

  @override
  void initState() {
    super.initState();
    // Используем новый метод сервиса, если он есть, или старый, если он возвращает нужный тип
    _orderStream = _orderService.watchOrderByUuid(widget.orderUuid);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.t; // Для краткости

    return Scaffold(
      appBar: AppBar(
        title: Text(t.orders.orderDetailsTitle),
        actions: [
          // Кнопки действий будут доступны только после загрузки данных
          StreamBuilder<OrderModelComposite>(
            stream: _orderStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isDeleted) {
                return const SizedBox
                    .shrink(); // Не показывать кнопки, если нет данных или удалено
              }
              final order = snapshot.data!;
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: t.common.edit,
                    onPressed: () => _editOrder(order),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: t.common.delete,
                    onPressed: () => _confirmDelete(order),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<OrderModelComposite>(
        stream: _orderStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            _logger.e(LogMessages.orderDetailsStreamBuilderError,
                error: snapshot.error, stackTrace: snapshot.stackTrace);
            return Center(
              child: Text(
                t.common.dataLoadingError,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isDeleted) {
            return Center(
              child: Text(
                t.orders.orderNotFound,
              ),
            );
          }

          final order = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок и статус
                _buildHeader(order, theme, t),
                const Divider(height: 32),

                // Информация о клиенте и автомобиле
                _buildClientAndCarInfo(order, theme, t),
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
                _buildItemsList(order, theme, t, BaseItemType.part),
                const SizedBox(height: 24),

                // Работы/услуги
                _buildItemsList(order, theme, t, BaseItemType.service),
                const SizedBox(height: 24),

                // Итого и дата
                _buildTotalAndDates(order, theme, t),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: StreamBuilder<OrderModelComposite>(
        stream: _orderStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isDeleted) {
            return const SizedBox.shrink();
          }

          final order = snapshot.data!;
          // TODO: Реализовать логику определения следующего статуса
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
                    onPressed: () =>
                        _changeStatus(order, nextStatusAction.status),
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
      ),
    );
  }

  // --- Методы построения UI ---

  Widget _buildHeader(
      OrderModelComposite order, ThemeData theme, Translations t) {
    final dateFormat = DateFormat(
        'dd.MM.yyyy HH:mm', Localizations.localeOf(context).toString());

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

  Widget _buildClientAndCarInfo(
      OrderModelComposite order, ThemeData theme, Translations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.orders.clientInfoTitle,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        // Отображение информации о клиенте
        if (order.clientId != null)
          FutureBuilder<ClientModelComposite?>(
            future: _clientService.getClientByUuid(order.clientId!),
            builder: (context, clientSnapshot) {
              if (clientSnapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(t.orders.loadingClient),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                );
              }
              if (clientSnapshot.hasData && clientSnapshot.data != null) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(clientSnapshot.data!.displayName),
                  subtitle: Text(clientSnapshot.data!.contactInfo), // Пример
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  // TODO: Добавить onTap для перехода к клиенту
                );
              }
              return ListTile(
                leading:
                    const Icon(Icons.person_off_outlined, color: Colors.grey),
                title: Text(t.clients.clientNotFound,
                    style: const TextStyle(color: Colors.grey)),
                dense: true,
                contentPadding: EdgeInsets.zero,
              );
            },
          )
        else
          ListTile(
            leading: const Icon(Icons.person_off_outlined, color: Colors.grey),
            title: Text(t.clients.clientNotSelected,
                style: const TextStyle(color: Colors.grey)),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),

        // Отображение информации об автомобиле
        if (order.carId != null)
          FutureBuilder<CarModelComposite?>(
            future: _carService.getCarByUuid(order.carId!),
            builder: (context, carSnapshot) {
              if (carSnapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  leading: Icon(Icons.directions_car),
                  title: Text(t.orders.loadingVehicle),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                );
              }
              if (carSnapshot.hasData && carSnapshot.data != null) {
                final car = carSnapshot.data!;
                return ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: Text(car.displayName),
                  subtitle:
                      Text('${car.vin} / ${car.displayLicensePlate}'), // Пример
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  // TODO: Добавить onTap для перехода к автомобилю
                );
              }
              return ListTile(
                leading:
                    const Icon(Icons.no_transfer_outlined, color: Colors.grey),
                title: Text(t.vehicles.vehicleNotFound,
                    style: const TextStyle(color: Colors.grey)),
                dense: true,
                contentPadding: EdgeInsets.zero,
              );
            },
          )
        else
          ListTile(
            leading: const Icon(Icons.no_transfer_outlined, color: Colors.grey),
            title: Text(t.vehicles.vehicleNotSelected,
                style: const TextStyle(color: Colors.grey)),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
      ],
    );
  }

  Widget _buildItemsList(OrderModelComposite order, ThemeData theme,
      Translations t, BaseItemType itemType) {
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
                  ? _addPart(order)
                  : _addService(order),
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
              return _buildItemTile(order, item, currencyFormat, theme, t);
            },
          ),
      ],
    );
  }

  Widget _buildItemTile(OrderModelComposite order, IDocumentItemEntity item,
      NumberFormat currencyFormat, ThemeData theme, Translations t) {
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
        onTap: () => _editItem(order, item), // Редактирование по тапу
        onLongPress: () =>
            _confirmRemoveItem(order, item, t), // Удаление по долгому нажатию
      ),
    );
  }

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

  Widget _buildTotalAndDates(
      OrderModelComposite order, ThemeData theme, Translations t) {
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
        Text(
          '${t.common.createdAt}: ${dateFormat.format(order.createdAt)}',
          style: theme.textTheme.bodySmall,
        ),
        if (order.modifiedAt != null)
          Text(
            '${t.common.modifiedAt}: ${dateFormat.format(order.modifiedAt!)}',
            style: theme.textTheme.bodySmall,
          ),
      ],
    );
  }

  // --- Методы действий ---

  void _editOrder(OrderModelComposite order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderFormScreen(orderUuid: order.uuid),
      ),
    );
  }

  Future<void> _confirmDelete(OrderModelComposite order) async {
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

    // Check mounted after the first await
    if (confirmed == true && mounted) {
      try {
        await _orderService.deleteOrder(order.uuid);

        // Check mounted again after the second await
        if (!mounted) return; // Guard subsequent context uses

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(t.orders.orderDeletedSuccess),
            backgroundColor: Colors.green,
          ),
        );
        // Закрыть экран после удаления
        navigator.pop(); // Use captured navigator
      } catch (e, s) {
        _logger.e(
            LogMessages.orderDeleteErrorDetails
                .replaceAll('{uuid}', order.uuid),
            error: e,
            stackTrace: s);

        // Check mounted in the catch block
        if (!mounted) return; // Guard context use in catch

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
      OrderModelComposite order, DocumentStatus nextStatus) async {
    final t = context.t;
    try {
      await _orderService.changeOrderStatus(order.uuid, nextStatus);
      // Сообщение об успехе не показываем, т.к. UI обновится через Stream
    } catch (e, s) {
      _logger.e(
          LogMessages.orderStatusChangeErrorDetails // <-- ИЗМЕНЕНО
              .replaceAll('{uuid}', order.uuid)
              .replaceAll('{status}', nextStatus.toString()),
          error: e,
          stackTrace: s);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.orders.statusChangeError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // TODO: Реализовать навигацию или диалоги для добавления/редактирования
  void _addPart(OrderModelComposite order) {
    _logger.w(LogMessages.orderAddPartNotImplemented); // <-- ИЗМЕНЕНО
    // Navigator.push(context, MaterialPageRoute(builder: (_) => PartFormScreen(orderUuid: order.uuid)));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // Используем slang
        content: Text(t.common
            .featureNotImplemented(featureName: t.orders.addPartFeature))));
  }

  void _addService(OrderModelComposite order) {
    _logger.w(LogMessages.orderAddServiceNotImplemented); // <-- ИЗМЕНЕНО
    // Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceFormScreen(orderUuid: order.uuid)));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // Используем slang
        content: Text(t.common
            .featureNotImplemented(featureName: t.orders.addServiceFeature))));
  }

  void _editItem(OrderModelComposite order, IDocumentItemEntity item) {
    _logger.w(LogMessages.orderEditItemNotImplemented // <-- ИЗМЕНЕНО
        .replaceAll('{runtimeType}', item.runtimeType.toString()));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // Используем slang
        content: Text(t.common
            .editingNotImplemented(itemType: item.runtimeType.toString()))));
    // if (item is OrderPartModelComposite) {
    //   Navigator.push(context, MaterialPageRoute(builder: (_) => PartFormScreen(orderUuid: order.uuid, partUuid: item.uuid)));
    // } else if (item is OrderServiceModelComposite) {
    //   Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceFormScreen(orderUuid: order.uuid, serviceUuid: item.uuid)));
    // }
  }

  Future<void> _confirmRemoveItem(OrderModelComposite order,
      IDocumentItemEntity item, Translations t) async {
    // Store BuildContext-dependent variables before the async gap.
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final currentContext = context; // Capture context if needed for t
    // Note: 't' is already passed as an argument, so capturing it from context might be redundant
    // unless it's used differently elsewhere. We'll keep using the passed 't'.

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

    // Check mounted after the first await
    if (confirmed == true && mounted) {
      try {
        await _orderService.removeItemFromOrder(item.uuid, order.uuid);

        // Check mounted again after the second await
        if (!mounted) return; // Guard subsequent context uses

        scaffoldMessenger.showSnackBar(
          // Use captured scaffoldMessenger
          SnackBar(
            content: Text(item is OrderPartModelComposite
                ? t.orders.partRemovedSuccess
                : t.orders.serviceRemovedSuccess),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e, s) {
        _logger.e(
            LogMessages.orderRemoveItemErrorDetails
                .replaceAll('{itemUuid}', item.uuid)
                .replaceAll('{orderUuid}', order.uuid),
            error: e,
            stackTrace: s);

        // Check mounted in the catch block
        if (!mounted) return; // Guard context use in catch

        scaffoldMessenger.showSnackBar(
          // Use captured scaffoldMessenger
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

  // --- Вспомогательные функции ---

  // Определяет текст и цвет для кнопки следующего действия со статусом
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
