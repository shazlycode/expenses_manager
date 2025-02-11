part of 'delete_cubit.dart';

sealed class DeleteState {}

final class DeleteInitial extends DeleteState {}

final class DeleteSuccess extends DeleteState {
  final String message;
  DeleteSuccess({required this.message});
}

final class DeleteLoading extends DeleteState {}

final class DeleteFailure extends DeleteState {
  final String errorMessage;
  DeleteFailure({required this.errorMessage});
}
