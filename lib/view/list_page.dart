import 'package:flutter/material.dart';
import 'package:flutter_application_template/view/add_event_page.dart';
import 'package:flutter_application_template/view/add_folder_dialog.dart';
import 'package:flutter_application_template/view/delete_folder_dialog.dart';
import 'package:flutter_application_template/view/rename_folder_dialog.dart';
import 'package:flutter_application_template/view_model/google.dart';
import 'package:flutter_application_template/view_model/homepage_view_model.dart';
import 'package:flutter_application_template/widget/cell.dart';
import 'package:flutter_application_template/widget/elevated_button.dart';
import 'package:flutter_application_template/widget/toggle.dart';
import 'package:provider/provider.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<GoogleViewModel, HomePageViewModel>(
        builder: (context, goodleVM, homeVM, child) => Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(
                    color: Color.fromRGBO(255, 255, 255, 1)),
                // Main area title
                backgroundColor: const Color.fromARGB(255, 7, 34, 45),
                titleTextStyle: const TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 30,
                ),
                toolbarHeight: 80,
                title: Text(
                    'To-do List - ${homeVM.selectedFolder}'), // Update the app bar title
                actions: [
                  Row(children: [
                    const ToggleButton(),
                    const SizedBox(width: 20),
                    Text(
                      "Login with ${goodleVM.user?.displayName}  ",
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 14,
                      ),
                    ),
                    CustomElevatedButton(
                      hei: 120,
                      wid: 40,
                      textSize: 15,
                      onPressed: () => goodleVM.signOut(),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login),
                          SizedBox(width: 10),
                          Text("Log out",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                  ])
                ],
              ),
              drawer: Drawer(
                // Left-slide page
                backgroundColor: const Color.fromARGB(255, 238, 247, 250),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                      margin: EdgeInsets.only(bottom: 8.0),
                      // Title area
                      decoration: BoxDecoration(
                        color:
                            Color.fromARGB(255, 7, 34, 45), // Background color
                        image: DecorationImage(
                          image: AssetImage(
                              'images/shiba_wallpaper.jpg'), // 使用AssetImage提供图片
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: null,
                    ),
                    ListTile(
                      // Fixed folder (All)
                      title: const Text('All'),
                      onTap: () {
                        homeVM.selectFolder('All');
                        Navigator.of(context).pop();
                      },
                    ),
                    for (String folderName
                        in homeVM.folderList) // List all folders
                      ListTile(
                        title: Text(folderName),
                        onTap: () {
                          homeVM.selectFolder(folderName);
                          Navigator.of(context).pop();
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
                                      onRenameFolder: (folderName,
                                              newFolderName) =>
                                          homeVM.renameFolder(folderName,
                                              newFolderName, context),
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              // Delete folder,
                              icon: const Icon(
                                Icons.delete,
                                color: Color.fromARGB(196, 7, 34, 45),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DeleteFolderDialog(
                                      folderName: folderName,
                                      onDeleteFolder: (folderName) => homeVM
                                          .deleteFolder(folderName, context),
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
                                homeVM.addFolder(folderName, context);
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
                              const SizedBox(
                                  width: 65), // Save place for deletion button
                            ],
                          ),
                          const Divider(
                            thickness: 3,
                            color: Color.fromARGB(122, 7, 34, 45),
                          ),
                          for (int i = 0;
                              i < homeVM.todoItemList.length;
                              i++) // Events
                            if (homeVM.selectedFolder == 'All' ||
                                homeVM.todoItemList[i].folder ==
                                    homeVM.selectedFolder)
                              Row(
                                children: [
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: buildTableCell(
                                        homeVM.todoItemList[i].name),
                                  ),
                                  Expanded(
                                    child: buildTableCell(
                                        homeVM.todoItemList[i].date),
                                  ),
                                  Expanded(
                                    child: buildTableCell(
                                        homeVM.todoItemList[i].place),
                                  ),
                                  Expanded(
                                    child: buildTableCell(
                                        homeVM.todoItemList[i].note),
                                  ),
                                  Expanded(
                                    child: buildTableCell(
                                        homeVM.todoItemList[i].folder),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 25),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Color.fromARGB(182, 7, 34, 45),
                                      ),
                                      onPressed: () {
                                        homeVM.deleteTodoItem(i, context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                          Container(
                            height: 9000,
                            width: 5000,
                            color: Color.fromARGB(0, 255, 255, 255).withOpacity(
                                1), // 調整透明度的值在這裡，0.0 表示完全透明，1.0 表示完全不透明
                            child: SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(
                          0.6), // 調整透明度的值在這裡，0.0 表示完全透明，1.0 表示完全不透明
                      BlendMode.dstIn, // 調整混合模式以達到您想要的效果
                    ),
                    child: Image.asset(
                      'images/shiba_icon.png',
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                    ),
                  ),
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(
                          0.5), // 調整透明度的值在這裡，0.0 表示完全透明，1.0 表示完全不透明
                      BlendMode.dstIn, // 調整混合模式以達到您想要的效果
                    ),
                    child: FloatingActionButton(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      splashColor: const Color.fromARGB(255, 7, 34, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color.fromARGB(139, 7, 34, 45),
                          width: 4,
                          strokeAlign: -1,
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return AddEventPage(
                              onSubmit: (data) {
                                homeVM.addTodoItem(data, context);
                                Navigator.of(context).pop();
                              },
                              folderList: homeVM.folderList,
                              onAddFolder: (folderName) =>
                                  homeVM.addFolder(folderName, context),
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.add,
                          color: Color.fromARGB(255, 7, 34, 45)),
                    ),
                  ),
                ],
              ),
            ));
  }
}