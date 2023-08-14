import 'package:flutter/material.dart';

import 'package:morvita_app/navigation_menu/activity_board/activity_all_list.dart';
import 'package:morvita_app/navigation_menu/discovery_insect/discovery_my_list.dart';
import 'package:morvita_app/navigation_menu/feed_board/feed_all_list.dart';
import 'package:morvita_app/navigation_menu/library_insect/library_all_list.dart';
import 'package:morvita_app/navigation_menu/library_insect/library_select.dart';

import 'package:morvita_app/navigation_menu/map_insect/map_show.dart';
import 'package:morvita_app/navigation_menu/map_insect/map_multilocation.dart';
import 'package:morvita_app/navigation_menu/map_insect/map_multilocation_api.dart';
import 'package:morvita_app/navigation_menu/map_insect/map_appbar.dart';
import 'package:morvita_app/navigation_menu/profile_user/profile_front.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Show_nav_bar extends StatefulWidget {
  const Show_nav_bar({Key? key}) : super(key: key);

  @override
  State<Show_nav_bar> createState() => _Show_nav_barState();
}

class _Show_nav_barState extends State<Show_nav_bar> {

  int index = 0;
  double icon_size = 30;
  Color color_pre = Colors.black54;

  final screen = [
    Map_appbar(),
    Library_select(status_lib: 1, band_show: true,),
    Feed_all_list(),
    Activity_all_list(),
    Profile_front(),
  ];

  String userImage = "";

  show_sh() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      userImage = prefs.getString('u_pic')!;
    }catch(e){
      print("ERROR_show_sh : $e");
    }
    setState(() {});
  }

  @override
  void initState() {
    show_sh();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              switch (index) {
                case 0:
                  return TextStyle(fontFamily: 'Prompt', fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF0A4483));
                case 1:
                  return TextStyle(fontFamily: 'Prompt', fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF0A4483));
                case 2:
                  return TextStyle(fontFamily: 'Prompt', fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF0A4483));
                case 3:
                  return TextStyle(fontFamily: 'Prompt', fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF0A4483));
                case 4:
                  return TextStyle(fontFamily: 'Prompt', fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF0A4483));
              }
            }
            return TextStyle(fontFamily: 'Prompt', fontSize: 14, fontWeight: FontWeight.w500, color: color_pre);
          }),
        ),
        child: NavigationBar(
          height: 60,
          backgroundColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          animationDuration: Duration(seconds: 1),

          selectedIndex: index,
          onDestinationSelected: (index) =>
              setState(() => this.index = index),

          destinations: [
            NavigationDestination(
              icon: Image.asset(
                'assets/map.png',
                width: icon_size,
                height: icon_size,
              ),
              selectedIcon: Image.asset(
                'assets/map.png',
                width: icon_size,
                height: icon_size,
              ),
              label: 'การค้นพบ',
            ),

            NavigationDestination(
              icon: Image.asset(
                'assets/library.png',
                width: icon_size,
                height: icon_size,
              ),
              selectedIcon: Image.asset(
                'assets/library.png',
                width: icon_size,
                height: icon_size,
              ),
              label: 'ห้องสมุด',
            ),

            NavigationDestination(
              icon: Image.asset(
                'assets/feed.png',
                width: icon_size,
                height: icon_size,
              ),
              selectedIcon: Image.asset(
                'assets/feed.png',
                width: icon_size,
                height: icon_size,
              ),
              label: 'หน้าฟีด',
            ),

            NavigationDestination(
              icon: Image.asset(
                'assets/activity.png',
                width: icon_size,
                height: icon_size,
              ),
              selectedIcon: Image.asset(
                'assets/activity.png',
                width: icon_size,
                height: icon_size,
              ),
              label: 'กิจกรรม',
            ),

            NavigationDestination(
              icon: CircleAvatar(
                backgroundImage: NetworkImage("https://morvita.cocopatch.com/$userImage"),
                radius: icon_size / 2,
              ),
              selectedIcon: CircleAvatar(
                backgroundImage: NetworkImage("https://morvita.cocopatch.com/$userImage"),
                radius: icon_size / 2,
              ),
              label: 'โปรไฟล์',
            ),
          ],
        ),
      ),
    );
  }
}
