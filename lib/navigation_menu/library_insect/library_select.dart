import 'package:flutter/material.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:morvita_app/navigation_menu/library_insect/library_all_list.dart';
import 'package:morvita_app/navigation_menu/library_insect/insect_create.dart';
import 'package:morvita_app/navigation_menu/library_insect/insect_search.dart';
import 'package:morvita_app/navigation_menu/library_insect/library_select_user.dart';

class Library_select extends StatefulWidget {
  final int status_lib;
  final bool band_show;

  Library_select({
    required this.status_lib,
    required this.band_show,
  });

  @override
  State<Library_select> createState() => _Library_selectState();
}

class _Library_selectState extends State<Library_select> {
  final List<String> titles = [
    'ผีเสื้อ',
    'แมลงปอ',
    'แมลงปีกแข็ง',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: AppBar(
            title: Text(
              "ห้องสมุดแมลง",
              style: TextStyle(
                  fontFamily: "Prompt",
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF0A4483), Color(0xFF0A8367)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight
                ),
              ),
            ),
            elevation: 5,
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InsectSearch(),
                    ),
                  );
                },
                icon: Icon(Icons.search, color: Colors.white,),
              ),
              if(widget.status_lib == 1)
                IconButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LibrarySelectUser(),
                      ),
                    );
                  },
                  icon: Icon(Icons.account_circle, color: Colors.white,),
                ),
            ],
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
                    Library_all_list(library_name: titles[0], band_show: widget.band_show,),
                    Library_all_list(library_name: titles[1], band_show: widget.band_show,),
                    Library_all_list(library_name: titles[2], band_show: widget.band_show,),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: (widget.status_lib == 1) ? true : false,
          child: Container(
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.bottomLeft,
            //     end: Alignment.topRight,
            //     colors: [Color(0xFF0A4483), Color(0xFF0A8367)],
            //   ),
            //   borderRadius: BorderRadius.all(Radius.circular(20)),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.blue.withOpacity(0.5),
            //       spreadRadius: 4,
            //       blurRadius: 10,
            //     ),
            //   ],
            // ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF0A4483).withOpacity(0.5),
                  spreadRadius: 4,
                  blurRadius: 10,
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Insect_create(),
                  ),
                ).then((value) {
                  setState(() {});
                });
              },
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFF0A4483),
              splashColor: Colors.white,
              elevation: 0,
              icon: Icon(Icons.add, size: 25,),
              label: Text('เพิ่มข้อมูลแมลง', style: TextStyle(fontFamily: 'Prompt', fontSize: 18, fontWeight: FontWeight.w600),),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
