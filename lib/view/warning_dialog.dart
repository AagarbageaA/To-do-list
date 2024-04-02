import 'package:flutter/material.dart';
import 'package:flutter_application_template/widget/elevated_button.dart';

class WarningDialog extends StatelessWidget {
  const WarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Warning",
        style: TextStyle(color: Color.fromARGB(198, 7, 34, 45)),
      ),
      content: const Text("Please enter Name & Date",
          style: TextStyle(color: Color.fromARGB(198, 7, 34, 45))),
      actions: <Widget>[
        CustomElevatedButton(
          textSize: 12,
          wid: 15,
          hei: 20,
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('OKkkk',
              style: TextStyle(color: Color.fromARGB(198, 7, 34, 45))),
        ),
      ],
    );
  }
}
