import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_prices_response.freezed.dart';
part 'example_prices_response.g.dart';

/// {@template example_prices_response}
/// Модель данных для ответа с примером цен.
/// {@endtemplate}
@freezed
abstract class ExamplePricesResponse with _$ExamplePricesResponse {
  /// {@macro example_prices_response}
  factory ExamplePricesResponse({
    /// Идентификатор.
    @JsonKey(name: 'id') String? id,

    /// Название.
    @JsonKey(name: 'title') String? title,

    /// Код.
    @JsonKey(name: 'code') String? code,

    /// Бренд.
    @JsonKey(name: 'brand') String? brand,

    /// Цена.
    @JsonKey(name: 'price') String? price,

    /// Количество в корзине.
    @JsonKey(name: 'basketQty') String? basketQty,

    /// Количество в наличии.
    @JsonKey(name: 'inStockQty') String? inStockQty,

    /// Рейтинг.
    @JsonKey(name: 'rating') String? rating,

    /// Доставка.
    @JsonKey(name: 'delivery') String? delivery,

    /// Полезная нагрузка (payload).
    @JsonKey(name: 'payload') Map<String, String>? payload,
  }) = _ExamplePricesResponse;

  /// Преобразует JSON в объект [ExamplePricesResponse].
  factory ExamplePricesResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamplePricesResponseFromJson(json);
}
