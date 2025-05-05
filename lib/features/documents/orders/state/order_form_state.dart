import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/features/core/i_document_item_entity.dart';
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';

part 'order_form_state.freezed.dart';

@freezed
abstract class OrderFormState with _$OrderFormState {
  const factory OrderFormState({
    @Default(false) bool isLoading, // Загрузка начальных данных
    @Default(false) bool isSaving, // Процесс сохранения
    String? error, // Сообщение об ошибке
    OrderModelComposite?
        initialOrder, // Исходный заказ для режима редактирования
    ClientModelComposite? selectedClient,
    CarModelComposite? selectedCar,
    DateTime? scheduledDate,
    @Default('') String description,
    @Default({}) Map<String, IDocumentItemEntity> itemsMap,
    @Default(false) bool isEditMode,
  }) = _OrderFormState;
}
