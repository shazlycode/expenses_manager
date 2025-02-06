import 'package:expenses_manager/core/app_router/app_router_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomFab extends StatefulWidget {
  const CustomFab({super.key});

  @override
  State<CustomFab> createState() => _CustomFabState();
}

class _CustomFabState extends State<CustomFab> {
  final DateTime now = DateTime.now();

  DateTime? selectedDate;
  bool setToday = false;

  Future<void> selectDate(BuildContext contextv) async {
    final picked = await showDatePicker(
      context: contextv,
      firstDate: DateTime(now.year, now.month, 1),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  List<String> method = ["cash", "card", "apple pay", "credit"];
  List<String> cats = [
    "Bill",
    "Entertainment",
    "Travel",
    "Grocery",
    "Clothes",
    "Food",
    "Car",
    "Health",
    "Education",
    "Others"
  ];
  String? selectedMethod;
  String? selectedCat;
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void add() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    if (context.mounted) {
      context.go(kHomeScreen);
    }
  }

  @override
  void dispose() {
    noteController.dispose();
    amountController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, StateSetter setState) {
                return Container(
                  padding: EdgeInsets.all(15),
                  color: const Color.fromARGB(255, 0, 0, 0),
                  height: 800,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text("Add new expense"),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 400,
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
                                            borderRadius:
                                                BorderRadius.circular(10))),
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
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    controller: noteController,
                                    decoration: InputDecoration(
                                        hintText: "Notes",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
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
                                      print("selectedMethod$selectedMethod");
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
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  selectDate(context);
                                },
                                child: Text("Select date")),
                            Text(selectedDate != null ? "$selectedDate" : ""),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              add();
                            },
                            child: isLoading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Text("Add"))
                      ],
                    ),
                  ),
                );
              });
            });
      },
      child: Icon(Icons.add),
    );
  }
}
