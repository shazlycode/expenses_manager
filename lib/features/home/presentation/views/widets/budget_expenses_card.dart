import 'package:flutter/material.dart';

import '../../../../../core/utils/style.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SliverToBoxAdapter(
      child: Column(
        children: [
          Text(widget.familyData['familyName']),
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
                        "4500",
                        style: kStyle2,
                      )
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
                      Text(
                        "total",
                        style: kStyle2,
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
