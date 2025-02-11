import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String? expenseId;
  final String? userName;
  final String? userId;
  final String? title;
  final double amount;
  final String? category;
  final String? method;
  final String? note;
  final DateTime? date;

  Expense({
    this.expenseId,
    required this.userName,
    required this.userId,
    required this.title,
    required this.amount,
    required this.category,
    required this.method,
    required this.note,
    required this.date,
  });

  factory Expense.fromFirebase(
      Map<String, dynamic> data, String fetchedExpenseId) {
    return Expense(
      expenseId: fetchedExpenseId,
      userName: data['userName'] ?? "Unknown",
      userId: data['userId'] ?? "Unknown",
      title: data['title'] ?? "No Title",
      amount: (data['amount'] is int)
          ? (data['amount'] as int).toDouble()
          : (data['amount'] ?? 0.0),
      category: data['category'] ?? "Uncategorized",
      method: data['method'] ?? "Unknown",
      note: data['note'] ?? "",
      date: (data['date'] is Timestamp)
          ? (data['date'] as Timestamp).toDate()
          : null, // Convert Firestore Timestamp to DateTime
    );
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
