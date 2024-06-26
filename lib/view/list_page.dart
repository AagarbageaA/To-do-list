import 'package:flutter/material.dart';
import 'package:flutter_application_template/view/add_event_page.dart';
import 'package:flutter_application_template/view/add_folder_dialog.dart';
import 'package:flutter_application_template/view/delete_folder_dialog.dart';
import 'package:flutter_application_template/view/edit_event_page.dart';
import 'package:flutter_application_template/view_model/google.dart';
import 'package:flutter_application_template/view_model/data_view_model.dart';
import 'package:flutter_application_template/widget/cell.dart';
import 'package:flutter_application_template/widget/elevated_button.dart';
import 'package:flutter_application_template/widget/toggle.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

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
              body: Center(
                // Main area
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        children: [
                          Row(
                            // Column title row
                            children: [
                              const SizedBox(width: 50),
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
                                  width:
                                      115), // Save place for deletion button，each icon +40
                            ],
                          ),
                          const Divider(
                            thickness: 3,
                            color: Color.fromARGB(122, 7, 34, 45),
                          ),
                          for (int i = 0;
                              i < homeVM.todoItemList.length;
                              i++) // Events
                            if ((homeVM.selectedFolder == 'All' ||
                                    homeVM.todoItemList[i].folder ==
                                        homeVM.selectedFolder) &&
                                homeVM.todoItemList[i].ischecked == false)
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 25),
                                    child: Checkbox(
                                      value: homeVM.todoItemList[i].ischecked,
                                      onChanged: (bool? value) {
                                        homeVM.changeCheckState(i, context);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      style: TextStyle(
                                          color: (DateTime.parse(homeVM
                                                              .todoItemList[i]
                                                              .date)
                                                          .year ==
                                                      DateTime.now().year &&
                                                  DateTime.parse(homeVM
                                                              .todoItemList[i]
                                                              .date)
                                                          .month ==
                                                      DateTime.now().month &&
                                                  DateTime.parse(homeVM
                                                                  .todoItemList[
                                                                      i]
                                                                  .date)
                                                              .day -
                                                          DateTime.now().day <=
                                                      2)
                                              ? Colors.pink
                                              : Colors.black),
                                      homeVM.todoItemList[i].name,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      style: TextStyle(
                                          color: (DateTime.parse(homeVM
                                                              .todoItemList[i]
                                                              .date)
                                                          .year ==
                                                      DateTime.now().year &&
                                                  DateTime.parse(homeVM
                                                              .todoItemList[i]
                                                              .date)
                                                          .month ==
                                                      DateTime.now().month &&
                                                  DateTime.parse(homeVM
                                                                  .todoItemList[
                                                                      i]
                                                                  .date)
                                                              .day -
                                                          DateTime.now().day <=
                                                      2)
                                              ? Colors.pink
                                              : Colors.black),
                                      homeVM.todoItemList[i].date,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      style: TextStyle(
                                          color: (DateTime.parse(homeVM
                                                              .todoItemList[i]
                                                              .date)
                                                          .year ==
                                                      DateTime.now().year &&
                                                  DateTime.parse(homeVM
                                                              .todoItemList[i]
                                                              .date)
                                                          .month ==
                                                      DateTime.now().month &&
                                                  DateTime.parse(homeVM
                                                                  .todoItemList[
                                                                      i]
                                                                  .date)
                                                              .day -
                                                          DateTime.now().day <=
                                                      2)
                                              ? Colors.pink
                                              : Colors.black),
                                      homeVM.todoItemList[i].place,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      style: TextStyle(
                                          color: (DateTime.parse(homeVM
                                                              .todoItemList[i]
                                                              .date)
                                                          .year ==
                                                      DateTime.now().year &&
                                                  DateTime.parse(homeVM
                                                              .todoItemList[i]
                                                              .date)
                                                          .month ==
                                                      DateTime.now().month &&
                                                  DateTime.parse(homeVM
                                                                  .todoItemList[
                                                                      i]
                                                                  .date)
                                                              .day -
                                                          DateTime.now().day <=
                                                      2)
                                              ? Colors.pink
                                              : Colors.black),
                                      homeVM.todoItemList[i].note,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      style: TextStyle(
                                          color: (DateTime.parse(homeVM
                                                              .todoItemList[i]
                                                              .date)
                                                          .year ==
                                                      DateTime.now().year &&
                                                  DateTime.parse(homeVM
                                                              .todoItemList[i]
                                                              .date)
                                                          .month ==
                                                      DateTime.now().month &&
                                                  DateTime.parse(homeVM
                                                                  .todoItemList[
                                                                      i]
                                                                  .date)
                                                              .day -
                                                          DateTime.now().day <=
                                                      2)
                                              ? Colors.pink
                                              : Colors.black),
                                      homeVM.todoItemList[i].folder,
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(right: 25),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  182, 7, 34, 45),
                                            ),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return EditEventPage(
                                                    onSubmit: (data) {
                                                      homeVM.editTodoItem(
                                                          i, data, context);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    folderList:
                                                        homeVM.folderList,
                                                    onAddFolder: (folderName) =>
                                                        homeVM.addFolder(
                                                            folderName,
                                                            context),
                                                    index: i,
                                                    name: homeVM
                                                        .todoItemList[i].name,
                                                    date: homeVM
                                                        .todoItemList[i].date,
                                                    note: homeVM
                                                        .todoItemList[i].note,
                                                    place: homeVM
                                                        .todoItemList[i].place,
                                                    folder: homeVM
                                                        .todoItemList[i].folder,
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Color.fromARGB(
                                                  182, 7, 34, 45),
                                            ),
                                            onPressed: () {
                                              homeVM.deleteTodoItem(i, context);
                                            },
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                          const Gap(5),
                          const Divider(
                            thickness: 3,
                            color: Color.fromARGB(122, 7, 34, 45),
                          ),
                          const Gap(5),
                          TextButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(2),
                                textStyle: const TextStyle(fontSize: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                      color: Color.fromARGB(134, 0, 29, 61),
                                      width: 3,
                                    )),
                                alignment: Alignment.center,
                                foregroundColor:
                                    const Color.fromARGB(255, 3, 57, 79),
                              ),
                              onPressed: () {
                                homeVM.changeVisibleState(context);
                              },
                              child: const Text("Show Finished Event")),
                          if (homeVM.visible)
                            for (int i = homeVM.todoItemList.length - 1;
                                i >= 0;
                                i--)
                              // Events
                              if ((homeVM.selectedFolder == 'All' ||
                                      homeVM.todoItemList[i].folder ==
                                          homeVM.selectedFolder) &&
                                  homeVM.todoItemList[i].ischecked == true)
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 25),
                                      child: Checkbox(
                                        value: homeVM.todoItemList[i].ischecked,
                                        onChanged: (bool? value) {
                                          homeVM.changeCheckState(i, context);
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        homeVM.todoItemList[i].name,
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(182, 85, 89, 91),
                                            fontSize: 11,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        homeVM.todoItemList[i].date,
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(182, 85, 89, 91),
                                            fontSize: 11,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        homeVM.todoItemList[i].place,
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(182, 85, 89, 91),
                                            fontSize: 11,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        homeVM.todoItemList[i].note,
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(182, 85, 89, 91),
                                            fontSize: 11,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        homeVM.todoItemList[i].folder,
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(182, 85, 89, 91),
                                            fontSize: 11,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    ),
                                    const Gap(40),
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
                            height: 200,
                            width: 5000,
                            color: const Color.fromARGB(255, 255, 255, 255)
                                .withOpacity(1),
                            child: const SizedBox(),
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
                          0.6), // 調�?��?????度�????��?��??裡�??0.0 表示�???��?????�?1.0 表示�???��????????
                      BlendMode.dstIn, // 調�?�混???模�??以�????��?��?��???????????
                    ),
                    child: Image.asset(
                      'lib/picture/shiba_icon.png',
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                    ),
                  ),
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(
                          0.5), // 調�?��?????度�????��?��??裡�??0.0 表示�???��?????�?1.0 表示�???��????????
                      BlendMode.dstIn, // 調�?�混???模�??以�????��?��?��???????????
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
