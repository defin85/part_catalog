import 'package:drift/drift.dart';

/// Closure table для иерархических справочников (ReferenceEntity)
class ReferenceClosureItems extends Table {
  /// Идентификатор предка (ancestor)
  TextColumn get ancestorId => text()();

  /// Идентификатор потомка (descendant)
  TextColumn get descendantId => text()();

  /// Глубина (0 - сам элемент, 1 - прямой потомок и т.д.)
  IntColumn get depth => integer()();

  @override
  Set<Column> get primaryKey => {ancestorId, descendantId};

  // Индекс для быстрого поиска всех потомков по ancestorId
  List<Index> get indexes => [
        Index(
          'reference_closure_ancestor_idx',
          'CREATE INDEX IF NOT EXISTS "reference_closure_ancestor_idx" ON "reference_closure_items"("ancestor_id")',
        ),
        Index(
          'reference_closure_descendant_idx',
          'CREATE INDEX IF NOT EXISTS "reference_closure_descendant_idx" ON "reference_closure_items"("descendant_id")',
        ),
      ];
}
