import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:part_catalog/core/service_locator.dart';

/// Наблюдатель за состоянием провайдеров Riverpod.
///
/// Логирует ошибки, возникающие в провайдерах, для централизованного
/// отслеживания и отладки.
class AppProviderObserver extends ProviderObserver {
  final Logger _logger = locator<Logger>();

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    _logger.e(
      'Provider [${provider.name ?? provider.runtimeType}] failed',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
