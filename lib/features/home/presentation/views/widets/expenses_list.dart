import 'package:expenses_manager/core/utils/style.dart';
import 'package:expenses_manager/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:expenses_manager/features/home/presentation/views/widets/custom_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/cat_colors.dart';
import '../../../data/models/expense.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList(
      {super.key, required this.familyData, required this.expenses});
  final Map<String, dynamic> familyData;
  final List<Expense> expenses;

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  @override
  void didChangeDependencies() {
    // super.didChangeDependencies();
    // context
    //     .read<HomeCubit>()
    //     .fetchExpenses(familyId: widget.familyData['familyId']);
  }

  @override
  Widget build(BuildContext context) {
    final CustomPieChart customPieChart = CustomPieChart(
      familyData: widget.familyData,
    );
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeSuccess) {
          print("Number of expenses found: ${state.expenses.length}");
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Dismissible(
                key: ValueKey(state.expenses[index]),
                onDismissed: (direction) async {
                  await context.read<HomeCubit>().deleteExpense(
                        familyId: widget.familyData['familyId'],
                        expenseId: state.expenses[index].expenseId!,
                      );
                },
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
                  color: getCatColor(state.expenses[index].category!),
                  // color: const Color.fromARGB(66, 222, 215, 215),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(state.expenses[index].userName!),
                            Text(DateFormat('dd-MM-yyyy')
                                .format(state.expenses[index].date!))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(state.expenses[index].title!),
                            Text(state.expenses[index].category!)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${state.expenses[index].amount}\$"),
                            Text(state.expenses[index].method!)
                          ],
                        ),
                        Text(state.expenses[index].note!),
                      ],
                    ),
                  ),
                ),
              );
            }, childCount: state.expenses.length),
          );
        } else if (state is HomeLoading) {
          return SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is HomeFailure) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(state.errorMessage),
            ),
          );
        } else {
          return SliverToBoxAdapter(
            child: Center(
              child: Text("Unexpected state"),
            ),
          );
        }
      },
    );
  }
}
