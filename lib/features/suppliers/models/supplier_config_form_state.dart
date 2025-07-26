import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';

part 'supplier_config_form_state.freezed.dart';

/// Состояние для формы редактирования конфигурации
@freezed
class SupplierConfigFormState with _$SupplierConfigFormState {
  const factory SupplierConfigFormState({
    SupplierConfig? config,
    @Default(false) bool isLoading,
    @Default(false) bool isTesting,
    String? error,
    @Default([]) List<String> validationErrors,
  }) = _SupplierConfigFormState;
}