import 'package:flutter/material.dart';
import 'package:flutter_application_template/view/success_login.dart';
import 'package:flutter_application_template/view/not_login_page.dart';
import 'package:flutter_application_template/view_model/google.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.watch<GoogleViewModel>().user == null) {
      return const NotLoginPage();
    } else {
      return const LoginSuccessPage();
    }
  }
}