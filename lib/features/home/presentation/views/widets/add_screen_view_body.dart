import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_manager/features/home/presentation/view_model/cubit/add_expense_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/src/ad_containers.dart';
import 'package:intl/intl.dart';

import '../../../../../core/addservice/add_service.dart';
import '../../../../../core/app_router/app_router_constants.dart';
import '../../../../../core/utils/constants.dart';

class AddScreenViewBody extends StatefulWidget {
  const AddScreenViewBody({super.key, required this.familyData});
  final Map<String, dynamic> familyData;

  @override
  State<AddScreenViewBody> createState() => _AddScreenViewBodyState();
}

class _AddScreenViewBodyState extends State<AddScreenViewBody> {
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLoading = false;
  Future<void> addExpense() async {
    if (!formKey.currentState!.validate() ||
        selectedCat == null ||
        selectedMethod == null) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    await context.read<AddExpenseCubit>().addExpense(
        familyId: widget.familyData['familyId'],
        userId: currentUser!.uid,
        expenseData: {
          "userName": currentUser!.email ?? "",
          "userId": currentUser!.uid,
          "title": titleController.text,
          "amount": double.tryParse(amountController.text),
          "category": selectedCat,
          "method": selectedMethod,
          "note": noteController.text,
          "date": selectedDate ?? DateTime.now(),
        });

    setState(() {
      isLoading = false;
    });
  }

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  String? selectedMethod;
  String? selectedCat;
  DateTime? selectedDate;

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    } else {
      selectedDate = DateTime.now();
    }
  }

  InterstitialAd? interstitialAd;

  /// Loads an interstitial ad.
  void loadAd() {
    InterstitialAd.load(
        adUnitId: adUnitInterstatialId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  BannerAd? _bannerAd;

  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadBannerAd(context, adUnitBannerId).then((ad) {
      setState(() {
        _bannerAd = ad;
        isLoaded = ad != null;
      });
    });
    loadAd();
    // loadInterstitialAd(adUnitId).then((ad) {
    //   setState(() {
    //     interstitialAd = ad;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddExpenseCubit, AddExpenseState>(
      listener: (context, state) {
        if (state is AddExpenseSuccess) {
          if (context.mounted) {
            context.go(kHomeScreen, extra: widget.familyData);
          }
        } else if (state is AddExpenseFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                SizedBox(
                  height: 350,
                  child: Form(
                      key: formKey,
                      child: ListView(
                        children: [
                          TextFormField(
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Enter a valid title";
                              } else {
                                return null;
                              }
                            },
                            controller: titleController,
                            decoration: InputDecoration(
                                hintText: "Title",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Enter a valid amount";
                              } else {
                                return null;
                              }
                            },
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: "Amount",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: noteController,
                            decoration: InputDecoration(
                                hintText: "Notes",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(height: 10),
                          DropdownButton(
                            borderRadius: BorderRadius.circular(10),
                            underline: Container(),
                            hint: Text("Select Payment method"),
                            items: method
                                .map((m) => DropdownMenuItem(
                                      value: m,
                                      child: Text(m),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                selectedMethod = v;
                              });
                            },
                            value: selectedMethod,
                          ),
                          SizedBox(height: 10),
                          DropdownButton(
                              underline: Container(),
                              hint: Text("Select Category"),
                              items: cats
                                  .map((c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c),
                                      ))
                                  .toList(),
                              onChanged: (v) {
                                setState(() {
                                  selectedCat = v;
                                });
                              },
                              value: selectedCat)
                        ],
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        icon: Icon(
                          Icons.calendar_month,
                          color: Colors.deepOrange,
                        ),
                        onPressed: () {
                          selectDate(context);
                        },
                        label: Text("Select date")),
                    Text(DateFormat('yyyy-MM-dd')
                        .format(selectedDate ?? DateTime.now())),
                  ],
                ),
                SizedBox(height: 20),
                _bannerAd != null
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
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      await addExpense();
                      await interstitialAd!.show();
                    },
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text("Add")),
              ],
            ),
          ),
        );
      },
    );
  }
}
