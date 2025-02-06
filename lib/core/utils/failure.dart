import 'package:firebase_auth/firebase_auth.dart';

abstract class Failure {
  final String? errorMessage;

  Failure({required this.errorMessage});
}

class FirebaseAuthFailure extends Failure {
  FirebaseAuthFailure({required super.errorMessage});

  factory FirebaseAuthFailure.fromFirebaseException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return FirebaseAuthFailure(
            errorMessage: 'Invalid email format. Please check your email.');
      case 'user-disabled':
        return FirebaseAuthFailure(
            errorMessage: 'This user account has been disabled.');
      case 'user-not-found':
        return FirebaseAuthFailure(
            errorMessage: 'No user found for this email.');
      case 'wrong-password':
        return FirebaseAuthFailure(
            errorMessage: 'Incorrect password. Please try again.');
      case 'email-already-in-use':
        return FirebaseAuthFailure(
            errorMessage: 'The email is already registered. Try logging in.');
      case 'weak-password':
        return FirebaseAuthFailure(
            errorMessage: 'The password is too weak. Try a stronger one.');
      case 'network-request-failed':
        return FirebaseAuthFailure(
            errorMessage:
                'Network error. Please check your internet connection.');
      case 'too-many-requests':
        return FirebaseAuthFailure(
            errorMessage: 'Too many login attempts. Try again later.');
      default:
        return FirebaseAuthFailure(
            errorMessage: 'An unexpected error occurred. Please try again.');
    }
  }
}
