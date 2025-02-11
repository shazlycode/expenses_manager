import 'dart:convert';

import 'package:expenses_manager/features/auth/data/repo/auth_repo_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepoImpl) : super(AuthInitial());
  final AuthRepoImpl authRepoImpl;

  Future<void> login({required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();

    emit(AuthLoading());
    final result = await authRepoImpl.login(email: email, password: password);
    result.fold((failure) {
      emit(AuthFailure(errorMessage: failure.errorMessage!));
    }, (success) async {
      await prefs.setBool("isLogin", true);

      emit(AuthSuccess(user: success.user));
    });
  }

  Future<void> register(
      {required String email, required String password}) async {
    emit(AuthLoading());
    final prefs = await SharedPreferences.getInstance();
    final result =
        await authRepoImpl.register(email: email, password: password);
    result.fold((failure) {
      emit(AuthFailure(errorMessage: failure.errorMessage!));
    }, (success) async {
      await prefs.setBool("isLogin", true);
      emit(AuthSuccess(user: success.user));
    });
  }

  Future<void> checkLogin() async {
    late User loggedinUser;
    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool("isLogin") ?? false;

    if (isLogin) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          loggedinUser = user;
          emit(AuthSuccess(user: loggedinUser));
        }
      });
    } else {
      emit(AuthFailure(errorMessage: "You are not logged in"));
    }
  }
}
