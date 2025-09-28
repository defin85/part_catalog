import 'package:flutter/material.dart';

/// Mixin для показа уведомлений и диалогов
mixin NotificationsMixin {
  /// Показать уведомление об успехе
  void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Показать уведомление об ошибке
  void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Показать информационное уведомление
  void showInfoMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Показать диалог подтверждения
  Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Подтвердить',
    String cancelText = 'Отмена',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Показать диалог удаления
  Future<bool> showDeleteConfirmationDialog(
    BuildContext context, {
    required String itemName,
  }) {
    return showConfirmationDialog(
      context,
      title: 'Подтверждение',
      content: 'Удалить $itemName?',
      confirmText: 'Удалить',
      cancelText: 'Отмена',
    );
  }
}