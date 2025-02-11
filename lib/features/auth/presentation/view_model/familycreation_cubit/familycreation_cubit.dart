import 'package:expenses_manager/features/auth/data/repo/auth_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    }, (family) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("hasFamily", true);
      await prefs.setString("familyName", family.familyName);
      await prefs.setString("familyCode", family.familyCode);
      await prefs.setString("familyId", family.familyId);

      emit(FamilycreationSuccess(
          familyName: family.familyName,
          familyCode: family.familyCode,
          familyId: family.familyId));
    });
  }

  void checkFamily() async {
    final prefs = await SharedPreferences.getInstance();
    final hasFamily = prefs.getBool("hasFamily") ?? false;
    if (hasFamily) {
      emit(FamilycreationSuccess(
          familyName: prefs.getString("familyName") ?? "",
          familyCode: prefs.getString("familyCode") ?? "",
          familyId: prefs.getString("familyId") ?? ""));
    } else {
      emit(FamilycreationFalure(errorMessage: "You have no family"));
    }
  }
}
