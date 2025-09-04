import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:part_catalog/features/parts_catalog/models/groups_tree.dart';

part 'groups_tree_response.freezed.dart';
part 'groups_tree_response.g.dart';

/// {@template groups_tree_response}
/// Модель данных для ответа с деревом групп.
/// {@endtemplate}
@freezed
abstract class GroupsTreeResponse with _$GroupsTreeResponse {
  /// {@macro groups_tree_response}
  factory GroupsTreeResponse({
    /// Идентификатор.
    @JsonKey(name: 'id') required String id,

    /// Название.
    @JsonKey(name: 'name') required String name,

    /// Идентификатор родительской группы (может быть null).
    @JsonKey(name: 'parentId') String? parentId,

    /// Список подгрупп.
    @JsonKey(name: 'subGroups') List<GroupsTree>? subGroups,
  }) = _GroupsTreeResponse;

  /// Преобразует JSON в объект [GroupsTreeResponse].
  factory GroupsTreeResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupsTreeResponseFromJson(json);
}
