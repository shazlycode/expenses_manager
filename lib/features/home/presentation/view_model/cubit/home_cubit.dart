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
      emit(HomeSuccess(expenses: expenses.expenses));
    });
  }
}
