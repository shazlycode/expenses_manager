import 'dart:io';

const kAppLogo = "assets/images/logo.png";
const List<String> method = ["cash", "card", "apple pay", "credit"];
const List<String> cats = [
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

final adUnitBannerId = Platform.isAndroid
    ? 'ca-app-pub-4877259958230721/2857018659'
    : 'ca-app-pub-4877259958230721/2857018659';

final adUnitInterstatialId = Platform.isAndroid
    ? 'ca-app-pub-4877259958230721/4804525146'
    : 'ca-app-pub-4877259958230721/4804525146';
