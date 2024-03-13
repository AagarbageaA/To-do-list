import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.textSize,
    required this.wid,
    required this.hei,
    this.child = const Text("Button"),
  });

  final VoidCallback onPressed;
  final Widget child;
  final double textSize;
  final double wid;
  final double hei;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(2),
        textStyle: TextStyle(fontSize: textSize),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color.fromARGB(138, 7, 34, 45),
              width: 3,
            )),
        fixedSize: Size(hei, wid),
        alignment: Alignment.center,
        foregroundColor: const Color.fromARGB(255, 7, 34, 45),
      ),
      child: child,
    );
  }
}
