import 'package:freezed_annotation/freezed_annotation.dart';

part 'generic_response.freezed.dart';
part 'generic_response.g.dart';

/// Общий ответ для методов, возвращающих произвольный JSON
@freezed
abstract class GenericResponse with _$GenericResponse {
  const factory GenericResponse({
    Map<String, dynamic>? data,
  }) = _GenericResponse;

  factory GenericResponse.fromJson(Map<String, dynamic> json) =>
      _$GenericResponseFromJson(json);
}

/// Список общих ответов
@freezed
abstract class GenericListResponse with _$GenericListResponse {
  const factory GenericListResponse({
    List<Map<String, dynamic>>? items,
  }) = _GenericListResponse;

  factory GenericListResponse.fromJson(Map<String, dynamic> json) =>
      _$GenericListResponseFromJson(json);
}