import 'package:client/pages/contacts/contacts_details_page.dart';
import 'package:client/tools/utils.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/contacts/group_launch_page.dart';

import 'package:client/tools/library.dart';

class ChatMamBer extends StatefulWidget {
  final dynamic model;

  ChatMamBer({this.model});

  @override
  _ChatMamBerState createState() => _ChatMamBerState();
}

class _ChatMamBerState extends State<ChatMamBer> {
  @override
  Widget build(BuildContext context) {
    String face =
        PlatformUtils.isIOS ? widget.model?.faceURL : widget.model?.faceUrl;
    String name =
        PlatformUtils.isIOS ? widget.model?.nickname : widget.model?.nickName;

    List<Widget> wrap = [];

    wrap.add(
      new Wrap(
        spacing: (winWidth(context) - 315) / 5,
        runSpacing: 10.0,
        children: [0].map((item) {
          return new InkWell(
            child: new Container(
              width: 55.0,
              child: new Column(
                children: <Widget>[
                  new ImageView(
                    img: strNoEmpty(face) ? face : defIcon,
                    width: 55.0,
                    height: 55.0,
                    fit: BoxFit.cover,
                  ),
                  new Space(height: mainSpace / 2),
                  new Text(
                    strNoEmpty(name) ? name : '无名氏',
                    style: TextStyle(color: mainTextColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            onTap: () => routePush(new ContactsDetailsPage(
              id: widget.model.id,
              title: name,
              avatar: face,
              gender: 1,
            )),
          );
        }).toList(),
      ),
    );

    wrap.add(
      new InkWell(
        child: new Container(
          decoration:
              BoxDecoration(border: Border.all(color: lineColor, width: 0.2)),
          child: new Image.asset('assets/images/chat/ic_details_add.png',
              width: 55.0, height: 55.0, fit: BoxFit.cover),
        ),
        onTap: () => routePush(new GroupLaunchPage()),
      ),
    );

    return Container(
      color: Colors.white,
      width: winWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: new Wrap(
        spacing: (winWidth(context) - 315) / 5,
        runSpacing: 10.0,
        children: wrap,
      ),
    );
  }
}
