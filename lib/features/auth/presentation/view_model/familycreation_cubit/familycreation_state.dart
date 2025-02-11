part of 'familycreation_cubit.dart';

sealed class FamilycreationState {}

final class FamilycreationInitial extends FamilycreationState {}

final class FamilycreationLoading extends FamilycreationState {}

final class FamilycreationSuccess extends FamilycreationState {
  final String familyId, familyCode, familyName;

  FamilycreationSuccess(
      {required this.familyName,
      required this.familyCode,
      required this.familyId});
}

final class FamilycreationFalure extends FamilycreationState {
  final String errorMessage;

  FamilycreationFalure({required this.errorMessage});
}
