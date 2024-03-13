import 'package:flutter/material.dart';
import 'package:flutter_application_template/view/delete_folder_dialog.dart';
import 'package:flutter_application_template/view_model/google.dart';
import 'package:flutter_application_template/view_model/homepage_view_model.dart';
import 'package:flutter_application_template/widget/cell.dart';
import 'package:flutter_application_template/widget/elevated_button.dart';
import 'package:flutter_application_template/widget/toggle.dart';
import 'package:provider/provider.dart';

class MobileListPage extends StatelessWidget {
  const MobileListPage({super.key});

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
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                toolbarHeight: 80,
                title: Text(
                    'To-do - ${homeVM.selectedFolder}'), // Update the app bar title
                actions: [
                  Row(children: [
                    const ToggleButton(),
                    const SizedBox(width: 5),
                    CustomElevatedButton(
                      hei: 115,
                      wid: 40,
                      textSize: 12,
                      onPressed: () => goodleVM.signOut().then((_) {
                      homeVM.loadData(context);
                    }),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 12),
                          Text("Log out",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
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
                              'lib/picture/shiba_wallpaper.jpg'), // 使用AssetImage提供图片
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
                              const SizedBox(width: 50),
                              Expanded(
                                child: mobileBuildTableCell('Name'),
                              ),
                              Expanded(
                                child: mobileBuildTableCell('Date'),
                              ),
                              Expanded(
                                child: mobileBuildTableCell('Note'),
                              ),
                              const SizedBox(
                                  width: 75), // Save place for deletion button
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
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                      homeVM.todoItemList[i].name,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                      homeVM.todoItemList[i].date,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                      homeVM.todoItemList[i].note,
                                    ),
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
                          for (int i = 0;
                              i < homeVM.todoItemList.length;
                              i++) // Events
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
                                          fontSize: 12,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      homeVM.todoItemList[i].date,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      homeVM.todoItemList[i].note,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontWeight: FontWeight.w600),
                                    ),
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
              floatingActionButton: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black
                      .withOpacity(0.6), // 調整透明度的值在這裡，0.0 表示完全透明，1.0 表示完全不透明
                  BlendMode.dstIn, // 調整混合模式以達到您想要的效果
                ),
                child: Image.asset(
                  'lib/picture/shiba_icon.png',
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
            ));
  }
}
