import 'package:flutter/material.dart';
import 'package:flutter_application_template/model/user.dart';
import 'package:flutter_application_template/view/add_event_page.dart';
import 'package:flutter_application_template/view_model/google.dart';
import 'package:flutter_application_template/view_model/homepage_view_model.dart';
import 'package:flutter_application_template/widget/elevated_button.dart';
import 'package:flutter_application_template/widget/toggle.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarWeekController _controller = CalendarWeekController();
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Perform initial setState to ensure events are displayed
    context.read<HomePageViewModel>().loadData(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageViewModel>(
        builder: (context, homeVM, child) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false, // 隱藏自動添加的返回按鈕
                iconTheme: const IconThemeData(
                    color: Color.fromRGBO(255, 255, 255, 1)),
                backgroundColor: const Color.fromARGB(255, 7, 34, 45),
                titleTextStyle: const TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 30,
                ),
                toolbarHeight: 80,
                title: Row(children: [
                  Image.asset(
                    'appbar_shiba.png',
                    width: 100, // 調整圖片的大小
                    height: 100,
                  ),
                  const Text('To-do List')
                ]),
                actions: [
                  Row(children: [
                    const ToggleButton(),
                    const SizedBox(width: 20),
                    Text(
                      "Login with ${context.read<GoogleViewModel>().user?.displayName}  ",
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 14,
                      ),
                    ),
                    CustomElevatedButton(
                      hei: 120,
                      wid: 40,
                      textSize: 15,
                      onPressed: () =>
                          context.read<GoogleViewModel>().signOut(),
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
              body: Column(children: [
                Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(240, 7, 25, 60),
                          blurRadius: 6,
                          spreadRadius: 1)
                    ]),
                    child: CalendarWeek(
                      controller: _controller,
                      height: 130,
                      dayOfWeekStyle: const TextStyle(
                          color: Color.fromARGB(240, 7, 25, 60)),
                      dateStyle: const TextStyle(
                          color: Color.fromARGB(240, 7, 25, 60)),
                      todayDateStyle: const TextStyle(
                          color: Color.fromARGB(210, 11, 43, 199)),
                      weekendsStyle: const TextStyle(
                          color: Color.fromARGB(237, 22, 167, 196)),
                      showMonth: true,
                      minDate: DateTime.now().add(
                        Duration(days: -now.weekday + 1 - 364),
                      ),
                      maxDate: DateTime.now().add(
                        const Duration(days: 365),
                      ),
                      onWeekChanged: () {
                        setState(() {});
                      },
                      monthViewBuilder: (DateTime time) => Align(
                        alignment: FractionalOffset.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 日曆圖示
                            IconButton(
                              icon: const Icon(Icons.calendar_month,
                                  color: Color.fromARGB(179, 14, 57, 93)),
                              color:
                                  const Color.fromARGB(255, 7, 35, 58), // 圖示顏色
                              onPressed: () async {
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );

                                // 如果選擇了日期，則執行滾動至當周的操作
                                if (pickedDate != null) {
                                  // 將視圖滾動到選擇的日期所在的周
                                  _controller.jumpToDate(pickedDate);

                                  // 重新繪製視圖
                                  setState(() {});
                                }
                              },
                            ),
                            // 顯示月份的文字
                            Text(
                              DateFormat.yMMMM()
                                  .format(time), // 使用日期格式化來顯示時間的月份
                              overflow: TextOverflow.ellipsis, // 文字過長時的處理方式
                              textAlign: TextAlign.center, // 文字對齊方式
                              style: const TextStyle(
                                color: Color.fromARGB(255, 7, 35, 58), // 文字顏色
                                fontWeight: FontWeight.w600, // 文字粗細
                              ),
                            ),
                          ],
                        ),
                      ),
                      decorations: [
                        DecorationItem(
                            decorationAlignment: FractionalOffset.bottomRight,
                            date: DateTime.now(),
                            decoration: const Icon(
                              Icons.today,
                              color: Color.fromARGB(255, 9, 38, 63),
                            )),
                      ],
                    )),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: calendarBlock(1),
                      ),
                      const VerticalDivider(
                          thickness: 0.5,
                          color: Color.fromARGB(164, 9, 38, 63),
                          indent: 5),
                      Expanded(
                        child: calendarBlock(2),
                      ),
                      const VerticalDivider(
                          thickness: 0.5,
                          color: Color.fromARGB(164, 9, 38, 63),
                          indent: 5),
                      Expanded(
                        child: calendarBlock(3),
                      ),
                      const VerticalDivider(
                          thickness: 0.5,
                          color: Color.fromARGB(164, 9, 38, 63),
                          indent: 5),
                      Expanded(
                        child: calendarBlock(4),
                      ),
                      const VerticalDivider(
                          thickness: 0.5,
                          color: Color.fromARGB(164, 9, 38, 63),
                          indent: 5),
                      Expanded(
                        child: calendarBlock(5),
                      ),
                      const VerticalDivider(
                          thickness: 0.5,
                          color: Color.fromARGB(164, 9, 38, 63),
                          indent: 5),
                      Expanded(
                        child: calendarBlock(6),
                      ),
                      const VerticalDivider(
                          thickness: 0.5,
                          color: Color.fromARGB(164, 9, 38, 63),
                          indent: 5),
                      Expanded(
                        child: calendarBlock(7),
                      ),
                    ],
                  ),
                )
              ]),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                                .read<HomePageViewModel>()
                                .addFolder(folderName, context),
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.add,
                        color: Color.fromARGB(255, 7, 34, 45)),
                  ),
                  const SizedBox(height: 16),
                  FloatingActionButton(
                    heroTag: "btn2",
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    splashColor: const Color.fromARGB(255, 7, 34, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Color.fromARGB(139, 7, 34, 45),
                        width: 4,
                        // strokeAlign: -1, // Not needed
                      ),
                    ),
                    onPressed: () {
                      _controller.jumpToDate(DateTime.now());
                      setState(() {});
                    },
                    child: const Icon(Icons.today),
                  ),
                ],
              ),
            ));
  }

  Widget calendarBlock(int day) {
    return ListView(
      children: context
          .watch<HomePageViewModel>()
          .todoItemList
          .where((todo) =>
              _isTodoForCurrentWeek(todo) &&
              DateTime.parse(todo.date).weekday ==
                  day) // Filter todo items for Thursday
          .map((todo) => ListTile(
              title: Text(
                  "- Name: ${todo.name}",
                  style: TextStyle(
                    decoration: todo.ischecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  )),
              subtitle: Text(
                  "   Note: ${todo.note}",
                  style: TextStyle(
                    decoration: todo.ischecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ))
              // Other properties of todo item
              ))
          .toList(),
    );
  }

  bool _isTodoForCurrentWeek(TodoItem todo) {
    if (_controller.rangeWeekDate.isEmpty) return false;

    final firstDayOfCurrentWeek = _controller.rangeWeekDate.first;
    final lastDayOfCurrentWeek = _controller.rangeWeekDate.last;

    // Convert todo.date from String to DateTime
    final todoDate = DateTime.parse(todo.date);

    // Check if the todo's date falls within the current week
    return firstDayOfCurrentWeek != null &&
        lastDayOfCurrentWeek != null &&
        todoDate
            .isAfter(firstDayOfCurrentWeek.subtract(const Duration(days: 1))) &&
        todoDate.isBefore(lastDayOfCurrentWeek);
  }
}
