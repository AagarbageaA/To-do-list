import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../view_model/data_view_model.dart';
import '../view_model/google.dart';
import '../widget/card.dart';
import '../widget/elevated_button.dart';
import '../widget/toggle.dart';
import 'add_event_page.dart';
import 'add_folder_dialog.dart';
import 'delete_folder_dialog.dart';
import 'edit_event_page.dart';

class CardList extends StatelessWidget {
    const CardList({super.key});
    String formattedDate(String dateStr) {
      // 解析日期字符串
      DateTime date = DateTime.parse(dateStr);

      // 使用DateFormat來獲取星期幾
      String dayOfWeek = DateFormat('EEEE').format(date); // 'EEEE' 表示完整的星期幾
      String formatted = DateFormat('yyyy-MM-dd').format(date); // 保留原本的日期格式

      // 返回格式化後的結果
      return '$formatted ($dayOfWeek)';
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
                              ExtensionCard(
                                isChecked: homeVM.todoItemList[i].ischecked,
                                title: homeVM.todoItemList[i].name,
                                date: formattedDate(homeVM.todoItemList[i].date),
                                note: homeVM.todoItemList[i].note,
                                place: homeVM.todoItemList[i].place,
                                folder: homeVM.todoItemList[i].folder,
                                onEdit: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return EditEventPage(
                                        onSubmit: (data) {
                                          homeVM.editTodoItem(i, data, context);
                                          Navigator.of(context).pop();
                                        },
                                        folderList: homeVM.folderList,
                                        onAddFolder: (folderName) => homeVM
                                            .addFolder(folderName, context),
                                        index: i,
                                        name: homeVM.todoItemList[i].name,
                                        date: homeVM.todoItemList[i].date,
                                        note: homeVM.todoItemList[i].note,
                                        place: homeVM.todoItemList[i].place,
                                        folder: homeVM.todoItemList[i].folder,
                                      );
                                    },
                                  );
                                },
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
                              ExtensionCard(
                                isChecked: homeVM.todoItemList[i].ischecked,
                                title: homeVM.todoItemList[i].name,
                                date: formattedDate(homeVM.todoItemList[i].date),
                                note: homeVM.todoItemList[i].note,
                                place: homeVM.todoItemList[i].place,
                                folder: homeVM.todoItemList[i].folder,
                                onEdit: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return EditEventPage(
                                        onSubmit: (data) {
                                          homeVM.editTodoItem(i, data, context);
                                          Navigator.of(context).pop();
                                        },
                                        folderList: homeVM.folderList,
                                        onAddFolder: (folderName) => homeVM
                                            .addFolder(folderName, context),
                                        index: i,
                                        name: homeVM.todoItemList[i].name,
                                        date: homeVM.todoItemList[i].date,
                                        note: homeVM.todoItemList[i].note,
                                        place: homeVM.todoItemList[i].place,
                                        folder: homeVM.todoItemList[i].folder,
                                      );
                                    },
                                  );
                                },
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
                  floatingActionButton: Align(
  alignment: Alignment.bottomCenter,
  child: ConstrainedBox(
    constraints: const BoxConstraints( maxWidth: 1000,),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.6), 
            BlendMode.dstIn, 
          ),
          child: Image.asset(
            'lib/picture/shiba_icon.png',
            fit: BoxFit.cover,
            width: 200,
            height: 200,
          ),
        ),
        FloatingActionButton(
          heroTag: "btn1",
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          splashColor: const Color.fromARGB(255, 7, 34, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color.fromARGB(139, 7, 34, 45),
              width: 4,
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
                  onAddFolder: (folderName) => context
                      .read<DataViewModel>()
                      .addFolder(folderName, context),
                );
              },
            );
          },
          child: const Icon(Icons.add,
              color: Color.fromARGB(255, 7, 34, 45)),
        ),
      ],
    ),
  ),
),
            ));
  }
}
