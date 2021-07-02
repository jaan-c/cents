import 'dart:convert';

import 'package:cents/src/database/expense_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:cents/src/database/database_backup.dart';

void main() {
  late ExpenseProvider provider;

  setUp(() async {
    sqfliteFfiInit();

    provider = await ExpenseProvider.openInMemory(
        defaultDatabaseFactory: databaseFactoryFfi);
  });

  tearDown(() async {
    await provider.dispose();
  });

  test('Export', () async {
    const json = '''
      [
        {
          "category": {
            "name": "Food",
            "color": 4278190335
          },
          "cost": 2000,
          "createdAt": "2021-07-01T10:28:53.802101",
          "note": ""
        },
        {
          "category": {
            "name": "Health",
            "color": 4294901760
          },
          "cost": 11900,
          "createdAt": "2021-06-26T10:36:30.653267",
          "note": "Deodorant"
        },
        {
          "category": {
            "name": "Work",
            "color": 4278255360
          },
          "cost": 2700,
          "createdAt": "2021-07-01T06:35:08.762756",
          "note": ""
        }
      ]
    ''';
    await provider.importFromJson(json);

    final exportJson = await provider.exportAsJson();
    expect(_normalizeJson(json), _normalizeJson(exportJson));
  });
}

String _normalizeJson(String json) {
  return jsonEncode(jsonDecode(json));
}
