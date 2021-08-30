import 'dart:math';

import 'package:client/pages/contacts/contacts_details_page.dart';
import 'package:client/provider/global_model.dart';
import 'package:client/provider/model/chat_data.dart';
import 'package:flutter/material.dart';

import 'package:client/tools/wechat_flutter.dart';
import 'package:client/ui/view/shake_view.dart';

///封装之后的拍一拍效果[ShakeView]
class MsgAvatar extends StatefulWidget {
  final GlobalModel globalModel;
  final ChatData model;

  MsgAvatar({
    required this.globalModel,
    required this.model,
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
    return new InkWell(
      child: AnimateWidget(
        animation: animation,
        child: new Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          margin: EdgeInsets.only(right: 10.0),
          child: new ImageView(
            img: widget.model.id == widget.globalModel.user.account
                ? widget.globalModel.user.avatar ?? defIcon
                : widget.model.avatar!,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
      onDoubleTap: () {
        setState(() => start(false));
      },
      onTap: () {
        routePush(new ContactsDetailsPage(
          title: widget.model.nickName,
          avatar: widget.model.avatar!,
          id: widget.model.id,
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
