import 'package:expenses_manager/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/style.dart';
import 'package:share_plus/share_plus.dart';

class BudgetExpensesCard extends StatefulWidget {
  const BudgetExpensesCard({super.key, required this.familyData});
  final Map<String, dynamic> familyData;

  @override
  State<BudgetExpensesCard> createState() => _BudgetExpensesCardState();
}

class _BudgetExpensesCardState extends State<BudgetExpensesCard> {
  @override
  void initState() {
    super.initState();
    // getTotalExpenses should be called with a valid HomeSuccess instance within BlocBuilder
  }

  /// Shares the family code using the user's preferred sharing method.
  ///
  /// The message shared includes the family code with a subject providing context.
  Future<void> shareFamilyCode() async {
    final familyCode = widget.familyData['familyCode'] as String?;
    final familyName = widget.familyData['familyName'] as String?;

    if (familyCode == null || familyName == null) {
      return;
    }

    try {
      final shareResult = await Share.share(
        'Expenses Manager Family Code \nFamily Code: $familyCode\n\nShared from Expenses Manager. Use this code in the Expenses Manager App to connect to the $familyName expenses profile. Have a nice day!\nInstall the app from: \n https://play.google.com/store/apps/details?id=com.shazlycode.expensesmanager',
        subject:
            'Family Code: $familyCode\n\nShared from Expenses Manager. Use this code in the Expenses Manager App to connect to the $familyName expenses profile. Have a nice day!\nInstall the app from: \n https://play.google.com/store/apps/details?id=com.shazlycode.expensesmanager',
      );
      if (shareResult.status == ShareResultStatus.success) {
        print('Thank you for sharing!');
      }
    } catch (error) {
      print('Error occurred while sharing: $error');
    }
  }

  double getTotalExpenses(HomeSuccess state) {
    Map<String, dynamic> cat = {};
    double totalExpenses = 0;
    for (var expense in state.expenses) {
      if (cat.keys.contains(expense.category)) {
        cat[expense.category!] = cat[expense.category] + expense.amount;
        debugPrint(cat[expense.category]);
        debugPrint("cat: $cat");
      } else {
        cat[expense.category!] = expense.amount;
        debugPrint("cat: $cat");
      }
    }

    for (var caty in cat.entries) {
      totalExpenses += caty.value;
    }
    // cat.entries.map((e) {
    //   totalExpenses += e.value;
    // });
    return totalExpenses;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SliverToBoxAdapter(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.familyData['familyName'],
                  style: kStyle1.copyWith(color: Colors.white)),
              IconButton(
                  onPressed: () async {
                    await shareFamilyCode();
                  },
                  icon: Icon(
                    Icons.share,
                    size: 20,
                  ))
            ],
          ),
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
                            double total = state.totalAmount;
                            // double totalExpenses = getTotalExpenses(state);
                            debugPrint("state.expenses: ${state.expenses}");
                            return Text(
                              "$total \$",
                              style:
                                  kStyle2.copyWith(color: (Colors.blue[400])),
                            );
                          } else if (state is HomeLoading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            "0 \$",
                            style: kStyle1.copyWith(color: (Colors.blue[400])),
                          );
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
