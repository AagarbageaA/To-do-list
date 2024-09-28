import 'package:flutter/material.dart';
import 'package:flutter_application_template/model/user.dart';
import 'package:flutter_application_template/view_model/google.dart';
import 'package:flutter_application_template/view_model/data_view_model.dart';
import 'package:flutter_application_template/widget/elevated_button.dart';
import 'package:flutter_application_template/widget/toggle.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MobileCalendarPage extends StatefulWidget {
  const MobileCalendarPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<MobileCalendarPage> {
  final CalendarWeekController _controller = CalendarWeekController();
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Perform initial setState to ensure events are displayed
    context.read<DataViewModel>().loadData(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataViewModel>(
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
                    'lib/picture/appbar_shiba.png',
                    width: 50, // 調整圖片的大小
                    height: 50,
                  ),
                  const Text(
                    'To-do List',
                    style: TextStyle(fontSize: 15),
                  )
                ]),
                actions: [
                  Row(children: [
                    const ToggleButton(),
                    const SizedBox(width: 20),
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
                      Container(width: 0.5,height: double.infinity,color: Colors.black,),
                      Expanded(
                        child: calendarBlock(2),
                      ),
                      Container(width: 0.5,height: double.infinity,color: Colors.black,),
                      Expanded(
                        child: calendarBlock(3),
                      ),
                      Container(width: 0.5,height: double.infinity,color: Colors.black,),
                      Expanded(
                        child: calendarBlock(4),
                      ),
                      Container(width: 0.5,height: double.infinity,color: Colors.black,),
                      Expanded(
                        child: calendarBlock(5),
                      ),
                      Container(width: 0.5,height: double.infinity,color: Colors.black,),
                      Expanded(
                        child: calendarBlock(6),
                      ),
                      Container(width: 0.5,height: double.infinity,color: Colors.black,),
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
      padding: EdgeInsets.zero, // 移除 ListView 的 padding
      children: context
          .watch<DataViewModel>()
          .todoItemList
          .where((todo) =>
              _isTodoForCurrentWeek(todo) &&
              DateTime.parse(todo.date).weekday == day)
          .map((todo) => ListTile(
                title: Text(todo.name,
                    style: TextStyle(
                        decoration: todo.ischecked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontSize: 8)),
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
