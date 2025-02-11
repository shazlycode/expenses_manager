abstract class FamilySuccess {
  final String familyId;
  final String familyName;
  final String familyCode;

  FamilySuccess(
      {required this.familyId,
      required this.familyName,
      required this.familyCode});
}

class FamilyProfileCreationSuccess extends FamilySuccess {
  FamilyProfileCreationSuccess(
      {required super.familyId,
      required super.familyName,
      required super.familyCode});
}
