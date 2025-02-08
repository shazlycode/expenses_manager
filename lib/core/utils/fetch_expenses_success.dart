import 'package:expenses_manager/features/home/data/models/expense.dart';

abstract class FetchSuccess {
  final List<Expense> expenses;

  FetchSuccess({required this.expenses});
}

class FetchExpensesSuccess extends FetchSuccess {
  FetchExpensesSuccess({required super.expenses});
}
