import 'package:client/provider/model/msgEnum.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/tools/library.dart';
import 'package:client/ui/edit/text_span_builder.dart';
import 'package:client/ui/w_pop/magic_pop.dart';

class TextItemContainer extends StatefulWidget {
  final String text;
  final String action;
  final String timeStr;
  final int status;
  final bool isMyself;

  TextItemContainer(
      {required this.text,
      required this.action,
      this.isMyself = true,
      required this.timeStr,
      required this.status});

  @override
  _TextItemContainerState createState() => _TextItemContainerState();
}

class _TextItemContainerState extends State<TextItemContainer> {
  TextSpanBuilder _spanBuilder = TextSpanBuilder();

  TextStyle _tips = TextStyle(color: Colors.grey, fontSize: 10);

  @override
  Widget build(BuildContext context) {
    return new MagicPop(
      onValueChanged: (int value) {
        switch (value) {
          case 0:
            Clipboard.setData(new ClipboardData(text: widget.text));
            break;
          case 3:
            break;
        }
      },
      pressType: PressType.longPress,
      actions: ['复制', '转发', '收藏', '撤回', '删除'],
      child: new Container(
        width: widget.text.length > 24 ? (winWidth(context) - 66) - 100 : null,
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        decoration: BoxDecoration(
          color: widget.isMyself ? Color(0xff98E165) : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        margin: EdgeInsets.only(right: 7.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ExtendedText(
              widget.text == "" ? '文字为空' : widget.text,
              maxLines: 99,
              overflow: TextOverflow.ellipsis,
              specialTextSpanBuilder: _spanBuilder,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              widget.timeStr,
              style: _tips,
            ),
            widget.status == -2
                ? SizedBox()
                : widget.status > 1 && widget.isMyself
                    ? (Icon(
                        widget.status == msgStateArrived
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
        ),
      ),
    );
  }
}
