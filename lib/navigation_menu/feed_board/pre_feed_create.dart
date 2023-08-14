import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:morvita_app/connect_to_http.dart';
import 'package:http/http.dart' as Http;

import 'package:morvita_app/navigation_menu/feed_board/feed_create.dart';

class Pre_feed_create extends StatefulWidget {
  const Pre_feed_create({Key? key}) : super(key: key);

  @override
  State<Pre_feed_create> createState() => _Pre_feed_createState();
}

class _Pre_feed_createState extends State<Pre_feed_create> {

  late List insectPoint = [];
  String img_test = "https://www.finearts.cmu.ac.th/wp-content/uploads/"
      "2021/07/blank-profile-picture-973460_1280-1.png";

  @override
  void initState(){
    getIpList();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Insect Point'),
      ),
      body: ListView.builder(
        itemCount: insectPoint.length,
        itemBuilder: (BuildContext buildContext, int index){
          final ip = insectPoint[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(img_test),
            ),
            title: Text(ip['ip_name'].toString()),
            subtitle: Text('ID = ${ip['ip_id']}'),
            trailing: Wrap(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: (){
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => Feed_create.setText(
                    //       ip['u_id'],
                    //       ip['ip_id'],
                    //     ),
                    //   ),
                    // ).then((value) {
                    //   setState(() {});
                    // });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future getIpList() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/get_insectpoint.php");
    var response = await Http.get(url);
    print(response.body);
    insectPoint = json.decode(response.body);
    print(insectPoint);
    setState(() {});
  }
}
