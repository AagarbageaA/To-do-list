import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_event_page.dart';
import 'event_data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<EventData> eventDataList = [];
  List<String> folderList = ['Folder 1', 'Folder 2']; // Add initial folders
  String selectedFolder = 'All';

  void _addFolder(String newFolderName) {
    if (newFolderName.isNotEmpty) {
      setState(() {
        folderList.add(newFolderName);
      });
    }
  }

  void _renameFolder(String folderName, String newFolderName) {
    if (folderName.isNotEmpty && newFolderName.isNotEmpty) {
      setState(() {
        int index =
            folderList.indexOf(folderName); // find current folder's index
        folderList[index] = newFolderName;
      });
    }
  }

  void _deleteFolder(String folderName) {
    setState(() {
      folderList.remove(folderName);
    });
  }

  void _selectFolder(String folderName) {
    setState(() {
      selectedFolder = folderName;
      Navigator.pop(context); // Close the drawer after selecting a folder
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Main area title
        title: Text('To-do List - $selectedFolder'), // Update the app bar title
      ),
      drawer: Drawer(
        // Left-slide page
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              // Title area
              decoration: BoxDecoration(
                color: Color.fromRGBO(229, 146, 74, 0.606), // Background color
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // 將文字置中
                  children: [
                    Text(
                      // Title text
                      'Folders',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              // Fixed folder (All)
              title: const Text('All'),
              onTap: () {
                _selectFolder('All');
              },
            ),
            for (String folderName in folderList) // List all folders
              ListTile(
                title: Text(folderName),
                onTap: () {
                  _selectFolder(folderName);
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      // Edit folder name
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showRenameFolderDialog(context, folderName);
                      },
                    ),
                    IconButton(
                      // Delete folder
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteFolderDialog(context, folderName);
                      },
                    ),
                  ],
                ),
              ),
            ListTile(
              // Add folder
              title: const Text('Add Folder'),
              onTap: () {
                _showAddFolderDialog(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        // Main area
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Row(
                    // Column title row
                    children: [
                      Expanded(
                        child: _buildTableCell('Name'),
                      ),
                      Expanded(
                        child: _buildTableCell('Date'),
                      ),
                      Expanded(
                        child: _buildTableCell('Place'),
                      ),
                      Expanded(
                        child: _buildTableCell('Note'),
                      ),
                      Expanded(
                        child: _buildTableCell('Folder'),
                      ),
                      const SizedBox(
                          width: 65), // Save place for deletion button
                    ],
                  ),
                  const Divider(
                    thickness: 3,
                    color: Color.fromARGB(58, 99, 70, 2),
                  ),
                  for (int i = 0; i < eventDataList.length; i++) // Events
                    if (selectedFolder == 'All' ||
                        eventDataList[i].folder == selectedFolder)
                      Row(
                        children: [
                          Expanded(
                            child: _buildTableCell(eventDataList[i].name),
                          ),
                          Expanded(
                            child: _buildTableCell(
                              DateFormat.yMd().format(eventDataList[i].date),
                            ),
                          ),
                          Expanded(
                            child: _buildTableCell(eventDataList[i].place),
                          ),
                          Expanded(
                            child: _buildTableCell(eventDataList[i].note),
                          ),
                          Expanded(
                            child: _buildTableCell(eventDataList[i].folder),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 25),
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 255, 157, 0),
                              ),
                              onPressed: () {
                                setState(() {
                                  eventDataList.removeAt(i);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Add event
        onPressed: () {
          showModalBottomSheet(
            // Bottom page
            context: context,
            builder: (BuildContext context) {
              return AddEventPage(
                onSubmit: (data) {
                  setState(() {
                    eventDataList.add(data);

                    eventDataList.sort(
                        (a, b) => a.date.compareTo(b.date)); // Sorted with date
                  });
                  Navigator.of(context).pop();
                },
                folderList: folderList,
                onAddFolder: _addFolder,
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTableCell(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(text),
    );
  }

  void _showAddFolderDialog(BuildContext context) {
    TextEditingController folderNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Folder'),
          content: TextField(
            controller: folderNameController,
            decoration: const InputDecoration(labelText: 'Folder Name'),
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
                  _addFolder(folderName);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showRenameFolderDialog(BuildContext context, String folderName) {
    TextEditingController newFolderNameController =
        TextEditingController(text: folderName);
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  _renameFolder(folderName, newFolderName);
                }
                Navigator.pop(context);
              },
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteFolderDialog(BuildContext context, String folderName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                _deleteFolder(folderName);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
