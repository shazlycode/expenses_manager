import 'dart:io';

import 'package:expenses_manager/features/home/data/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../../core/addservice/add_service.dart';
import '../../../../../core/utils/constants.dart';
import 'budget_expenses_card.dart';
import 'custom_home_app_bar.dart';
import 'custom_pie_chart.dart';
import 'expenses_list.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody(
      {super.key, required this.familyData, required this.expenses});
  final Map<String, dynamic> familyData;
  final List<Expense> expenses;

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  BannerAd? _bannerAd;

  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // loadBannerAd(context, adUnitBannerId).then((ad) {
    //   setState(() {
    //     _bannerAd = ad;
    //     isLoaded = ad != null;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              slivers: [
                CustomHomeAppBar(familyData: widget.familyData),
                SliverPadding(padding: EdgeInsets.all(5)),
                BudgetExpensesCard(familyData: widget.familyData),
                SliverPadding(padding: EdgeInsets.all(10)),
                SliverToBoxAdapter(
                  child: _bannerAd != null
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: SafeArea(
                            child: SizedBox(
                              width: _bannerAd!.size.width.toDouble(),
                              height: _bannerAd!.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd!),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ),
                SliverPadding(padding: EdgeInsets.all(20)),
                CustomPieChart(familyData: widget.familyData),
                SliverPadding(padding: EdgeInsets.all(20)),
                ExpensesList(
                    familyData: widget.familyData, expenses: widget.expenses),
              ],
            )));
  }
}
