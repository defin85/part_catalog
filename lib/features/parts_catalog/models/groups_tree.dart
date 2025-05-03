import 'package:freezed_annotation/freezed_annotation.dart';

part 'groups_tree.freezed.dart';
part 'groups_tree.g.dart';

/// {@template groups_tree}
/// Модель данных для дерева групп.
/// {@endtemplate}
@freezed
abstract class GroupsTree with _$GroupsTree {
  /// {@macro groups_tree}
  factory GroupsTree({
    /// Идентификатор.
    @JsonKey(name: 'id') required String id,

    /// Название.
    @JsonKey(name: 'name') required String name,

    /// Идентификатор родительской группы (может быть null).
    @JsonKey(name: 'parentId') String? parentId,

    /// Список подгрупп.
    @JsonKey(name: 'subGroups') @Default([]) List<GroupsTree> subGroups,
  }) = _GroupsTree;

  /// Преобразует JSON в объект [GroupsTree].
  factory GroupsTree.fromJson(Map<String, dynamic> json) =>
      _$GroupsTreeFromJson(json);
}
