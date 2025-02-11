import 'package:expenses_manager/features/home/data/models/expense.dart';
import 'package:expenses_manager/features/home/data/repo/home_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeRepoImp) : super(HomeInitial());

  final HomeRepoImp homeRepoImp;

  Future<void> fetchExpenses({required String familyId}) async {
    emit(HomeLoading());
    final result = await homeRepoImp.fetchExpenses(familyId: familyId);

    result.fold((failure) {
      emit(HomeFailure(errorMessage: failure.errorMessage!));
    }, (expenses) {
      // 🟢 حساب إجمالي المصروفات لكل فئة
      Map<String, double> categoryAmounts = {};

      for (var expense in expenses.expenses) {
        categoryAmounts[expense.category!] =
            (categoryAmounts[expense.category] ?? 0) + expense.amount;
      }

      // 🟢 حساب إجمالي المصروفات بطريقة أفضل باستخدام fold
      // double totalAmount =
      //     expenses.expenses.fold(0, (sum, expense) => sum + expense.amount!);
      double totalAmount = expenses.expenses
          .fold(0.0, (initialValue, ex) => initialValue + ex.amount);
      emit(HomeSuccess(
        totalAmount: totalAmount,
        categoryAmounts: categoryAmounts,
        expenses: expenses.expenses,
      ));
    });
  }

  Future<void> deleteExpense(
      {required String familyId, required String expenseId}) async {
    emit(DeleteLoading());
    final result = await homeRepoImp.deleteExpense(
        familyId: familyId, expenseId: expenseId);
    result.fold((failure) {
      emit(DeleteFailure(errorMessage: failure.errorMessage));
    }, (success) async {
      // Fetch the updated list of expenses after deletion
      // await fetchExpenses(familyId: familyId);
    });
  }
}
