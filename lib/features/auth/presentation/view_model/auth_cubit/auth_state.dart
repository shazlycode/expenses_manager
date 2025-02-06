part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserCredential userCredential;

  AuthSuccess({required this.userCredential});
}

final class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure({required this.errorMessage});
}
