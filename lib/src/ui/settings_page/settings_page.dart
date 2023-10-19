import 'package:cents/src/database/expense_provider.dart';
import 'package:flutter/material.dart';

import 'backup_section.dart';

class SettingsPage extends StatelessWidget {
  final ExpenseProvider provider;

  const SettingsPage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BackupSection(provider: provider),
          ],
        ),
      ),
    );
  }
}
