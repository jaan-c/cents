import 'amount.dart';
import 'expense.dart';

extension ExpenseListExt on List<Expense> {
  Amount totalCost() {
    return fold(Amount(), (a, e) => a.add(e.cost));
  }
}
