import 'package:flutter/material.dart';

class Profile_header extends StatefulWidget {
  const Profile_header({Key? key}) : super(key: key);

  @override
  State<Profile_header> createState() => _Profile_headerState();
}

class _Profile_headerState extends State<Profile_header> {

  String img_test = "https://www.finearts.cmu.ac.th/wp-content/uploads/"
      "2021/07/blank-profile-picture-973460_1280-1.png";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[700],
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(img_test),
              ),
            ),
          ),
          Text(
            "Natthachai Tuangkrasin",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            "hamkung2543@mail.com",
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
