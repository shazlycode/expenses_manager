import 'package:expenses_manager/features/auth/data/repo/auth_repo_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepoImpl) : super(AuthInitial());
  final AuthRepoImpl authRepoImpl;

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await authRepoImpl.login(email: email, password: password);
    result.fold((failure) {
      emit(AuthFailure(errorMessage: failure.errorMessage!));
    }, (success) {
      emit(AuthSuccess(userCredential: success.userCredential));
    });
  }

  Future<void> register(
      {required String email, required String password}) async {
    emit(AuthLoading());
    final result =
        await authRepoImpl.register(email: email, password: password);
    result.fold((failure) {
      emit(AuthFailure(errorMessage: failure.errorMessage!));
    }, (success) {
      emit(AuthSuccess(userCredential: success.userCredential));
    });
  }
}
