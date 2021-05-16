import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/ui/expense_editor_page/expense_editor_page.dart';
import 'package:cents/src/ui/expense_list_body/expense_list_body.dart';
import 'package:cents/src/ui/expense_list_body/expense_list_body_controller.dart';
import 'package:cents/src/ui/expense_stats_body/expense_stats_body.dart';
import 'package:cents/src/ui/expense_stats_body/expense_stats_body_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin<MainPage> {
  late final ExpenseProvider provider;
  late final ExpenseListBodyController expenseListController;
  late final ExpenseStatsBodyController expenseStatsController;

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    provider = context.read<ExpenseProvider>();
    expenseListController = ExpenseListBodyController(
        provider: provider,
        onOpenEditor: (expenseId) => _navigateToEditor(context, expenseId));
    expenseStatsController = ExpenseStatsBodyController(provider: provider);

    expenseListController.initState();
    expenseStatsController.initState();

    expenseListController.addListener(_onControllerMutation);
    expenseStatsController.addListener(_onControllerMutation);
  }

  @override
  void dispose() {
    _tabController.dispose();
    expenseListController.dispose();
    expenseStatsController.dispose();

    super.dispose();
  }

  void _onControllerMutation() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(child: _body()),
      floatingActionButton: _addExpenseFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  AppBar _appBar() {
    switch (_tabController.index) {
      case 0:
        return expenseListController.expenseSelection.isEmpty
            ? _defaultAppBar()
            : _selectionAppBar();

      case 1:
        return _defaultAppBar();

      default:
        throw StateError('Invalid selected tab index ${_tabController.index}');
    }
  }

  AppBar _defaultAppBar() {
    return AppBar(
      title: Text('Cents'),
      actions: [
        PopupMenuButton<String>(
          itemBuilder: (BuildContext context) {
            return ['Settings', 'About']
                .map((x) => PopupMenuItem(value: x, child: Text(x)))
                .toList();
          },
        ),
      ],
    );
  }

  AppBar _selectionAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close_rounded),
        onPressed: expenseListController.clearSelection,
      ),
      title: Text('${expenseListController.expenseSelection.length} selected'),
      actions: [
        IconButton(
          icon: Icon(Icons.delete_outline_rounded),
          onPressed: expenseListController.deleteSelection,
        ),
      ],
    );
  }

  Widget _body() {
    return TabBarView(
      controller: _tabController,
      children: [
        ExpenseListBody(controller: expenseListController),
        ExpenseStatsBody(controller: expenseStatsController),
      ],
    );
  }

  Widget? _addExpenseFab(BuildContext context) {
    if (expenseListController.expenseSelection.isNotEmpty) {
      return null;
    }

    return FloatingActionButton(
      onPressed: () => _navigateToEditor(context, Expense.UNSET_ID),
      child: Icon(Icons.add_rounded),
    );
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _tabController.index,
      onTap: (ix) => _tabController.animateTo(ix),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.table_rows_rounded),
          label: 'All Expenses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.table_chart_rounded),
          label: 'Stats',
        ),
      ],
    );
  }

  Future<void> _navigateToEditor(BuildContext context, int expenseId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ExpenseEditorPage(id: expenseId)),
    );
  }
}
