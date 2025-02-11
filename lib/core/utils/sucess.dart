import 'package:firebase_auth/firebase_auth.dart';

abstract class Success {
  final User user;

  Success({required this.user});
}

class FirebaseAuthSuccess extends Success {
  FirebaseAuthSuccess({required super.user});
}

abstract class AddSuccess {
  final String message;

  AddSuccess({required this.message});
}

class AddExpenseSuccess extends AddSuccess {
  AddExpenseSuccess({required super.message});
}
