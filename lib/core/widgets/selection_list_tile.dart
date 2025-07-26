import 'package:flutter/material.dart';

class SelectionListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;
  final String? subtitle;
  final Color? subtitleColor;

  const SelectionListTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.enabled = true,
    this.subtitle,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      leading: Icon(icon),
      trailing: const Icon(Icons.chevron_right),
      onTap: enabled ? onTap : null,
      enabled: enabled,
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(color: subtitleColor, fontSize: 12),
            )
          : null,
    );
  }
}
