import 'package:firebase_auth/firebase_auth.dart';

abstract class Success {
  final UserCredential userCredential;

  Success({required this.userCredential});
}

class FirebaseAuthSuccess extends Success {
  FirebaseAuthSuccess({required super.userCredential});
}
