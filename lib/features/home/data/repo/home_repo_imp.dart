import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:expenses_manager/core/utils/failure.dart';
import 'package:expenses_manager/core/utils/fetch_expenses_success.dart';
import 'package:expenses_manager/core/utils/sucess.dart';
import 'package:expenses_manager/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:expenses_manager/features/home/data/models/expense.dart';
import 'package:expenses_manager/features/home/data/repo/home_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeRepoImp implements HomeRepo {
  @override
  Future<Either<Failure, FetchSuccess>> fetchExpenses(
      {required String familyId}) async {
    try {
      final expenses = await FirebaseFirestore.instance
          .collection("families")
          .doc(familyId)
          .collection("expenses")
          .get();
      List<Expense> fetched = [];
      for (var expense in expenses.docs) {
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
          .collection("expensise")
          .add(expenseData);
      return right(AddExpenseSuccess(message: "expense added successfully!!!"));
    } on FirebaseException catch (e) {
      return left(FirebaseAuthFailure(errorMessage: e.message));
    }
  }
}
