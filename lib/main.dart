import 'package:flutter/material.dart';

import 'package:morvita_app/show_nav_bar.dart';
import 'package:morvita_app/login_signup/login_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String status_login = "";

  @override
  void initState() {
    super.initState();
    show_sh();
  }

  Future<void> show_sh() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        status_login = prefs.getString('status_login')!;
      });
    } catch (e) {
      print("ERROR_show_sh : $e");
    }
    print("status = $status_login");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: (status_login == "") ? const Login_form() : const Show_nav_bar(),
      debugShowCheckedModeBanner: false,
    );
  }
}

