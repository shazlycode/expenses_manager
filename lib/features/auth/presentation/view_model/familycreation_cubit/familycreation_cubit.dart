import 'package:expenses_manager/features/auth/data/repo/auth_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'familycreation_state.dart';

class FamilycreationCubit extends Cubit<FamilycreationState> {
  FamilycreationCubit(this.authRepoImpl) : super(FamilycreationInitial());

  final AuthRepoImpl authRepoImpl;

  Future createFamilyProfile({required String familyName}) async {
    emit(FamilycreationLoading());
    final result =
        await authRepoImpl.createFamilyProfile(familyName: familyName);
    result.fold((failure) {
      emit(FamilycreationFalure(errorMessage: failure.errorMessage!));
    }, (family) {
      emit(FamilycreationSuccess(
          familyName: family.familyName, familyCode: family.familyCode));
    });
  }
}
