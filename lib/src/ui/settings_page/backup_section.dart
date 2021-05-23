import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/database/expense_backup.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as pathlib;
import 'package:share/share.dart';

class BackupSection extends StatelessWidget {
  final ExpenseProvider provider;

  BackupSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _subheader(context: context),
        _exportTile(onTap: _exportToDocuments),
        _importTile(onTap: () => _importFromPickedFile(context)),
      ],
    );
  }

  Widget _subheader({required BuildContext context}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final textStyle =
        textTheme.subtitle2!.copyWith(color: colorScheme.secondary);

    return ListTile(
      title: Text('Backup', style: textStyle),
      dense: true,
    );
  }

  Widget _exportTile({required VoidCallback onTap}) {
    return ListTile(
      title: Text('Export'),
      subtitle: Text('Export expenses to a JSON file in Documents'),
      onTap: onTap,
    );
  }

  Widget _importTile({required VoidCallback onTap}) {
    return ListTile(
      title: Text('Import'),
      subtitle: Text('Import expenses from a JSON file'),
      onTap: onTap,
    );
  }

  Future<void> _exportToDocuments() async {
    final timestamp = _dateTimeToTimestamp(DateTime.now());
    final name = 'expenses-$timestamp.json';
    final appDir = await getTemporaryDirectory();
    final path = pathlib.join(appDir.path, name);
    final json = await provider.exportAsJson();

    await File(path).writeAsString(json, flush: true);

    await Share.shareFiles([path]);
  }

  Future<void> _importFromPickedFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['json'],
          allowMultiple: false);

      if (result != null) {
        final pickedFile = result.files.first;
        final json = await File(pickedFile.path!).readAsString();
        await provider.importFromJson(json);
      }
    } on PlatformException catch (_) {
      _showSnackbar(context,
          'Failed to import expenses, please enable storage permission.');
      return;
    }
  }

  String _dateTimeToTimestamp(DateTime dateTime) {
    final dateParts = [dateTime.year, dateTime.month, dateTime.day]
        .map((p) => p.toString().padLeft(2, '0'));
    final timeParts = [dateTime.hour, dateTime.minute, dateTime.second]
        .map((p) => p.toString().padLeft(2, '0'));

    return [...dateParts, ...timeParts].join('-');
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OPEN',
        onPressed: () => AppSettings.openAppSettings(asAnotherTask: true),
      ),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
