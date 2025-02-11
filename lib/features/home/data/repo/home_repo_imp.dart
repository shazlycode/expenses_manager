import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:expenses_manager/core/utils/delet.dart';
import 'package:expenses_manager/core/utils/failure.dart';
import 'package:expenses_manager/core/utils/fetch_expenses_success.dart';
import 'package:expenses_manager/core/utils/sucess.dart';
import 'package:expenses_manager/features/home/data/models/expense.dart';
import 'package:expenses_manager/features/home/data/repo/home_repo.dart';
import 'package:flutter/material.dart';

class HomeRepoImp implements HomeRepo {
  @override
  Future<Either<Failure, FetchSuccess>> fetchExpenses(
      {required String familyId}) async {
    try {
      debugPrint("Start Fetching");
      debugPrint("Fetching expenses for familyId: $familyId");

      final expenses = await FirebaseFirestore.instance
          .collection("families")
          .doc(familyId)
          .collection("expenses")
          .get();
      debugPrint("end Fetching${expenses.docs.length}");

      List<Expense> fetched = [];

      debugPrint("Number of expenses found: ${expenses.docs.length}");
      if (expenses.docs.isEmpty) {
        debugPrint("No expenses found for this family.");
      }

      for (var expense in expenses.docs) {
        debugPrint("Expense data: ${expense.data()}");
        fetched.add(Expense.fromFirebase(expense.data(), expense.id));
      }

      return right(FetchExpensesSuccess(expenses: fetched));
    } on FirebaseException catch (e) {
      return left(FirebaseAuthFailure(errorMessage: e.message));
    } catch (e) {
      return left(FirebaseAuthFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddSuccess>> addExpense(
      {required String familyId,
      required String userId,
      required Map<String, dynamic> expenseData}) async {
    try {
      await FirebaseFirestore.instance
          .collection("families")
          .doc(familyId)
          .collection("expenses")
          .add(expenseData);
      return right(AddExpenseSuccess(message: "expense added successfully!!!"));
    } on FirebaseException catch (e) {
      return left(FirebaseAuthFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<DeleteFailure, DeletSuccess>> deleteExpense(
      {required String familyId, required String expenseId}) async {
    try {
      await FirebaseFirestore.instance
          .collection("families")
          .doc(familyId)
          .collection("expenses")
          .doc(expenseId)
          .delete();
      return right(
          DeletExpenseSuccess(message: "Expense deleted successfully"));
    } on FirebaseException catch (e) {
      return left(DeleteExpenseFailure(errorMessage: e.message!));
    } catch (e) {
      return left(DeleteExpenseFailure(errorMessage: e.toString()));
    }
  }
}
