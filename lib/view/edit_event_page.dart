import 'package:flutter/material.dart';
import 'package:flutter_application_template/model/user.dart';
import 'package:flutter_application_template/view/add_folder_dialog.dart';
import 'package:flutter_application_template/view/warning_dialog.dart';
import 'package:flutter_application_template/view_model/google.dart';
import 'package:flutter_application_template/view_model/data_view_model.dart';
import 'package:flutter_application_template/widget/elevated_button.dart';
import 'package:provider/provider.dart';

class EditEventPage extends StatelessWidget {
  final Function(TodoItem) onSubmit;
  final List<String> folderList;
  final Function(String) onAddFolder;
  final int index;
  final String name;
  final String date;
  final String note;
  final String place;
  final String folder;

  const EditEventPage(
      {super.key,
      required this.onSubmit,
      required this.folderList,
      required this.onAddFolder,
      required this.index,
      required this.name,
      required this.date,
      required this.note,
      required this.place,
      required this.folder});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController dateController = TextEditingController(text: date);
    TextEditingController placeController = TextEditingController(text: place);
    TextEditingController noteController = TextEditingController(text: note);
    ValueNotifier<String> selectedFolderController =
        ValueNotifier<String>(folder);

    return Consumer2<GoogleViewModel, DataViewModel>(
      builder: (context, goodleVM, homeVM, child) => Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Name',
              style: TextStyle(fontSize: 10),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Date',
              style: TextStyle(fontSize: 10),
            ),
            InkWell(
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null) {
                  // Format the selected date to "yyyy-MM-dd" format
                  String formattedDate =
                      "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                  dateController.text = formattedDate;
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: dateController,
                  decoration:
                      const InputDecoration(icon: Icon(Icons.date_range)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Place',
              style: TextStyle(fontSize: 10),
            ),
            TextField(
              controller: placeController,
              decoration: const InputDecoration(hintText: 'Place'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Note',
              style: TextStyle(fontSize: 10),
            ),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(hintText: 'Note'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Folder',
              style: TextStyle(fontSize: 10),
            ),
            if (folderList.isNotEmpty)
              ValueListenableBuilder<String>(
                valueListenable: selectedFolderController,
                builder: (context, value, child) {
                  return DropdownButton<String>(
                    value: value,
                    onChanged: (String? newValue) {
                      if (newValue == 'Add Folder') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ShowAddFolderDialog(
                              onAddFolder: (String folderName) {
                                onAddFolder(folderName);
                                selectedFolderController.value = folderName;
                              },
                            );
                          },
                        );
                      } else if (newValue != null) {
                        selectedFolderController.value = newValue;
                      }
                    },
                    items: [
                      ...folderList.map<DropdownMenuItem<String>>(
                        (String folder) {
                          return DropdownMenuItem<String>(
                            value: folder,
                            child: Text(folder),
                          );
                        },
                      ),
                      const DropdownMenuItem<String>(
                        value: 'Add Folder',
                        child: Text('Add Folder'),
                      ),
                    ],
                  );
                },
              )
            else
              CustomElevatedButton(
                textSize: 16,
                wid: 15,
                hei: 10,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ShowAddFolderDialog(
                        onAddFolder: (String folderName) {
                          onAddFolder(folderName);
                          selectedFolderController.value = folderName;
                        },
                      );
                    },
                  );
                },
                child: const Text('Add Folder'),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevatedButton(
                  textSize: 16,
                  wid: 10,
                  hei: 100,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                CustomElevatedButton(
                  textSize: 16,
                  wid: 10,
                  hei: 100,
                  onPressed: () {
                    String name = nameController.text;
                    String date = dateController.text;
                    String place = placeController.text;
                    String note = noteController.text;

                    TodoItem tempTodoItem = TodoItem(
                      name: name,
                      date: date,
                      place: place,
                      note: note,
                      folder: selectedFolderController.value,
                      ischecked: false,
                    );

                    if (name.isNotEmpty && date.isNotEmpty) {
                      onSubmit(tempTodoItem);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const WarningDialog();
                        },
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
