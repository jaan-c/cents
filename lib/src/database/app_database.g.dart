// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ExpenseDao? _expenseDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Expenses` (`id` INTEGER NOT NULL, `cost` INTEGER NOT NULL, `category` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `note` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ExpenseDao get expenseDao {
    return _expenseDaoInstance ??= _$ExpenseDao(database, changeListener);
  }
}

class _$ExpenseDao extends ExpenseDao {
  _$ExpenseDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _databaseExpenseInsertionAdapter = InsertionAdapter(
            database,
            'Expenses',
            (DatabaseExpense item) => <String, Object?>{
                  'id': item.id,
                  'cost': _amountConverter.encode(item.cost),
                  'category': _expenseCategoryConverter.encode(item.category),
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'note': item.note
                },
            changeListener),
        _databaseExpenseUpdateAdapter = UpdateAdapter(
            database,
            'Expenses',
            ['id'],
            (DatabaseExpense item) => <String, Object?>{
                  'id': item.id,
                  'cost': _amountConverter.encode(item.cost),
                  'category': _expenseCategoryConverter.encode(item.category),
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'note': item.note
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DatabaseExpense> _databaseExpenseInsertionAdapter;

  final UpdateAdapter<DatabaseExpense> _databaseExpenseUpdateAdapter;

  @override
  Stream<List<DatabaseExpense>> getAllStream() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Expenses ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => DatabaseExpense(
            row['id'] as int,
            _amountConverter.decode(row['cost'] as int),
            _expenseCategoryConverter.decode(row['category'] as String),
            _dateTimeConverter.decode(row['createdAt'] as String),
            row['note'] as String),
        queryableName: 'Expenses',
        isView: false);
  }

  @override
  Future<DatabaseExpense?> get(int id) async {
    return _queryAdapter.query('SELECT * FROM Expenses WHERE id = ?1',
        mapper: (Map<String, Object?> row) => DatabaseExpense(
            row['id'] as int,
            _amountConverter.decode(row['cost'] as int),
            _expenseCategoryConverter.decode(row['category'] as String),
            _dateTimeConverter.decode(row['createdAt'] as String),
            row['note'] as String),
        arguments: [id]);
  }

  @override
  Future<void> delete(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Expenses WHERE id = ?1', arguments: [id]);
  }

  @override
  Stream<List<String>> getCategoriesStream() {
    await _queryAdapter.queryNoReturn(
        'SELECT DISTINCT category from Expenses ORDER BY category ASC');
  }

  @override
  Future<void> renameCategory(String oldCategory, String newCategory) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Expenses SET category = ?2 WHERE category = ?1',
        arguments: [oldCategory, newCategory]);
  }

  @override
  Future<void> insert(DatabaseExpense expense) async {
    await _databaseExpenseInsertionAdapter.insert(
        expense, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(DatabaseExpense expense) async {
    await _databaseExpenseUpdateAdapter.update(
        expense, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _amountConverter = AmountConverter();
final _expenseCategoryConverter = ExpenseCategoryConverter();
final _dateTimeConverter = DateTimeConverter();
