import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repo/home_repo_imp.dart';

part 'delete_state.dart';

class DeleteCubit extends Cubit<DeleteState> {
  DeleteCubit(HomeRepoImp homeRepoImp) : super(DeleteInitial());
  final homeRepoImp = HomeRepoImp();

  Future<void> deleteExpense(
      {required String familyId, required String expenseId}) async {
    emit(DeleteLoading());
    final result = await homeRepoImp.deleteExpense(
        familyId: familyId, expenseId: expenseId);
    result.fold((failur) {
      emit(DeleteFailure(errorMessage: failur.errorMessage!));
    }, (success) {
      emit(DeleteSuccess(message: success.message));
    });
  }
}
