import 'package:client/config/dictionary.dart';
import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/ui/item/contact_view.dart';
import 'package:flutter/material.dart';
import 'package:client/tools/library.dart';
import 'package:client/ui/item/contact_item.dart';

class ContactsPage extends StatefulWidget {
  _ContactsPageState createState() => _ContactsPageState();
}

final _log = Logger("ContactsPage");

class _ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin {
  var indexBarBg = Colors.transparent;
  var currentLetter = '';
  var isNull = false;

  ScrollController? sC;
  List<Friend> _contacts = [];

  List<ContactItem> _functionButtons = [
    new ContactItem(
        avatar: contactAssets + 'ic_new_friend.webp', title: '新的朋友'),
    new ContactItem(avatar: contactAssets + 'ic_group.webp', title: '群聊'),
    new ContactItem(avatar: contactAssets + 'ic_tag.webp', title: '标签'),
    new ContactItem(avatar: contactAssets + 'ic_no_public.webp', title: '公众号'),
  ];
  final Map _letterPosMap = {INDEX_BAR_WORDS[0]: 0.0};

  late StreamSubscription<List<Friend>> _sub;
  Future getContacts() async {
    _sub = ImData.get().friendList().listen((event) {
      _contacts.clear();
      _contacts..addAll(event);
      _contacts.sort((a, b) => a.nameIndex.compareTo(b.nameIndex));
      isNull = !listNoEmpty(event);

      /// 计算用于 IndexBar 进行定位的关键通讯录列表项的位置
      var _totalPos = ContactItemState.heightItem(false);
      for (int i = 0; i < _contacts.length; i++) {
        bool _hasGroupTitle = true;
        if (i > 0 &&
            _contacts[i].nameIndex.compareTo(_contacts[i - 1].nameIndex) == 0)
          _hasGroupTitle = false;

        if (_hasGroupTitle) _letterPosMap[_contacts[i].nameIndex] = _totalPos;

        _totalPos += ContactItemState.heightItem(_hasGroupTitle);
      }
      if (mounted) setState(() {});
    });

    sC = new ScrollController();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    if (sC != null) sC?.dispose();
    canCelListener();
  }

  String _getLetter(BuildContext context, double tileHeight, Offset globalPos) {
    RenderBox _box = context.findRenderObject() as RenderBox;
    var local = _box.globalToLocal(globalPos);
    int index = (local.dy ~/ tileHeight).clamp(0, INDEX_BAR_WORDS.length - 1);
    return INDEX_BAR_WORDS[index];
  }

  void _jumpToIndex(String letter) {
    if (_letterPosMap.isNotEmpty) {
      final _pos = _letterPosMap[letter];
      if (_pos != null)
        sC?.animateTo(_pos,
            curve: Curves.easeOut, duration: Duration(milliseconds: 200));
    }
  }

  Widget _buildIndexBar(BuildContext context, BoxConstraints constraints) {
    final List<Widget> _letters = INDEX_BAR_WORDS
        .map((String word) =>
            new Expanded(child: new Text(word, style: TextStyle(fontSize: 12))))
        .toList();

    final double _totalHeight = constraints.biggest.height;
    final double _tileHeight = _totalHeight / _letters.length;

    void jumpTo(details) {
      indexBarBg = Colors.black26;
      currentLetter = _getLetter(context, _tileHeight, details.globalPosition);
      _jumpToIndex(currentLetter);
      setState(() {});
    }

    void transparentMethod() {
      indexBarBg = Colors.transparent;
      currentLetter = "";
      setState(() {});
    }

    return new GestureDetector(
      onVerticalDragDown: (DragDownDetails details) => jumpTo(details),
      onVerticalDragEnd: (DragEndDetails details) => transparentMethod(),
      onVerticalDragUpdate: (DragUpdateDetails details) => jumpTo(details),
      child: new Column(children: _letters),
    );
  }

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  void canCelListener() {
    _sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List<Widget> body = [
      new ContactView(
          sC: sC, functionButtons: _functionButtons, contacts: _contacts),
      new Positioned(
        width: Constants.IndexBarWidth,
        right: 0.0,
        top: 120.0,
        bottom: 120.0,
        child: new Container(
          color: indexBarBg,
          child: new LayoutBuilder(builder: _buildIndexBar),
        ),
      ),
    ];

    if (isNull) body.add(new HomeNullView(str: '无联系人'));

    if (currentLetter != null && currentLetter.isNotEmpty) {
      var row = [
        new Container(
            width: Constants.IndexLetterBoxSize,
            height: Constants.IndexLetterBoxSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.IndexLetterBoxBg,
              borderRadius: BorderRadius.all(
                  Radius.circular(Constants.IndexLetterBoxSize / 2)),
            ),
            child: new Text(currentLetter,
                style: AppStyles.IndexLetterBoxTextStyle)),
        new Icon(Icons.arrow_right),
        new Space(width: mainSpace * 5),
      ];
      body.add(
        new Container(
          width: winWidth(context),
          height: winHeight(context),
          child:
              new Row(mainAxisAlignment: MainAxisAlignment.end, children: row),
        ),
      );
    }
    return new Scaffold(body: new Stack(children: body));
  }
}
