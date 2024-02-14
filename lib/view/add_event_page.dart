import 'package:flutter/material.dart';
import 'package:flutter_application_template/model/user.dart';
import 'package:flutter_application_template/view/add_folder_dialog.dart';

class AddEventPage extends StatefulWidget {
  final Function(TodoItem) onSubmit;
  final List<String> folderList;
  final Function(String) onAddFolder;

  const AddEventPage({super.key, 
    required this.onSubmit,
    required this.folderList,
    required this.onAddFolder,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController selectedFolderController =
      TextEditingController(); // 新增 selectedFolderController

  @override
  void initState() {
    super.initState();
    if (widget.folderList.isNotEmpty) {
      selectedFolderController.text = widget.folderList[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Name',
              style: TextStyle(fontSize: 18),
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
                  String formattedDate = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
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
            if (widget.folderList.isNotEmpty)
              DropdownButton<String>(
                value: selectedFolderController.text,
                onChanged: (String? value) {
                  if (value == 'Add Folder') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ShowAddFolderDialog(
                          onAddFolder: (String folderName) {
                            setState(() {
                              widget.onAddFolder(folderName); // 使用回调函数添加文件夹
                              selectedFolderController.text = folderName; // 更新所选文件夹
                            });
                          },
                        );
                      },
                    );
                  } else if (value != null) {
                    setState(() {
                      selectedFolderController.text = value;
                    });
                  }
                },
                items: [
                  ...widget.folderList.map<DropdownMenuItem<String>>(
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
              ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
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
                      folder: selectedFolderController.text,
                    );

                    widget.onSubmit(tempTodoItem);
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
