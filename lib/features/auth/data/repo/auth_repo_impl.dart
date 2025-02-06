import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:expenses_manager/core/utils/failure.dart';
import 'package:expenses_manager/core/utils/family_creation_success.dart';
import 'package:expenses_manager/features/auth/data/repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utils/sucess.dart';

class AuthRepoImpl implements AuthRepo {
  @override
  Future<Either<Failure, Success>> login(
      {required String email, required String password}) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return right(FirebaseAuthSuccess(userCredential: credential));
    } on FirebaseAuthException catch (e) {
      return left(FirebaseAuthFailure.fromFirebaseException(e));
    } on HttpException catch (e) {
      return left(FirebaseAuthFailure(errorMessage: e.toString()));
    } catch (e) {
      return left(FirebaseAuthFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success>> register(
      {required String email, required String password}) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return right(FirebaseAuthSuccess(userCredential: credential));
    } on FirebaseAuthException catch (e) {
      return left(FirebaseAuthFailure(errorMessage: e.message));
    } on HttpException catch (e) {
      return left(FirebaseAuthFailure(errorMessage: e.toString()));
    } catch (e) {
      return left(FirebaseAuthFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, FamilySuccess>> createFamilyProfile({
    required String familyName,
  }) async {
    String familyCode = generateFamilyCode();
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userId = currentUser.uid;

    try {
      final family =
          await FirebaseFirestore.instance.collection("families").add({
        'familyName': familyName,
        'familyCode': familyCode,
        'admin': userId,
        'createdAt': FieldValue.serverTimestamp()
      });

      await FirebaseFirestore.instance
          .collection('families')
          .doc(family.id)
          .collection('members')
          .doc(userId)
          .set({
        'name': currentUser.displayName,
        'email': currentUser.email,
        'roll': "admin"
      });
      return right(FamilyProfileCreationSuccess(
          familyCode: familyCode, familyName: familyName));
    } catch (e) {
      return left(FirebaseAuthFailure(errorMessage: e.toString()));
    }
  }

  String generateFamilyCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      List.generate(
          6, (index) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }
}
