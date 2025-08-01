import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/core/database/database.dart'; // Для SupplierSettingsItemData
import 'package:part_catalog/features/suppliers/models/armtek/brand_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/store_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_response.dart';
// Предполагается, что у вас есть модели для ответа API Armtek,
// если нет, можно использовать Map<String, dynamic> или создать их.
import 'package:part_catalog/features/suppliers/models/armtek/user_vkorg.dart';

part 'armtek_settings_state.freezed.dart';

@freezed
abstract class ArmtekSettingsState with _$ArmtekSettingsState {
  const factory ArmtekSettingsState({
    @Default(false) bool isLoading,
    String? errorMessage,
    // Поля для ввода учетных данных
    @Default('') String loginInput,
    @Default('') String passwordInput,
    // Статус подключения и информация
    String? connectionStatusMessage,
    @Default(false) bool isConnected,
    SupplierSettingsItem? currentSetting,
    // Данные от Armtek
    List<UserVkorg>? userVkorgList,
    String? selectedVkorg,
    UserInfoResponse? userInfo, // Исправлен тип
    List<StoreItem>? storeList, // Исправлен тип
    List<BrandItem>? brandList, // Исправлен тип
    @Default(false) bool isLoadingArmtekData,
  }) = _ArmtekSettingsState;

  factory ArmtekSettingsState.initial() => const ArmtekSettingsState();
}
