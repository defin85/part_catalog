//import 'package:flutter/material.dart'; // Для IconData, если будете использовать
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';

part 'api_control_center_state.freezed.dart';

@freezed
abstract class SupplierDisplayInfo with _$SupplierDisplayInfo {
  const factory SupplierDisplayInfo({
    required String code,
    required String displayName,
    required String status,
    required bool isConfigured,
    // IconData? icon, // Если будете использовать иконки
  }) = _SupplierDisplayInfo;
}

@freezed
abstract class ApiControlCenterState with _$ApiControlCenterState {
  const factory ApiControlCenterState({
    @Default(ApiConnectionMode.direct) ApiConnectionMode apiMode,
    @Default('') String proxyUrl,
    @Default([]) List<SupplierDisplayInfo> suppliers,
    @Default(true) bool isLoading,
    String? error,
  }) = _ApiControlCenterState;

  factory ApiControlCenterState.initial() => const ApiControlCenterState();
}
