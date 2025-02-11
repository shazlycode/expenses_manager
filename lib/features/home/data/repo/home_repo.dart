import 'package:dartz/dartz.dart';
import 'package:expenses_manager/core/utils/delet.dart';
import 'package:expenses_manager/core/utils/failure.dart';
import 'package:expenses_manager/core/utils/fetch_expenses_success.dart';
import 'package:expenses_manager/core/utils/sucess.dart';

abstract class HomeRepo {
  Future<Either<Failure, FetchSuccess>> fetchExpenses(
      {required String familyId});

  Future<Either<Failure, AddSuccess>> addExpense(
      {required String familyId,
      required String userId,
      required Map<String, dynamic> expenseData});

  Future<Either<DeleteFailure, DeletSuccess>> deleteExpense(
      {required String familyId, required String expenseId});
}
