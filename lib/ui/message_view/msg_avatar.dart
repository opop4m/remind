import 'dart:math';

import 'package:client/pages/contacts/contacts_details_page.dart';
import 'package:client/provider/global_cache.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:flutter/material.dart';

import 'package:client/tools/library.dart';
import 'package:client/ui/view/shake_view.dart';

///封装之后的拍一拍效果[ShakeView]
class MsgAvatar extends StatefulWidget {
  // final GlobalModel globalModel;
  final ChatMsg model;
  final ChatUser user;

  MsgAvatar({
    // required this.globalModel,
    required this.model,
    required this.user,
  });

  _MsgAvatarState createState() => _MsgAvatarState();
}

class _MsgAvatarState extends State<MsgAvatar> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  initState() {
    super.initState();
    start(true);
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    // print("didUpdateWidget:" + widget.user.toString());
    var isGroup = (widget.model.type == typeGroup);
    var isSelf = widget.model.fromId == Global.get().curUser.id;
    if (isGroup && !isSelf) {
      setState(() {});
    }
  }

  start(bool isInit) {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = TweenSequence<double>([
      //使用TweenSequence进行多组补间动画
      TweenSequenceItem<double>(tween: Tween(begin: 0, end: 10), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: 10, end: 0), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: -10, end: 0), weight: 1),
    ]).animate(controller);
    if (!isInit) controller.forward();
  }

  Widget build(BuildContext context) {
    var my = Global.get().curUser;
    var isGroup = (widget.model.type == typeGroup);
    Widget img = ImageView(
      img: widget.model.fromId == my.id
          ? getAvatarUrl(my.avatar)
          : getAvatarUrl(widget.user.avatar),
      height: 50,
      width: 50,
      fit: BoxFit.cover,
    );
    // if (isGroup && widget.model.fromId != my.id) {
    //   String? userAvatar;
    //   img = FutureBuilder(
    //       future: ImData.getUserInfo(widget.model.fromId, (data) {
    //         ChatUser user = data;
    //         userAvatar = user.avatar;
    //       }),
    //       builder: (ctx, snapshot) {
    //         return ImageView(
    //           img: getAvatarUrl(userAvatar),
    //           height: 50,
    //           width: 50,
    //           fit: BoxFit.cover,
    //         );
    //       });
    // }
    return new InkWell(
      child: AnimateWidget(
        animation: animation,
        child: new Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          margin: EdgeInsets.only(right: 10.0),
          child: img,
        ),
      ),
      onDoubleTap: () {
        setState(() => start(false));
      },
      onTap: () {
        routePush(new ContactsDetailsPage(
          title: widget.user.name,
          avatar: widget.user.avatar ?? defIcon,
          id: widget.user.id,
        ));
      },
    );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimateWidget extends AnimatedWidget {
  final Widget child;

  AnimateWidget({
    required Animation<double> animation,
    required this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    var result = Transform(
      transform: Matrix4.rotationZ(animation.value * pi / 180),
      alignment: Alignment.bottomCenter,
      child: new ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: child,
      ),
    );
    return result;
  }
}
