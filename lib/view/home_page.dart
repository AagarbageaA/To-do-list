import 'package:flutter/material.dart';
import 'package:flutter_application_template/enum/platform.dart';
import 'package:flutter_application_template/view/mobild_not_login_page.dart';
import 'package:flutter_application_template/view/not_login_page.dart';
import 'package:flutter_application_template/view_model/google.dart';
import 'package:flutter_application_template/view_model/data_view_model.dart';
import 'package:provider/provider.dart';

import 'card_list.dart';
import 'mobile_card_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width >= Platform.computer.minWidth) {
      if (context.watch<GoogleViewModel>().user == null) {
        return const NotLoginPage();
      } else {
        context.watch<DataViewModel>().loadData(context);
        return const CardList();
      }
    } else {
      if (context.watch<GoogleViewModel>().user == null) {
        return const MobileNotLoginPage();
      } else {
        context.watch<DataViewModel>().loadData(context);
        return const MobileCardList();
      }
    }
  }
}
