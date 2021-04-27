import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/widgets/main_page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late final Future<ExpenseProvider> _futureProvider;

  @override
  void initState() {
    super.initState();
    _futureProvider = ExpenseProvider.open();
  }

  @override
  void dispose() {
    _futureProvider.then((p) => p.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _expenseProvider(
      child: MaterialApp(
        title: 'Cents',
        home: MainPage(),
      ),
    );
  }

  Widget _expenseProvider({required Widget child}) {
    return FutureBuilder<ExpenseProvider>(
      future: _futureProvider,
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          throw snapshot.error!;
        }

        if (!snapshot.hasData) {
          return SizedBox.expand();
        }

        return ChangeNotifierProvider.value(
          value: snapshot.data!,
          child: child,
        );
      },
    );
  }
}
