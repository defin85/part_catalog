import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:part_catalog/features/suppliers/models/armtek/user_info_response.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_vkorg.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';

part 'supplier_config_form_state.freezed.dart';

/// Состояние для формы редактирования конфигурации
@freezed
abstract class SupplierConfigFormState with _$SupplierConfigFormState {
  const SupplierConfigFormState._();

  const factory SupplierConfigFormState({
    SupplierConfig? config,
    @Default(false) bool isLoading,
    @Default(false) bool isTesting,
    @Default(false) bool isLoadingVkorgList,
    @Default(false) bool isLoadingUserInfo,
    @Default(false) bool isLoadingBrandList,
    @Default(false) bool isLoadingStoreList,
    String? error,
    @Default([]) List<String> validationErrors,
    @Default([]) List<UserVkorg> availableVkorgList,
    UserInfoResponse? userInfo,
  }) = _SupplierConfigFormState;
}
