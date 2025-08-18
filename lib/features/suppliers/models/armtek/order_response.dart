import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_response.freezed.dart';
part 'order_response.g.dart';

/// Ответ на создание заказа
@freezed
abstract class OrderResponse with _$OrderResponse {
  const factory OrderResponse({
    @JsonKey(name: 'ORDER_ID') String? orderId,
    @JsonKey(name: 'STATUS') String? status,
    @JsonKey(name: 'MESSAGE') String? message,
    @JsonKey(name: 'TOTAL_AMOUNT') double? totalAmount,
    Map<String, dynamic>? additionalData,
  }) = _OrderResponse;

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
}
