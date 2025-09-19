import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/suppliers/api/api_client_manager.dart';
import 'package:part_catalog/features/suppliers/services/parts_price_service.dart';

/// Провайдер для ApiClientManager
final apiClientManagerProvider = Provider<ApiClientManager>((ref) {
  return locator<ApiClientManager>();
});

/// Провайдер для PartsPriceService
final partsPriceServiceProvider = Provider<PartsPriceService>((ref) {
  return locator<PartsPriceService>();
});