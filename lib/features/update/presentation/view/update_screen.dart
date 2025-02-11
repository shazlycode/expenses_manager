import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  Future<void> updateApp() async {
    if (await canLaunchUrl(Uri.parse(
        "https://play.google.com/store/apps/details?id=com.shazlycode.expenses_manager"))) {
      await launchUrl(Uri.parse(
          "https://play.google.com/store/apps/details?id=com.shazlycode.expenses_manager"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(15),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "Update Available! Tap to get the latest version of Expenses Manager and enjoy new features, improvements, and bug fixes."),
            ElevatedButton.icon(
              onPressed: () => updateApp(),
              label: Text("Update"),
              icon: Icon(Icons.update),
            )
          ],
        ),
      ),
    ));
  }
}
