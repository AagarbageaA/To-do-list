import 'package:flutter/material.dart';
import 'package:flutter_application_template/view_model/google.dart';
import 'package:flutter_application_template/view_model/homepage_view_model.dart';
import 'package:flutter_application_template/widget/elevated_button.dart';
import 'package:provider/provider.dart';

class MobileNotLoginPage extends StatelessWidget {
  const MobileNotLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<GoogleViewModel, HomePageViewModel>(
        builder: (context, goodleVM, homeVM, child) => Scaffold(
            appBar: AppBar(
                title: const Text('To-do List '),
                titleTextStyle: const TextStyle(
                  color: Color.fromARGB(255, 202, 227, 236),
                  fontSize: 60,
                ),
                toolbarHeight: 100,
                centerTitle: true,
                backgroundColor: const Color.fromARGB(225, 7, 34, 45)),
            body: Stack(
              children: [
                //background picture
                Image.asset(
                  'lib/picture/shiba_wallpaper.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),

                //login botton position
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.25,
                  left: MediaQuery.of(context).size.width * 0.45,
                  child: CustomElevatedButton(
                    hei: 110,
                    wid: 40,
                    textSize: 12,
                    onPressed: () => goodleVM.signInWithGoogle().then((_) {
                      homeVM.loadData(context);
                    }),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login),
                        SizedBox(width: 2),
                        Text("Log in",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
