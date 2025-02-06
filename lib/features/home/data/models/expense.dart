class Expense {
  final String? expenseId;
  final String? userName;
  final String? userId;
  final String? title;
  final double? amount;
  final String? category;
  final String? method;
  final String? note;
  final String? date;

  Expense(
      {this.expenseId,
      required this.userName,
      required this.userId,
      required this.title,
      required this.amount,
      required this.category,
      required this.method,
      required this.note,
      required this.date});

  factory Expense.fromFirebase(
      Map<String, dynamic> data, String fetchedExpenseId) {
    return Expense(
        expenseId: fetchedExpenseId,
        userName: data['userName'],
        userId: data['userId'],
        title: data['title'],
        amount: data['amount'],
        category: data['category'],
        method: data['method'],
        note: data['note'],
        date: data['date']);
  }

  Map<String, dynamic> toFirebase() {
    return {
      'userName': userName,
      "userId": userId,
      "title": title,
      "amount": amount,
      "category": category,
      "method": method,
      "note": note,
      "date": date
    };
  }
}
