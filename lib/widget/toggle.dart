import 'package:flutter/material.dart';
import 'package:flutter_application_template/view/calendar_page.dart';
import 'package:flutter_application_template/view/list_page.dart';

class ToggleButton extends StatefulWidget {
  const ToggleButton({super.key});

  @override
  State<ToggleButton> createState() => _MyWidgetState();
}

List<bool> isSelected = [true, false];

class _MyWidgetState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
        // list of booleans
        isSelected: isSelected,
        // text color of selected toggle
        selectedColor: const Color.fromARGB(255, 255, 255, 255),
        // icon color
        color: const Color.fromARGB(181, 65, 67, 119),
        // fill color of selected toggle
        fillColor: const Color.fromARGB(143, 61, 139, 198),
        // when pressed, splash color is seen
        splashColor: const Color.fromARGB(124, 133, 175, 249),
        // if consistency is needed for all text style
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        // border properties for each toggle
        renderBorder: true,
        borderColor: Colors.black,
        borderWidth: 1.5,
        borderRadius: BorderRadius.circular(15),
        selectedBorderColor: const Color.fromARGB(255, 255, 255, 255),
// add widgets for which the users need to toggle
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.list),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.calendar_view_week,
              )),
        ],
// to select or deselect when pressed
        onPressed: (int newIndex) {
          setState(() {
            // looping through the list of booleans values
            for (int index = 0; index < isSelected.length; index++) {
              // checking for the index value
              if (index == newIndex) {
                // one button is always set to true
                isSelected[index] = true;
              } else {
                // other two will be set to false and not selected
                isSelected[index] = false;
              }
            }
          });
          if (newIndex == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ListPage()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalendarPage()),
            );
          }
        });
  }
}
