import 'package:flutter/material.dart';
import 'event_data.dart';

class AddEventPage extends StatefulWidget {
  final Function(EventData) onSubmit;
  final List<String> folderList;
  final Function(String) onAddFolder;

  AddEventPage({
    required this.onSubmit,
    required this.folderList,
    required this.onAddFolder,
  });

  @override
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
                  dateController.text =
                      "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
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
            if (widget.folderList.isNotEmpty)
              DropdownButton<String>(
                value: selectedFolderController.text,
                onChanged: (String? value) {
                  if (value == 'Add Folder') {
                    _showAddFolderDialog(context);
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
                    DateTime date = DateTime.parse(dateController.text);
                    String place = placeController.text;
                    String note = noteController.text;

                    EventData eventData = EventData(
                      name: name,
                      date: date,
                      place: place,
                      note: note,
                      folder: selectedFolderController.text,
                    );

                    widget.onSubmit(eventData);
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

  void _showAddFolderDialog(BuildContext context) {
    TextEditingController folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Folder'),
          content: TextField(
            controller: folderNameController,
            decoration: const InputDecoration(
              labelText: 'Folder Name',
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 243, 142, 33)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(84, 197, 127, 29)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String folderName = folderNameController.text;
                if (folderName.isNotEmpty) {
                  widget.onAddFolder(folderName);
                  Navigator.pop(context); // 關掉
                  setState(() {
                    selectedFolderController.text = folderName; // 更新顯示的folder
                  });
                } else {
                  // 未輸入->顯示錯誤對話框
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const Text("Submit New Folder Name"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
