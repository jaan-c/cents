import 'package:cents/src/widgets/expense_list_page/expense_list_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cents',
      home: ExpenseListPage(),
    );
  }
}
