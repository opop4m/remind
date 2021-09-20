import 'package:client/provider/model/chatList.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/ui/message_view/content_msg.dart';
import 'package:flutter/material.dart';
import 'package:client/tools/library.dart';
import 'package:badges/badges.dart';

class MyConversationView extends StatefulWidget {
  final String? imageUrl;
  final String? title;
  // final Map? content;
  final ChatRecent? msg;
  final Widget? time;
  final bool isBorder;
  final int unread;

  MyConversationView({
    this.imageUrl,
    this.title,
    this.msg,
    this.time,
    this.isBorder = true,
    this.unread = 0,
  });

  @override
  _MyConversationViewState createState() => _MyConversationViewState();
}

class _MyConversationViewState extends State<MyConversationView> {
  @override
  Widget build(BuildContext context) {
    var row = new Row(
      children: <Widget>[
        new Space(width: mainSpace),
        new Expanded(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                widget.title ?? '',
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.normal),
              ),
              new SizedBox(height: 2.0),
              new ContentMsg(widget.msg!),
            ],
          ),
        ),
        new Space(width: mainSpace),
        new Column(
          children: [
            widget.time ?? Container(),
            new Icon(Icons.flag, color: Colors.transparent),
          ],
        )
      ],
    );

    return new Container(
      padding: EdgeInsets.only(left: 18.0),
      color: Colors.white,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Badge(
            showBadge: widget.unread > 0,
            badgeContent:
                Text(widget.unread > 99 ? "99" : widget.unread.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    )),
            child: ImageView(
                img: widget.imageUrl ?? defIcon,
                height: 50.0,
                width: 50.0,
                fit: BoxFit.cover),
          ),
          new Container(
            padding: EdgeInsets.only(right: 18.0, top: 12.0, bottom: 12.0),
            width: winWidth(context) - 68,
            decoration: BoxDecoration(
              border: widget.isBorder
                  ? Border(
                      top: BorderSide(color: lineColor, width: 0.2),
                    )
                  : null,
            ),
            child: row,
          )
        ],
      ),
    );
  }
}
