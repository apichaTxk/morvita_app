import 'package:flutter/material.dart';

class ReadMoreText extends StatefulWidget {
  final String text;

  ReadMoreText({Key? key, required this.text}) : super(key: key);

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  @override
  Widget build(BuildContext context) {
    TextSpan span = TextSpan(text: widget.text);
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: MediaQuery.of(context).size.width);

    if (tp.didExceedMaxLines) { // if text has more than 2 lines
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          TextButton(
            child: Text('อ่านต่อ', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(widget.text),
                    actions: <Widget>[
                      TextButton(
                        child: Text('ปิด'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      );
    } else {
      return Text(widget.text);
    }
  }
}