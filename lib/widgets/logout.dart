import 'package:baseproject/widgets/app_widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logout {
  // Logout alert dialog
  bottomSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.priority_high_outlined, color: Colors.red),
              SizedBox(width: 10),
              Text('Sign out'),
            ],
          ),
          content: const Text("Do you want to logout?"),
          actions: <Widget>[
            AppButton(
              width: .2,
              title: "No",
              //child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            AppButton(
              backgroundColor: Colors.red,
              width: .2,
              title: 'Yes',
              onPressed: () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, 'login', (route) => false);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
