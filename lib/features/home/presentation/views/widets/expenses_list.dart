import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({super.key});

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return Dismissible(
        key: ValueKey("value"),
        onDismissed: (_) async {},
        direction: DismissDirection.endToStart,
        background: SizedBox(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        ),
        child: Card(
          elevation: 5,
          color: const Color.fromARGB(66, 222, 215, 215),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ahmed"),
                    Text(DateFormat('dd-MM-yyyy').format(DateTime.now()))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("title"), Text("category!")],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("200 \$"), Text("Apple Pay")],
                ),
                Text("Your note here")
              ],
            ),
          ),
        ),
      );
    }, childCount: 5));
  }
}
