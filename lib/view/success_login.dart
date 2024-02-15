import 'package:flutter/material.dart';
import 'package:flutter_application_template/view/add_event_page.dart';
import 'package:flutter_application_template/view/add_folder_dialog.dart';
import 'package:flutter_application_template/view/delete_folder_dialog.dart';
import 'package:flutter_application_template/view/rename_folder_dialog.dart';
import 'package:flutter_application_template/view_model/google.dart';
import 'package:flutter_application_template/view_model/homepage_view_model.dart';
import 'package:flutter_application_template/widget/cell.dart';
import 'package:flutter_application_template/widget/elevated_button.dart';
import 'package:provider/provider.dart';

class LoginSuccessPage extends StatelessWidget {
  const LoginSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<GoogleViewModel,HomePageViewModel>(
        builder: (context, goodleVM, homeVM, child)=>
          Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Color.fromRGBO(255, 255, 255, 1)),
              // Main area title
              backgroundColor: const Color.fromARGB(255, 7, 34, 45),
              titleTextStyle:
                const TextStyle(
                  color:  Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 30,
                  
                ),
              toolbarHeight: 80,
              title: Text('To-do List - ${homeVM.selectedFolder}'), // Update the app bar title
              actions: [
                Row(
                  children:[
                    Text(
                      "Login with ${goodleVM.user?.displayName}  ",
                      style: 
                        const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 12,
                          ),
                        
                    ),
                    CustomElevatedButton(
                      hei:100,
                      wid:40,
                      textSize:15,
                      onPressed: () => goodleVM.signOut(),
                      child: const Text("Sign out"),
                    ),
                    const SizedBox(width: 20),
                  ]
                )
              ],
            ),
      drawer: Drawer(
        // Left-slide page
        backgroundColor:const Color.fromARGB(255, 238, 247, 250),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              margin : EdgeInsets.only(bottom: 8.0),
              // Title area
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 7, 34, 45), // Background color
                image: DecorationImage(
                  image: AssetImage('images/shiba_wallpaper.jpg'), // 使用AssetImage提供图片
                  fit: BoxFit.fill,
                ),
              ), child: null,

            ),
            ListTile(
              // Fixed folder (All)
              title: const Text('All'),
              onTap: () {
                homeVM.selectFolder('All');
              },
              
            ),
            for (String folderName in homeVM.folderList) // List all folders
              ListTile(
                title: Text(folderName),
                onTap: () {
                  homeVM.selectFolder(folderName);
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
                              onRenameFolder: (folderName,newFolderName) => homeVM.renameFolder(folderName, newFolderName,context ),
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
                              onDeleteFolder: (folderName) => homeVM.deleteFolder(folderName,context),
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
                            homeVM.addFolder(folderName,context);
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
                      const SizedBox(width: 20),
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
                      const SizedBox(width: 65), // Save place for deletion button
                    ],
                  ),
                  const Divider(
                    thickness: 3,
                    color: Color.fromARGB(122, 7, 34, 45),
                  ),
                  for (int i = 0; i < homeVM.todoItemList.length; i++) // Events
                    if (homeVM.selectedFolder == 'All' ||
                        homeVM.todoItemList[i].folder == homeVM.selectedFolder)
                      Row(
                        children: [
                          const SizedBox(width: 20),
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
                                homeVM.deleteTodoItem(i,context);
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
           backgroundColor:const Color.fromARGB(255, 255, 255, 255),
            splashColor:const Color.fromARGB(255, 7, 34, 45),
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side:const BorderSide(
                color:  Color.fromARGB(139, 7, 34, 45),
                width:4,
                strokeAlign:-1,
                ),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return AddEventPage(
                    onSubmit: (data) {
                      homeVM.addTodoItem(data,context);
                      Navigator.of(context).pop();
                    },
                    folderList: homeVM.folderList,
                    onAddFolder: (folderName) => homeVM.addFolder(folderName,context),
                  );
                },
              );
            },
            child: const Icon(Icons.add,color:Color.fromARGB(255, 7, 34, 45)),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      )
    );
  }
}