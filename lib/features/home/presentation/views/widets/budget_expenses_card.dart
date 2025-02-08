import 'package:expenses_manager/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/style.dart';

class BudgetExpensesCard extends StatefulWidget {
  const BudgetExpensesCard({super.key, required this.familyData});
  // final Map<String, dynamic> familyData;
  final String familyData;

  @override
  State<BudgetExpensesCard> createState() => _BudgetExpensesCardState();
}

class _BudgetExpensesCardState extends State<BudgetExpensesCard> {
  @override
  void initState() {
    super.initState();
  }

  double getTotalExpenses(HomeSuccess state) {
    Map<String, dynamic> cat = {};
    double total = 0;
    for (var expense in state.expenses) {
      if (cat.keys.contains(expense.category)) {
        cat[expense.category!] = cat[expense.category] + expense.amount;
      } else {
        cat[expense.category!] = expense.amount;
      }
    }
    cat.entries.map((e) {
      total += e.value;
    });

    return total;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SliverToBoxAdapter(
      child: Column(
        children: [
          Text(widget.familyData),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Card(
                color: const Color.fromARGB(66, 222, 215, 215),
                child: SizedBox(
                  height: 80,
                  width: width / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Budget",
                        style: kStyle1.copyWith(color: (Colors.blue[400])),
                      ),
                      Text(
                        "5000 \$",
                        style: kStyle2.copyWith(color: (Colors.blue[400])),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: const Color.fromARGB(66, 222, 215, 215),
                child: SizedBox(
                  height: 80,
                  width: width / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Expenses",
                        style: kStyle1.copyWith(color: (Colors.blue[400])),
                      ),
                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state is HomeSuccess) {
                            double totalExpenses = getTotalExpenses(state);

                            return Text(
                              "$totalExpenses \$",
                              style: kStyle2,
                            );
                          } else if (state is HomeLoading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text("");
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
