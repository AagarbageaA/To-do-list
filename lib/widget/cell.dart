import 'package:flutter/widgets.dart';

Widget buildTableCell(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: 
          const TextStyle(
            fontSize: 18,
            //fontWeight: FontWeight.bold,
            ),
          ),
    );
  }