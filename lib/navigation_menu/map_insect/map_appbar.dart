import 'package:flutter/material.dart';
import 'package:morvita_app/navigation_menu/map_insect/inside_map_insect/create_ipoint.dart';
import 'map_multilocation_api.dart';
import 'package:morvita_app/navigation_menu/discovery_insect/discovery_search.dart';
import 'package:morvita_app/navigation_menu/discovery_insect/discovery_tabbar.dart';
import 'package:morvita_app/shared_pref.dart';

class Map_appbar extends StatefulWidget {
  const Map_appbar({Key? key}) : super(key: key);

  @override
  State<Map_appbar> createState() => _Map_appbarState();
}

class _Map_appbarState extends State<Map_appbar> {

  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            setState(() {
              tabIndex = tabController.index;
            });
          }
        });
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              'MorVita',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black26),
                tabs: [
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.transparent, width: 1)),
                      child: Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.map),
                            SizedBox(width: 5,),
                            Text('จุดที่พบแมลง', style: TextStyle(fontSize: 14, fontFamily: 'Prompt'),),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.transparent, width: 1)),
                      child: Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.list),
                            SizedBox(width: 5,),
                            Text('รายการแมลงที่พบ', style: TextStyle(fontSize: 14, fontFamily: 'Prompt'),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(45),
                ),
                gradient: LinearGradient(
                    colors: [Color(0xFF0A4483), Color(0xFF0A8367)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight
                ),
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(45),
              ),
            ),

            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiscoverySearch(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Map_list_api(),
              Discovery_tabbar(controll_appbar: 1,),
            ],
          ),
          floatingActionButton: Container(
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Create_ipoint(),
                  ),
                ).then((value) {
                  setState(() {});
                });
              },
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFF0A4483),
              splashColor: Colors.yellow,
              elevation: 0,
              icon: Icon(
                Icons.add,
                size: 25,
              ),
              label: Text(
                'ค้นพบแมลง',
                style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      }),
    );
  }
}
