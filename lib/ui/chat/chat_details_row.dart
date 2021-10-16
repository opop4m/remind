import 'package:client/config/contacts.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/im.dart';
// import 'package:client/im/message_handle.dart';
import 'package:client/tools/library.dart';
import 'package:client/ui/item/chat_voice.dart';
import 'package:flutter/material.dart';

class ChatDetailsRow extends StatefulWidget {
  final GestureTapCallback? voiceOnTap;
  final bool isVoice;
  final LayoutWidgetBuilder? edit;
  final VoidCallback? onEmojio;
  final Widget? more;
  final String? id;
  final int type;
  final bool showMore, showEmoji;

  ChatDetailsRow({
    this.voiceOnTap,
    this.isVoice = false,
    this.edit,
    this.more,
    this.id,
    this.type = 0,
    this.onEmojio,
    this.showMore = false,
    this.showEmoji = false,
  });

  ChatDetailsRowState createState() => ChatDetailsRowState();
}

class ChatDetailsRowState extends State<ChatDetailsRow> {
  // String? path;

  @override
  void initState() {
    super.initState();

    // Notice.addListener(UcActions.voiceImg(), (v) {
    //   if (!v) return;
    //   if (!strNoEmpty(path)) return;
    //   sendSoundMessages(
    //     widget.id,
    //     path,
    //     2,
    //     widget.type,
    //     (value) => Notice.send(WeChatActions.msg(), v ?? ''),
    //   );
    // });
  }

  @override
  void didUpdateWidget(covariant ChatDetailsRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  double bottom = 10;

  @override
  Widget build(BuildContext context) {
    double _bottom = 0;
    if (!widget.showEmoji && !widget.showMore) {
      _bottom = bottom;
    }
    print("build bottom: $_bottom");
    return new GestureDetector(
      child: new Container(
        height: 50.0 + _bottom,
        // padding: EdgeInsets.symmetric(horizontal: 8.0),
        // margin: EdgeInsets.only(bottom: 18),
        padding: EdgeInsets.only(left: 8, right: 8, bottom: _bottom),
        decoration: BoxDecoration(
          color: Color(AppColors.ChatBoxBg),
          border: Border(
            top: BorderSide(color: lineColor, width: Constants.DividerWidth),
            bottom: BorderSide(color: lineColor, width: Constants.DividerWidth),
          ),
        ),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new InkWell(
              child: PlatformUtils.isWeb
                  ? SizedBox()
                  : Image.asset('assets/images/chat/ic_voice.webp',
                      width: 25, color: mainTextColor),
              onTap: () {
                if (widget.voiceOnTap != null) {
                  widget.voiceOnTap?.call();
                }
              },
            ),
            new Expanded(
              child: new Container(
                margin: const EdgeInsets.only(
                    top: 7.0, bottom: 7.0, left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                child: widget.isVoice
                    ? new ChatVoice(
                        voiceFile: (path, timeLen) {
                          setState(() => sendVoice(path, timeLen));
                        },
                      )
                    : new LayoutBuilder(builder: widget.edit!),
              ),
            ),
            new InkWell(
              child: new Image.asset('assets/images/chat/ic_Emotion.webp',
                  width: 30, fit: BoxFit.cover),
              onTap: () {
                widget.onEmojio?.call();
              },
            ),
            widget.more ?? SizedBox(),
          ],
        ),
      ),
      onTap: () {},
    );
  }

  void sendVoice(String path, int timeLen) {
    var msg = Im.newMsg(widget.type, msgTypeVoice, widget.id!,
        ext: path + "," + timeLen.toString());
    Im.get().sendChatMsg(msg);
  }
}
