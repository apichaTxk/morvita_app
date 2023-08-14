import 'package:flutter/material.dart';
import 'package:morvita_app/navigation_menu/map_insect/drawer_in_map/drawer_component/profile_header.dart';

class Drawer_menu extends StatelessWidget {
  const Drawer_menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Profile_header(),
            ],
          ),
        ),
      ),
    );
  }
}
