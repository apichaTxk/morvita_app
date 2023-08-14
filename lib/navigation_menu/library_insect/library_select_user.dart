import 'package:flutter/material.dart';
import 'package:morvita_app/navigation_menu/library_insect/library_user_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:morvita_app/navigation_menu/library_insect/library_all_list.dart';
import 'package:morvita_app/navigation_menu/library_insect/insect_create.dart';
import 'package:morvita_app/navigation_menu/library_insect/insect_search.dart';
import 'package:morvita_app/navigation_menu/library_insect/library_select_user.dart';

class LibrarySelectUser extends StatefulWidget {
  const LibrarySelectUser({Key? key}) : super(key: key);

  @override
  State<LibrarySelectUser> createState() => _LibrarySelectUserState();
}

class _LibrarySelectUserState extends State<LibrarySelectUser> {

  String userID = "";

  final List<String> titles = [
    'ผีเสื้อ',
    'แมลงปอ',
    'แมลงปีกแข็ง',
  ];

  @override
  void initState() {
    super.initState();
    show_sh();
  }

  Future<void> show_sh() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userID = prefs.getString('u_id')!;
      });
    } catch (e) {
      print("ERROR_show_sh : $e");
    }
    print("user id = $userID");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'แมลงของคุณ',
            style: TextStyle(
              fontFamily: "Prompt",
              fontWeight: FontWeight.w600,
              color: Color(0xFF0A4483),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black54,
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Color(0xFF0A4483),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  tabs: [
                    tabbar_component("ผีเสื้อ"),
                    tabbar_component("แมลงปอ"),
                    tabbar_component("แมลงปีกแข็ง"),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    LibraryUserList(library_name: titles[0], userID: userID),
                    LibraryUserList(library_name: titles[1], userID: userID),
                    LibraryUserList(library_name: titles[2], userID: userID),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Tab tabbar_component(String textTab) {
    return Tab(
      child: Text(
        textTab,
        style: TextStyle(
          fontFamily: 'Prompt',
          fontSize: 16,
        ),
      ),
    );
  }
}
