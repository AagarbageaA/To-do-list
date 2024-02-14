import 'package:flutter/material.dart';
import 'package:flutter_application_template/model/user.dart';
import 'package:flutter_application_template/repo/user_repo.dart';
import 'package:flutter_application_template/view/add_folder_dialog.dart';
import 'package:flutter_application_template/view/delete_folder_dialog.dart';
import 'package:flutter_application_template/view/rename_folder_dialog.dart';
import 'package:flutter_application_template/view_model/google.dart';
import 'package:flutter_application_template/widget/cell.dart';
import 'package:provider/provider.dart';
import 'add_event_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> todoItemList = [];
  List<String> folderList = []; // Add initial folders
  String selectedFolder = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Main area title
        title: Text('To-do List - $selectedFolder'), // Update the app bar title
        actions: [
          if (context.watch<GoogleViewModel>().user == null)
            ElevatedButton(
              onPressed: () =>
                  context.read<GoogleViewModel>().signInWithGoogle().then((_) {
                _loadData(); // Load data after sign-in
              }),
              child: const Text("Sign in"),
            )
          else Column(
            children:[
              Text("log in with ${context.read<GoogleViewModel>().user?.displayName}"),
              ElevatedButton(
                      onPressed: () => context.read<GoogleViewModel>().signOut(),
                      child: const Text("Sign out"),
                    ),
          ])
              
        ],
          
          
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return RenameFolderDialog(
                              folderName: folderName,
                              onRenameFolder: _renameFolder,
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      // Delete folder
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeleteFolderDialog(
                              folderName: folderName,
                              onDeleteFolder: _deleteFolder,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ListTile(
              // Add folder
              title: const Text('Add Folder'),
              onTap: () {
                showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ShowAddFolderDialog(
                          onAddFolder: (String folderName) {
                            setState(() {
                              folderList.add(folderName); // 使用回调函数添加文件夹
                              selectedFolder= folderName; // 更新所选文件夹
                            });
                          },
                        );
                      },
                    );
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
                        child: buildTableCell('Name'),
                      ),
                      Expanded(
                        child: buildTableCell('Date'),
                      ),
                      Expanded(
                        child: buildTableCell('Place'),
                      ),
                      Expanded(
                        child: buildTableCell('Note'),
                      ),
                      Expanded(
                        child: buildTableCell('Folder'),
                      ),
                      const SizedBox(
                          width: 65), // Save place for deletion button
                    ],
                  ),
                  const Divider(
                    thickness: 3,
                    color: Color.fromARGB(58, 99, 70, 2),
                  ),
                  for (int i = 0; i < todoItemList.length; i++) // Events
                    if (selectedFolder == 'All' ||
                        todoItemList[i].folder == selectedFolder)
                      Row(
                        children: [
                          Expanded(
                            child: buildTableCell(todoItemList[i].name),
                          ),
                          Expanded(
                            child: buildTableCell(
                              todoItemList[i].date),
                          ),
                          Expanded(
                            child: buildTableCell(todoItemList[i].place),
                          ),
                          Expanded(
                            child: buildTableCell(todoItemList[i].note),
                          ),
                          Expanded(
                            child: buildTableCell(todoItemList[i].folder),
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
                                  todoItemList.removeAt(i);
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _upload,
            child: const Icon(Icons.cloud_upload),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return AddEventPage(
                    onSubmit: (data) {
                      setState(() {
                        todoItemList.add(data);
                        todoItemList.sort((a, b) => a.date.compareTo(b.date));
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
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  
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
  

  void _loadData() async {
    final googleViewModel = context.read<GoogleViewModel>();
    if (googleViewModel.user != null) {
      final user = await UserRepo.read(googleViewModel.user!.uid);
      if (user != null) {
        setState(() {
          folderList = user.folders;
          todoItemList = user.todoList.map((todoItem) {
            return TodoItem(
              name: todoItem.name,
              date: todoItem.date , 
              place: todoItem.place,
              note: todoItem.note ,
              folder: todoItem.folder ,
            );
          }).toList();
        });
      } 
    }
  }
  Future<void> _upload() async {
    final googleViewModel = context.read<GoogleViewModel>();
    // log in?
    if (googleViewModel.user != null) {

        final user = User(
          uid: googleViewModel.user!.uid,
          todoList: todoItemList,
          folders: folderList,
        );
        await UserRepo.update(user);
    } 
  }
}
