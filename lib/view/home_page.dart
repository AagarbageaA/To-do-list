import 'package:flutter/material.dart';
import 'package:flutter_application_template/model/user.dart';
import 'package:flutter_application_template/repo/user_repo.dart';
import 'package:flutter_application_template/view/add_folder_dialog.dart';
import 'package:flutter_application_template/view/delete_folder_dialog.dart';
import 'package:flutter_application_template/view/rename_folder_dialog.dart';
import 'package:flutter_application_template/view_model/google.dart';
import 'package:flutter_application_template/view_model/homepage_view_model.dart';
import 'package:flutter_application_template/widget/cell.dart';
import 'package:provider/provider.dart';
import 'add_event_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<GoogleViewModel,HomePageViewModel>(
      builder: (context, goodleVM, homeVM, child)=>
        Scaffold(
      appBar: AppBar(
        // Main area title
        title: Text('To-do List - ${homeVM.selectedFolder}'), // Update the app bar title
        actions: [
          if (context.watch<GoogleViewModel>().user == null)
            ElevatedButton(
              onPressed: () =>
                  goodleVM.signInWithGoogle().then((_) {
                _loadData(goodleVM, homeVM);
              }),
              child: const Text("Sign in"),
            )
          else Column(
            children:[
              Text("log in with ${goodleVM.user?.displayName}"),
              ElevatedButton(
                      onPressed: () => goodleVM.signOut(),
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
                  mainAxisAlignment: MainAxisAlignment.center, // 将文字置中
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
                _selectFolder(context, 'All');
              },
            ),
            for (String folderName in homeVM.folderList) // List all folders
              ListTile(
                title: Text(folderName),
                onTap: () {
                  _selectFolder(context, folderName);
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
                              onRenameFolder: (folderName,newFolderName) => _renameFolder(context, folderName, newFolderName),
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
                              onDeleteFolder: (folderName) => _deleteFolder(context, folderName),
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
                            _addFolder(context, folderName);
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
                  for (int i = 0; i < homeVM.todoItemList.length; i++) // Events
                    if (homeVM.selectedFolder == 'All' ||
                        homeVM.todoItemList[i].folder == homeVM.selectedFolder)
                      Row(
                        children: [
                          Expanded(
                            child: buildTableCell(homeVM.todoItemList[i].name),
                          ),
                          Expanded(
                            child: buildTableCell(
                              homeVM.todoItemList[i].date),
                          ),
                          Expanded(
                            child: buildTableCell(homeVM.todoItemList[i].place),
                          ),
                          Expanded(
                            child: buildTableCell(homeVM.todoItemList[i].note),
                          ),
                          Expanded(
                            child: buildTableCell(homeVM.todoItemList[i].folder),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 25),
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 255, 157, 0),
                              ),
                              onPressed: () {
                                _deleteTodoItem(context, i);
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
            onPressed: () => _upload(context),
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
                      _addTodoItem(context, data);
                      Navigator.of(context).pop();
                    },
                    folderList: homeVM.folderList,
                    onAddFolder: (folderName) => _addFolder(context, folderName),
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      )
    );
  }

  void _addFolder(BuildContext context, String newFolderName) {
    if (newFolderName.isNotEmpty) {
      context.read<HomePageViewModel>().addFolder(newFolderName);
    }
  }

  void _renameFolder(BuildContext context, String folderName, String newFolderName) {
    if (folderName.isNotEmpty && newFolderName.isNotEmpty) {
      context.read<HomePageViewModel>().renameFolder(folderName, newFolderName);
    }
  }

  void _deleteFolder(BuildContext context, String folderName) {
    context.read<HomePageViewModel>().deleteFolder(folderName);
  }

  void _selectFolder(BuildContext context, String folderName) {
    context.read<HomePageViewModel>().selectFolder(folderName);
    Navigator.pop(context); // Close the drawer after selecting a folder
  }

  void _addTodoItem(BuildContext context, TodoItem data) {
    context.read<HomePageViewModel>().addTodoItem(data);
  }

  void _deleteTodoItem(BuildContext context, int index) {
    context.read<HomePageViewModel>().deleteTodoItem(index);
  }

  void _loadData(GoogleViewModel googleViewModel, HomePageViewModel homePageViewModel) async {
    if (googleViewModel.user != null) {
      final user = await UserRepo.read(googleViewModel.user!.uid);
      if (user != null) {
        homePageViewModel.loadData(user);
      } 
    }
  }


  void _upload(BuildContext context) async {
    final googleViewModel = context.read<GoogleViewModel>();
    // log in?
    if (googleViewModel.user != null) {
      final user = User(
        uid: googleViewModel.user!.uid,
        todoList: context.read<HomePageViewModel>().todoItemList,
        folders: context.read<HomePageViewModel>().folderList,
      );
      await UserRepo.update(user);
    } 
  }
}