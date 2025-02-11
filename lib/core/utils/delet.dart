abstract class DeletSuccess {
  final String message;

  DeletSuccess({required this.message});
}

class DeletExpenseSuccess extends DeletSuccess {
  DeletExpenseSuccess({required super.message});
}

abstract class DeleteFailure {
  final String errorMessage;
  DeleteFailure({required this.errorMessage});
}

class DeleteExpenseFailure extends DeleteFailure {
  DeleteExpenseFailure({required super.errorMessage});
}
