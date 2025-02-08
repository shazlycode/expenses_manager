import 'package:expenses_manager/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({super.key, required this.familyData});
  // final Map<String, dynamic> familyData;
  final String familyData;

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  @override
  void initState() {
    // context
    // .read<HomeCubit>()
    // .fetchExpenses(familyId: widget.familyData['familyId']);
    context.read<HomeCubit>().fetchExpenses(familyId: widget.familyData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeSuccess) {
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            final expenses = state.expenses;
            return Dismissible(
              key: ValueKey(expenses[index].expenseId),
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
                          Text(expenses[index].userName!),
                          Text(DateFormat('dd-MM-yyyy')
                              .format(DateTime.parse(expenses[index].date!)))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(expenses[index].title!),
                          Text(expenses[index].category!)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${expenses[index].amount}\$"),
                          Text(expenses[index].method!)
                        ],
                      ),
                      Text(expenses[index].note!),
                    ],
                  ),
                ),
              ),
            );
          }, childCount: state.expenses.length));
        } else if (state is HomeFailure) {
          return SliverToBoxAdapter(child: Text(state.errorMessage));
        }
        return SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
