import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/widgets/expense_editor_page/expense_editor_page.dart';
import 'package:cents/src/widgets/expense_list_body/expense_list_body.dart';
import 'package:cents/src/widgets/expense_list_body/expense_list_body_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final ExpenseProvider provider;
  late final ExpenseListBodyController expenseListBodyController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    provider = context.read<ExpenseProvider>();
    expenseListBodyController = ExpenseListBodyController(
        provider: provider,
        onOpenEditor: (expenseId) => _navigateToEditor(context, expenseId))
      ..initState();

    expenseListBodyController.addListener(_onControllerMutation);
  }

  @override
  void dispose() {
    expenseListBodyController.dispose();

    super.dispose();
  }

  void _onControllerMutation() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _expenseListScaffold();
  }

  Widget _expenseListScaffold() {
    return Scaffold(
      appBar: expenseListBodyController.expenseSelection.isEmpty
          ? _defaultAppBar()
          : _selectionAppBar(),
      body: ExpenseListBody(controller: expenseListBodyController),
      floatingActionButton: _addExpenseFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  AppBar _defaultAppBar() {
    return AppBar(
      title: Text('Cents'),
      actions: [_overflowMenuButton()],
    );
  }

  Widget _overflowMenuButton() {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return ['Settings', 'About']
            .map((x) => PopupMenuItem(value: x, child: Text(x)))
            .toList();
      },
    );
  }

  AppBar _selectionAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close_rounded),
        onPressed: expenseListBodyController.clearSelection,
      ),
      title:
          Text('${expenseListBodyController.expenseSelection.length} selected'),
      actions: [
        IconButton(
          icon: Icon(Icons.delete_outline_rounded),
          onPressed: expenseListBodyController.deleteSelection,
        ),
      ],
    );
  }

  Widget _addExpenseFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _navigateToEditor(context, Expense.UNSET_ID),
      child: Icon(Icons.add_rounded),
    );
  }

  Future<void> _navigateToEditor(BuildContext context, int expenseId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ExpenseEditorPage(id: expenseId)),
    );
  }
}
