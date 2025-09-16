import '../models/supplier_config.dart';
import '../models/armtek/user_structure_item.dart';
import '../models/armtek/contact_tab_item.dart';
import '../models/armtek/dogovor_item.dart';

/// Утилиты для работы с сохраненными данными getUserInfo
class UserInfoHelper {
  /// Получить все контакты пользователя из сохраненной конфигурации
  static List<ContactTabItem> getAllContacts(SupplierConfig config) {
    final userInfo = config.businessConfig?.savedUserInfo;
    if (userInfo?.structure?.rgTab == null) return [];

    return userInfo!.structure!.rgTab!
        .expand((rg) => rg.contactTab ?? <ContactTabItem>[])
        .toList();
  }

  /// Получить все договоры пользователя из сохраненной конфигурации
  static List<DogovorItem> getAllContracts(SupplierConfig config) {
    final userInfo = config.businessConfig?.savedUserInfo;
    if (userInfo?.structure?.rgTab == null) return [];

    return userInfo!.structure!.rgTab!
        .expand((rg) => rg.dogovorTab ?? <DogovorItem>[])
        .toList();
  }

  /// Получить основной KUNAG (используется как customerCode)
  static String? getPrimaryKunag(SupplierConfig config) {
    final userInfo = config.businessConfig?.savedUserInfo;
    return userInfo?.structure?.kunag;
  }

  /// Получить все KUNNR из всех плательщиков
  static List<String> getAllKunnrs(SupplierConfig config) {
    final userInfo = config.businessConfig?.savedUserInfo;
    if (userInfo?.structure?.rgTab == null) return [];

    return userInfo!.structure!.rgTab!
        .map((rg) => rg.kunnr)
        .where((kunnr) => kunnr != null)
        .cast<String>()
        .toList();
  }

  /// Получить плательщика по умолчанию
  static UserStructureItem? getDefaultPayer(SupplierConfig config) {
    final userInfo = config.businessConfig?.savedUserInfo;
    if (userInfo?.structure?.rgTab == null) return null;

    try {
      final structure = userInfo!.structure!;
      return structure.rgTab!
          .firstWhere((rg) => rg.defaultFlag == true);
    } catch (e) {
      // Возвращаем первого плательщика, если нет дефолтного
      final structure = userInfo!.structure;
      return structure?.rgTab?.isNotEmpty == true
          ? structure!.rgTab!.first
          : null;
    }
  }

  /// Получить основную информацию о пользователе
  static Map<String, dynamic> getUserSummary(SupplierConfig config) {
    final userInfo = config.businessConfig?.savedUserInfo;
    if (userInfo?.structure == null) {
      return {'error': 'No saved user info found'};
    }

    final structure = userInfo!.structure!;
    final allContacts = getAllContacts(config);
    final allContracts = getAllContracts(config);
    final allKunnrs = getAllKunnrs(config);

    return {
      'kunag': structure.kunag,
      'vkorg': structure.vkorg,
      'organizationName': structure.sname,
      'address': structure.adress,
      'payersCount': structure.rgTab?.length ?? 0,
      'contactsCount': allContacts.length,
      'contractsCount': allContracts.length,
      'allKunnrs': allKunnrs,
      'lastUpdated': config.businessConfig?.lastUserInfoUpdateAt?.toIso8601String(),
    };
  }

  /// Проверить, нужно ли обновить данные getUserInfo (например, если прошло больше недели)
  static bool shouldUpdateUserInfo(SupplierConfig config, {Duration maxAge = const Duration(days: 7)}) {
    final lastUpdate = config.businessConfig?.lastUserInfoUpdateAt;
    if (lastUpdate == null) return true;

    return DateTime.now().difference(lastUpdate) > maxAge;
  }
}