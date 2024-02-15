import 'package:flutter/material.dart';

class RenameFolderDialog extends StatelessWidget {
  final String folderName;
  final Function(String, String) onRenameFolder;

  const RenameFolderDialog({
    super.key, 
    required this.folderName, 
    required this.onRenameFolder});

  @override
  Widget build(BuildContext context) {
    TextEditingController newFolderNameController =
        TextEditingController(text: folderName);

    return AlertDialog(
      title: const Text('Rename Folder'),
      content: TextField(
        controller: newFolderNameController,
        decoration: const InputDecoration(labelText: 'New Folder Name'),
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
            String newFolderName = newFolderNameController.text;
            if (newFolderName.isNotEmpty) {
              onRenameFolder(folderName, newFolderName);
            }
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
