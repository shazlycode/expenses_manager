abstract class FamilySuccess {
  final String familyName;
  final String familyCode;

  FamilySuccess({required this.familyName, required this.familyCode});
}

class FamilyProfileCreationSuccess extends FamilySuccess {
  FamilyProfileCreationSuccess(
      {required super.familyName, required super.familyCode});
}
