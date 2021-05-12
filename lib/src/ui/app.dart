import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/ui/main_page/main_page.dart';
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
    return FutureBuilder<ExpenseProvider>(
      future: _futureProvider,
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          throw snapshot.error!;
        }

        if (!snapshot.hasData) {
          return _placeholderApp();
        }

        return ChangeNotifierProvider.value(
          value: snapshot.data!,
          child: _app(),
        );
      },
    );
  }

  Widget _app() {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      title: 'Cents',
      home: MainPage(),
    );
  }

  Widget _placeholderApp() {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      title: 'Cents',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cents'),
        ),
      ),
    );
  }
}
