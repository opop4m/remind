import 'package:client/pages/chat/videoCall2.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/ui/view/iconImageProvider.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/tools/library.dart';
import 'package:client/ui/edit/text_span_builder.dart';
import 'package:client/ui/w_pop/magic_pop.dart';

class TextItemContainer2 extends StatelessWidget {
  final String text;
  final bool isMyself;
  final ChatMsg msg;

  TextItemContainer2({
    required this.text,
    this.isMyself = true,
    required this.msg,
  });

  TextSpanBuilder _spanBuilder = TextSpanBuilder();
  TextStyle _tips = TextStyle(color: Colors.grey, fontSize: 10);
  TextStyle _contentTs = TextStyle(fontSize: 15);
  @override
  Widget build(BuildContext context) {
    String timeStr = Utils.formatTimeHM(msg.createTime);
    int status = msg.type == typeGroup || !isMyself ? -2 : msg.status ?? 0;
    Widget content;

    if (msg.msgType == msgTypeVideoCall || msg.msgType == msgTypeVoiceCall) {
      IconData id;
      status = -2;
      if (msg.msgType == msgTypeVideoCall) {
        id = Icons.video_call;
      } else {
        id = Icons.call_end;
      }
      String des;
      var arr = msg.ext!.split(",");
      int callTime = int.parse(arr[0]);
      int callStatus = int.parse(arr[1]);
      if (callStatus == callStatusInVideoCalling ||
          callStatus == callStatusInVoiceCalling) {
        des = "Duration:" + Utils.showMediaTime(callTime);
      } else {
        des = isMyself ? "Call Cancelled" : "Missed";
      }
      des += "   ".joinChar();
      content = Text.rich(TextSpan(
        children: [
          TextSpan(text: des, style: _contentTs),
          ImageSpan(
            IconImageProvider(id, color: Colors.blue),
            imageWidth: 20,
            imageHeight: 20,
          ),
          TextSpan(text: "          ".joinChar(), style: _contentTs),
        ],
      ));
    } else {
      content = MagicPop(
        onValueChanged: (int value) {
          switch (value) {
            case 0:
              Clipboard.setData(new ClipboardData(text: text));
              break;
            case 3:
              break;
          }
        },
        pressType: PressType.longPress,
        actions: ['复制', '转发', '收藏', '撤回', '删除'],
        child: ExtendedText(
          text +
              (isMyself ? "            ".joinChar() : "          ".joinChar()),
          maxLines: 99,
          overflow: TextOverflow.visible,
          specialTextSpanBuilder: _spanBuilder,
          style: _contentTs,
        ),
      );
    }

    return Expanded(
      flex: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isMyself ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            // width: text.length > 24 ? (winWidth(context) - 66) - 100 : null,
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            decoration: BoxDecoration(
              color: isMyself ? Color(0xff98E165) : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            margin: EdgeInsets.only(right: 7.0, top: 8),
            child: Stack(
              children: [
                content,
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          timeStr,
                          style: _tips,
                        ),
                        Space(width: 5),
                        status == -2
                            ? SizedBox()
                            : status > 1 && isMyself
                                ? (Icon(
                                    status == msgStateArrived
                                        ? Icons.done
                                        : Icons.done_all,
                                    color: Colors.grey,
                                    size: 10,
                                  ))
                                : Text(
                                    "..",
                                    style: _tips,
                                  ),
                      ],
                    ))
              ],
            ),
          ),
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   // mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [

          //     ,
          //   ],
          // ),
        ],
      ),
    );
  }
}
