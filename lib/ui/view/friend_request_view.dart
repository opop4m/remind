import 'package:client/provider/model/msgEnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:client/tools/library.dart';

class FriendRequestItemView extends StatelessWidget {
  final BoxBorder? border;
  final Callback? onPressedA;
  final Callback? onPressedB;
  final String title;
  final String id;
  final String? label;
  final String icon;
  final double width;
  final double horizontal;
  final TextStyle titleStyle;
  final bool isLabel;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BoxFit? fit;
  final int status;

  FriendRequestItemView({
    required this.status,
    required this.id,
    this.border,
    this.onPressedA,
    this.onPressedB,
    required this.title,
    this.label,
    this.padding = const EdgeInsets.symmetric(vertical: 15.0),
    this.isLabel = true,
    this.icon = 'assets/images/favorite.webp',
    this.titleStyle =
        const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
    this.margin,
    this.fit,
    this.width = 45.0,
    this.horizontal = 10.0,
  });

  TextStyle ts = TextStyle(color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    var text = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(title, style: titleStyle),
        new Text(
          label ?? '',
          style: TextStyle(color: mainTextColor, fontSize: 12),
        ),
      ],
    );
    Widget btn;
    if (status == 0) {
      btn = Row(
        children: [
          TextButton(
            onPressed: () {
              onPressedA?.call(id);
            },
            child: Text("同意"),
          ),
          TextButton(
            onPressed: () {
              onPressedB?.call(id);
            },
            child: Text("拒绝"),
          ),
        ],
      );
    } else if (status == statusAgree) {
      btn = Text(
        "已添加",
        style: ts,
      );
    } else {
      btn = Text(
        "已拒绝",
        style: ts,
      );
    }
    var view = [
      isLabel ? text : new Text(title, style: titleStyle),
      new Spacer(),
      new Container(
        // width: 20,
        child: btn,
      ),
      new Space(),
    ];

    var row = new Row(
      children: <Widget>[
        new Container(
          width: width - 5,
          margin: EdgeInsets.symmetric(horizontal: horizontal),
          child: new ImageView(img: icon, width: width, fit: fit),
        ),
        new Container(
          width: winWidth(context) - 60,
          padding: padding,
          decoration: BoxDecoration(border: border),
          child: new Row(children: view),
        ),
      ],
    );

    return new Container(
      margin: margin,
      child: row,
    );
  }
}
