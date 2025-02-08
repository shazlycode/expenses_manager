part of 'add_expense_cubit.dart';

sealed class AddExpenseState {}

final class AddExpenseInitial extends AddExpenseState {}

final class AddExpenseSuccess extends AddExpenseState {
  final String message;

  AddExpenseSuccess({required this.message});
}

final class AddExpenseLoading extends AddExpenseState {}

final class AddExpenseFailure extends AddExpenseState {
  final String errorMessage;

  AddExpenseFailure({required this.errorMessage});
}
