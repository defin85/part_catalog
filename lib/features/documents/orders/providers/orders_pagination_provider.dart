import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/features/documents/orders/providers/order_providers.dart';

part 'orders_pagination_provider.g.dart';

const _pageSize = 20;

class OrdersPaginationState {
  final List<OrderHeaderData> orders;
  final bool hasReachedMax;

  const OrdersPaginationState({
    this.orders = const [],
    this.hasReachedMax = false,
  });

  OrdersPaginationState copyWith({
    List<OrderHeaderData>? orders,
    bool? hasReachedMax,
  }) {
    return OrdersPaginationState(
      orders: orders ?? this.orders,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

@riverpod
class OrdersPaginationNotifier extends _$OrdersPaginationNotifier {
  @override
  Future<OrdersPaginationState> build() async {
    final orders = await _fetchPage(0);
    return OrdersPaginationState(
      orders: orders,
      hasReachedMax: orders.length < _pageSize,
    );
  }

  Future<List<OrderHeaderData>> _fetchPage(int page) {
    final orderService = ref.read(orderServiceProvider);
    // This is a bit of a hack, as watchOrderHeadersPaginated returns a Stream,
    // but we need a Future. We take the first event from the stream.
    return orderService
        .watchOrderHeadersPaginated(
          limit: _pageSize,
          offset: page * _pageSize,
        )
        .first;
  }

  Future<void> fetchNextPage() async {
    // Don't fetch if we've already reached the max or if we're already loading.
    if (state.value?.hasReachedMax ?? true) return;
    if (state is AsyncLoading) return;

    state = const AsyncLoading();

    final currentPage = (state.value!.orders.length / _pageSize).floor();
    final newOrders = await _fetchPage(currentPage + 1);

    state = AsyncData(
      state.value!.copyWith(
        orders: [...state.value!.orders, ...newOrders],
        hasReachedMax: newOrders.length < _pageSize,
      ),
    );
  }
}
