import 'package:flutter/material.dart';
import 'package:flutter_login_ui/home.dart';
import 'package:flutter_login_ui/login.dart';
import 'package:flutter_login_ui/pageView.dart';

import 'ReportScreen.dart';

void main() => runApp(MyMain());

class MyMain extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Paycheck',
      initialRoute: '/',
      routes: {
        '/': (context) => ReportScreen(),

      },
    );
  }
  
}