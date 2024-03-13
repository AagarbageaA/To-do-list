import 'package:flutter/material.dart';
import 'package:flutter_application_template/enum/platform.dart';

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
        constraints: const BoxConstraints(
          maxHeight: 40,
          maxWidth: 60,
          minHeight: 40,
          minWidth: 60,
        ),
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

          final isListPage = newIndex == 0;
          final page = isListPage
              ? (MediaQuery.of(context).size.width >= Platform.computer.minWidth
                  ? 'list_page_route'
                  : 'mobile_list_page_route')
              : (MediaQuery.of(context).size.width >= Platform.computer.minWidth
                  ? 'calendar_page_route'
                  : 'mobile_calendar_page_route');

          if (ModalRoute.of(context)?.settings.name != page) {
            Navigator.of(context).pushReplacementNamed(page);
          }
        });
  }
}
