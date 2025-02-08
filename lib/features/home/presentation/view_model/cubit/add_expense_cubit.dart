import 'package:expenses_manager/features/home/data/repo/home_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_expense_state.dart';

class AddExpenseCubit extends Cubit<AddExpenseState> {
  AddExpenseCubit(this.homeRepoImp) : super(AddExpenseInitial());

  final HomeRepoImp homeRepoImp;

  Future<void> addExpense(
      {required String familyId,
      required userId,
      required Map<String, dynamic> expenseData}) async {
    emit(AddExpenseLoading());
    final result = await homeRepoImp.addExpense(
        familyId: familyId, userId: userId, expenseData: expenseData);
    result.fold((failur) {
      emit(AddExpenseFailure(errorMessage: failur.errorMessage!));
    }, (success) {
      emit(AddExpenseSuccess(message: success.message));
    });
  }
}
