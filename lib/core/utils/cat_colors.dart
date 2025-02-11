import 'package:flutter/material.dart';

getCatColor(String catName) {
  switch (catName) {
    case "Clothes":
      return Colors.green;
    case "Entertainment":
      return Colors.pink;
    case "Bill":
      return Colors.amber;
    case "Travel":
      return Colors.purple;
    case "Grocery":
      return const Color.fromARGB(255, 255, 177, 60);
    case "Car":
      return Colors.blue;
    case "Health":
      return Colors.teal;
    case "Education":
      return Colors.deepOrange;
    case "Others":
      return Colors.red;
    case "Food":
      return const Color.fromARGB(255, 73, 115, 58);
  }
}
