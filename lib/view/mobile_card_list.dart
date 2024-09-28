import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../view_model/data_view_model.dart';
import '../view_model/google.dart';
import '../widget/elevated_button.dart';
import '../widget/mobile_card.dart';
import '../widget/toggle.dart';
import 'add_folder_dialog.dart';
import 'delete_folder_dialog.dart';

class MobileCardList extends StatelessWidget {
  const MobileCardList({super.key});
  String formattedDate(String dateStr) {
      // 解析日期字符串
      DateTime date = DateTime.parse(dateStr);

      // 使用DateFormat來獲取星期幾
      String dayOfWeek = DateFormat('EEEE').format(date); // 'EEEE' 表示完整的星期幾
      String formatted = DateFormat('MM-dd').format(date); // 保留原本的日期格式

      // 返回格式化後的結果
      return '$formatted-$dayOfWeek';
    }
  @override
  Widget build(BuildContext context) {
    return Consumer2<GoogleViewModel, DataViewModel>(
        builder: (context, goodleVM, homeVM, child) => Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(
                    color: Color.fromRGBO(255, 255, 255, 1)),
                // Main area title
                backgroundColor: const Color.fromARGB(255, 7, 34, 45),
                titleTextStyle: const TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 15,
                ),
                toolbarHeight: 80,
                title: Text(
                  'To-do List - ${homeVM.selectedFolder}',
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                actions: [
                  Row(children: [
                    const ToggleButton(),
                    const SizedBox(width: 8),
                    CustomElevatedButton(
                      hei: 120,
                      wid: 40,
                      textSize: 15,
                      onPressed: () => goodleVM.signOut().then((_) {
                        homeVM.loadData(context);
                      }),
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
                              'lib/picture/shiba_wallpaper.jpg'), // 使�?�AssetImage???�???��??
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
              body: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          for (int i = 0;
                              i < homeVM.todoItemList.length;
                              i++) // Events
                            if ((homeVM.selectedFolder == 'All' ||
                                    homeVM.todoItemList[i].folder ==
                                        homeVM.selectedFolder) &&
                                homeVM.todoItemList[i].ischecked == false)
                              MobileExtensionCard(
                                isChecked: homeVM.todoItemList[i].ischecked,
                                title: homeVM.todoItemList[i].name,
                                date: formattedDate(homeVM.todoItemList[i].date),
                                note: homeVM.todoItemList[i].note,
                                place: homeVM.todoItemList[i].place,
                                folder: homeVM.todoItemList[i].folder,
                                onDelete: () {
                                  homeVM.deleteTodoItem(i, context);
                                },
                                onCkeckedChange: (bool? value) {
                                  homeVM.changeCheckState(i, context);
                                },
                              ),
                          for (int i = 0;
                              i < homeVM.todoItemList.length;
                              i++) // Events
                            if ((homeVM.selectedFolder == 'All' ||
                                    homeVM.todoItemList[i].folder ==
                                        homeVM.selectedFolder) &&
                                homeVM.todoItemList[i].ischecked == true)
                              MobileExtensionCard(
                                isChecked: homeVM.todoItemList[i].ischecked,
                                title: homeVM.todoItemList[i].name,
                                date: (homeVM.todoItemList[i].date),
                                note: homeVM.todoItemList[i].note,
                                place: homeVM.todoItemList[i].place,
                                folder: homeVM.todoItemList[i].folder,
                                onDelete: () {
                                  homeVM.deleteTodoItem(i, context);
                                },
                                onCkeckedChange: (bool? value) {
                                  homeVM.changeCheckState(i, context);
                                },
                              )
                        ],
                      )
                    ],
                  )),
            ));
  }
}
