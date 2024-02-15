import 'package:flutter/material.dart';

class DeleteFolderDialog extends StatelessWidget {
  final String folderName;
  final Function(String) onDeleteFolder;

  const DeleteFolderDialog({
    super.key, 
    required this.folderName,
    required this.onDeleteFolder,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Folder'),
      content: Text('Are you sure you want to delete $folderName?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onDeleteFolder(folderName);
            Navigator.pop(context);
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
