import 'package:client/provider/model/msgEnum.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/tools/library.dart';
import 'package:client/ui/edit/text_span_builder.dart';
import 'package:client/ui/w_pop/magic_pop.dart';

class TextItemContainer2 extends StatelessWidget {
  final String text;
  final String action;
  final String timeStr;
  final int status;
  final bool isMyself;

  TextItemContainer2(
      {required this.text,
      required this.action,
      this.isMyself = true,
      required this.timeStr,
      required this.status});

  TextSpanBuilder _spanBuilder = TextSpanBuilder();
  TextStyle _tips = TextStyle(color: Colors.grey, fontSize: 10);
  @override
  Widget build(BuildContext context) {
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
                MagicPop(
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
                    text == "" ? '文字为空' : text + "          ".joinChar(),
                    maxLines: 99,
                    overflow: TextOverflow.visible,
                    specialTextSpanBuilder: _spanBuilder,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
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
