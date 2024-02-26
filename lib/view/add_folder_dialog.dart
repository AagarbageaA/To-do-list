import 'package:flutter/material.dart';

class ShowAddFolderDialog extends StatelessWidget {
  final Function(String) onAddFolder; // 新增的回调函数

  const ShowAddFolderDialog({super.key, required this.onAddFolder});

  @override
  Widget build(BuildContext context) {
    TextEditingController folderNameController = TextEditingController();

    return AlertDialog(
      title: const Text('Add New Folder'),
      content: TextField(
        controller: folderNameController,
        decoration: const InputDecoration(
          labelText: 'Folder Name',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 243, 142, 33)),
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
              onAddFolder(folderName);
              Navigator.pop(context);
            } else {
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
  }
}
