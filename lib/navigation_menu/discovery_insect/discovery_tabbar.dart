import 'package:flutter/material.dart';

import 'package:morvita_app/navigation_menu/discovery_insect/discovery_my_list.dart';

class Discovery_tabbar extends StatefulWidget {
  final int controll_appbar;

  Discovery_tabbar({
    required this.controll_appbar,
  });

  @override
  State<Discovery_tabbar> createState() => _Discovery_tabbarState();
}

class _Discovery_tabbarState extends State<Discovery_tabbar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: widget.controll_appbar == 0 ? AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "เลือกแมลงที่ต้องการแชร์",
            style: TextStyle(
              fontFamily: 'prompt',
              fontWeight: FontWeight.w600,
              color: Colors.deepOrange,
            ),
          ),

          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black54,
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ) : PreferredSize(child: Container(), preferredSize: Size(0.0, 0.0)),
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
                    Discovery_my_list(discovery_filter: "ผีเสื้อ", statusToGo: widget.controll_appbar,),
                    Discovery_my_list(discovery_filter: "แมลงปอ", statusToGo: widget.controll_appbar,),
                    Discovery_my_list(discovery_filter: "แมลงปีกแข็ง", statusToGo: widget.controll_appbar,),
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
