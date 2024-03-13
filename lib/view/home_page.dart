import 'package:flutter/material.dart';
import 'package:flutter_application_template/enum/platform.dart';
import 'package:flutter_application_template/view/mobild_not_login_page.dart';
import 'package:flutter_application_template/view/mobile_list_page.dart';
import 'package:flutter_application_template/view/not_login_page.dart';
import 'package:flutter_application_template/view/list_page.dart';
import 'package:flutter_application_template/view_model/google.dart';
import 'package:flutter_application_template/view_model/homepage_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width >= Platform.computer.minWidth) {
      if (context.watch<GoogleViewModel>().user == null) {
        return const NotLoginPage();
      } else {
        context.read<HomePageViewModel>().loadData(context);
        return const ListPage();
      }
    } else {
      if (context.watch<GoogleViewModel>().user == null) {
        return const MobileNotLoginPage();
      } else {
        context.read<HomePageViewModel>().loadData(context);
        return const MobileListPage();
      }
    }
  }
}
