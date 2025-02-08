import 'package:firebase_auth/firebase_auth.dart';

abstract class Success {
  final UserCredential userCredential;

  Success({required this.userCredential});
}

class FirebaseAuthSuccess extends Success {
  FirebaseAuthSuccess({required super.userCredential});
}

abstract class AddSuccess {
  final String message;

  AddSuccess({required this.message});
}

class AddExpenseSuccess extends AddSuccess {
  AddExpenseSuccess({required super.message});
}
