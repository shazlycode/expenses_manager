part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeSuccess extends HomeState {
  final List<Expense> expenses;
  final double totalAmount;
  final Map<String, double> categoryAmounts;

  HomeSuccess(
      {required this.totalAmount,
      required this.categoryAmounts,
      required this.expenses});
}

final class HomeLoading extends HomeState {}

final class HomeFailure extends HomeState {
  final String errorMessage;

  HomeFailure({required this.errorMessage});
}

final class DeleteSuccess extends HomeState {
  final String message;
  DeleteSuccess({required this.message});
}

final class DeleteLoading extends HomeState {}

final class DeleteFailure extends HomeState {
  final String errorMessage;
  DeleteFailure({required this.errorMessage});
}
