import 'dart:convert';

import 'package:client/pages/WidgetsBinding.dart';
import 'package:client/pages/chat/chat_more_page.dart';
import 'package:client/pages/group/group_details_page.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/tools/utils.dart';
import 'package:client/ui/chat/chat_details_body.dart';
import 'package:client/ui/chat/chat_details_row.dart';
import 'package:client/ui/item/chat_more_icon.dart';
import 'package:client/ui/view/indicator_page_view.dart';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:client/tools/library.dart';
import 'package:client/ui/edit/text_span_builder.dart';
import 'package:client/ui/edit/emoji_text.dart';
import 'chat_info_page.dart';

final _log = Logger("ChatPage");

enum ButtonType { voice, more }

class ChatPage extends StatefulWidget {
  final String title;
  final int type;
  final String id;

  ChatPage({required this.id, required this.title, this.type = 1});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMsg> chatData = [];
  late StreamSubscription<List<ChatMsg>> _msgStreamSubs;
  bool _isVoice = false;
  bool _isMore = false;
  double keyboardHeight = 270.0;
  bool _emojiState = false;
  String? newGroupName;

  TextEditingController _textController = TextEditingController();
  FocusNode _focusNode = new FocusNode();
  ScrollController _sC = ScrollController();
  PageController pageC = new PageController();
  Stream? _route;

  late StreamSubscription<int?> _popSub;
  int chatPopSum = 0;
  late ChatUser peer;
  StreamSubscription<bool>? _subAppBackground;
  @override
  void initState() {
    super.initState();
    getChatMsgData();
    readedMsg();
    _subAppBackground =
        WidgetsBind.watchAppEnterBackground().listen((isBackgroup) {
      if (!isBackgroup) {
        readedMsg();
      }
    });
    _sC.addListener(() => FocusScope.of(context).requestFocus(new FocusNode()));
    // Notice.addListener(UcActions.msg(), (v) => getChatMsgData());
    if (widget.type == typeGroup) {
      Notice.addListener(UcActions.groupName(), (v) {
        setState(() => newGroupName = v);
      });
    }
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _emojiState = false;
    });
  }

  Future getChatMsgData() async {
    _msgStreamSubs =
        ImData.get().getChatList(widget.id, widget.type, 0).listen((event) {
      chatData = event;
      if (chatData.length > 0) {
        var msg = chatData[0];
        var msgStr = jsonEncode(msg);
        _log.info("last msg: $msgStr");
      }
      if (mounted) setState(() {});
    });
    if (widget.type == typePerson) {
      var res = await ImData.get().getChatUsers([widget.id]);
      peer = res[widget.id]!;
    } else {
      peer = ImData.defaultUser(widget.id);
    }
    _popSub = ImDb.g().db.popsDao.queryChatPopSum().listen((event) {
      // _log.info("imdb update pop: $event");
      chatPopSum = event ?? 0;
      if (mounted) setState(() {});
    });
    if (mounted) setState(() {});
  }

  void readedMsg() {
    ImData.get().readMsg(widget.id, Utils.getTimestampSecond(), widget.type);
  }

  void insertText(String text) {
    var value = _textController.value;
    var start = value.selection.baseOffset;
    var end = value.selection.extentOffset;
    if (value.selection.isValid) {
      String newText = '';
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end);
        }
        newText += text;
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.replaceRange(start, end, text);
        end = start;
      }

      _textController.value = value.copyWith(
          text: newText,
          selection: value.selection.copyWith(
              baseOffset: end + text.length, extentOffset: end + text.length));
    } else {
      _textController.value = TextEditingValue(
          text: text,
          selection:
              TextSelection.fromPosition(TextPosition(offset: text.length)));
    }
  }

  void canCelListener() {
    _msgStreamSubs.cancel();
    _popSub.cancel();
    _subAppBackground?.cancel();
  }

  _handleSubmittedData(String text) async {
    _textController.clear();

    var msg = Im.newMsg(widget.type, msgTypeText, widget.id, content: text);
    Im.get().sendChatMsg(msg);
  }

  onTapHandle(ButtonType type) {
    setState(() {
      if (type == ButtonType.voice) {
        _focusNode.unfocus();
        _isMore = false;
        _isVoice = !_isVoice;
      } else {
        _isVoice = false;
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
          _isMore = true;
        } else {
          _isMore = !_isMore;
        }
      }
      _emojiState = false;
    });
  }

  Widget edit(context, size) {
    // 计算当前的文本需要占用的行数
    TextSpan _text =
        TextSpan(text: _textController.text, style: AppStyles.ChatBoxTextStyle);

    TextPainter _tp = TextPainter(
        text: _text,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left);
    _tp.layout(maxWidth: size.maxWidth);
    ScrollController scrollController = ScrollController();
    return ExtendedTextField(
      scrollController: scrollController,
      specialTextSpanBuilder: TextSpanBuilder(showAtBackground: true),
      onTap: () => setState(() {
        if (_focusNode.hasFocus) _emojiState = false;
      }),
      onChanged: (v) {
        // _log.info("onChanged: $v");
        Future.delayed(Duration(milliseconds: 100), () {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
        // setState(() {});
      },
      // onChanged: (v) => setState(() {}),
      decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 12)),
      controller: _textController,
      focusNode: _focusNode,
      maxLines: 99,
      cursorColor: const Color(AppColors.ChatBoxCursorColor),
      style: AppStyles.ChatBoxTextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (keyboardHeight == 270.0 &&
        MediaQuery.of(context).viewInsets.bottom != 0) {
      keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    }
    var body = [
      chatData.length > 0
          ? new ChatDetailsBody(
              sC: _sC,
              chatData: chatData,
              user: peer,
            )
          : new Spacer(),
      new ChatDetailsRow(
        showEmoji: _emojiState,
        showMore: _isMore,
        voiceOnTap: () => onTapHandle(ButtonType.voice),
        onEmojio: () {
          if (_isMore) {
            _emojiState = true;
          } else {
            _emojiState = !_emojiState;
          }
          if (_emojiState) {
            FocusScope.of(context).requestFocus(new FocusNode());
            _isMore = false;
          }
          setState(() {});
        },
        isVoice: _isVoice,
        edit: edit,
        more: new ChatMoreIcon(
          value: _textController.text,
          onTap: () => _handleSubmittedData(_textController.text),
          moreTap: () => onTapHandle(ButtonType.more),
        ),
        id: widget.id,
        type: widget.type,
      ),
      new Visibility(
        visible: _emojiState,
        child: emojiWidget(),
      ),
      new Container(
        height: _isMore && !_focusNode.hasFocus ? keyboardHeight : 0.0,
        width: winWidth(context),
        color: Color(AppColors.ChatBoxBg),
        child: new IndicatorPageView(
          pageC: pageC,
          pages: List.generate(2, (index) {
            return new ChatMorePage(
              index: index,
              id: widget.id,
              type: widget.type,
              keyboardHeight: keyboardHeight,
            );
          }),
        ),
      ),
    ];

    var rWidget = [
      new InkWell(
        child: new Image.asset('assets/images/right_more.png'),
        onTap: () => routePush(widget.type == typeGroup
            ? new GroupDetailsPage(
                widget.id,
                callBack: (v) {},
              )
            : new ChatInfoPage(widget.id)),
      )
    ];

    return Scaffold(
      appBar: new ComMomBar(
        title: newGroupName ?? widget.title,
        rightDMActions: rWidget,
        unread: chatPopSum,
      ),
      body: new MainInputBody(
        onTap: () => setState(
          () {
            _isMore = false;
            _emojiState = false;
          },
        ),
        decoration: BoxDecoration(color: chatBg),
        child: new Column(children: body),
      ),
    );
  }

  Widget emojiWidget() {
    return new GestureDetector(
      child: new SizedBox(
        height: _emojiState ? keyboardHeight : 0,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              child:
                  Image.asset(EmojiUitl.instance.emojiMap["[${index + 1}]"]!),
              behavior: HitTestBehavior.translucent,
              onTap: () {
                insertText("[${index + 1}]");
              },
            );
          },
          itemCount: EmojiUitl.instance.emojiMap.length,
          padding: EdgeInsets.all(5.0),
        ),
      ),
      onTap: () {},
    );
  }

  @override
  void dispose() {
    super.dispose();
    readedMsg();
    canCelListener();
    // Notice.removeListenerByEvent(UcActions.msg());
    // Notice.removeListenerByEvent(UcActions.newMsg());
    Notice.removeListenerByEvent(UcActions.chatRead());
    Notice.removeListenerByEvent(UcActions.groupName());
    _sC.dispose();
  }
}
