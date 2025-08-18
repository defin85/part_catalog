import 'package:drift/drift.dart';

import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/items/supplier_settings_items.dart';

part 'supplier_settings_dao.g.dart';

@DriftAccessor(tables: [SupplierSettingsItems])
class SupplierSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SupplierSettingsDaoMixin {
  final AppDatabase db;

  SupplierSettingsDao(this.db) : super(db);

  // Получить все настройки поставщиков
  Future<List<SupplierSettingsItem>> getAllSupplierSettings() =>
      select(supplierSettingsItems).get();

  // Наблюдать за всеми настройками поставщиков
  Stream<List<SupplierSettingsItem>> watchAllSupplierSettings() =>
      select(supplierSettingsItems).watch();

  // Получить настройки для конкретного поставщика по коду
  Future<SupplierSettingsItem?> getSupplierSettingByCode(String supplierCode) {
    return (select(supplierSettingsItems)
          ..where((tbl) => tbl.supplierCode.equals(supplierCode)))
        .getSingleOrNull();
  }

  // Наблюдать за настройками конкретного поставщика по коду
  Stream<SupplierSettingsItem?> watchSupplierSettingByCode(
      String supplierCode) {
    return (select(supplierSettingsItems)
          ..where((tbl) => tbl.supplierCode.equals(supplierCode)))
        .watchSingleOrNull();
  }

  // Вставить новую настройку поставщика
  Future<int> insertSupplierSetting(
      SupplierSettingsItemsCompanion entry) async {
    return into(supplierSettingsItems)
        .insert(entry, mode: InsertMode.insertOrReplace);
  }

  // Обновить существующую настройку поставщика
  Future<bool> updateSupplierSetting(
      SupplierSettingsItemsCompanion entry) async {
    return update(supplierSettingsItems).replace(entry);
  }

  // Обновить или вставить настройку поставщика
  // Обновить или вставить настройку поставщика
  Future<int> upsertSupplierSetting(
      SupplierSettingsItemsCompanion entry) async {
    // Используем insert с указанием onConflict для разрешения по supplierCode
    return into(supplierSettingsItems).insert(
      entry,
      onConflict: DoUpdate(
        (old) => entry, // Обновляем все поля, которые есть в 'entry'
        target: [
          supplierSettingsItems.supplierCode
        ], // Целевой столбец для конфликта
      ),
    );
  }

  // Удалить настройку поставщика по ID
  Future<int> deleteSupplierSettingById(int id) =>
      (delete(supplierSettingsItems)..where((tbl) => tbl.id.equals(id))).go();

  // Удалить настройку поставщика по коду
  Future<int> deleteSupplierSettingByCode(String supplierCode) =>
      (delete(supplierSettingsItems)
            ..where((tbl) => tbl.supplierCode.equals(supplierCode)))
          .go();

  // Получить все активные настройки поставщиков
  Future<List<SupplierSettingsItem>> getActiveSupplierSettings() {
    return (select(supplierSettingsItems)
          ..where((tbl) => tbl.isEnabled.equals(true)))
        .get();
  }

  // Наблюдать за всеми активными настройками поставщиков
  Stream<List<SupplierSettingsItem>> watchActiveSupplierSettings() {
    return (select(supplierSettingsItems)
          ..where((tbl) => tbl.isEnabled.equals(true)))
        .watch();
  }
}