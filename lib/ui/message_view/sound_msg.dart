// import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:client/provider/global_cache.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/tools/adapter/voice.dart';
import 'package:client/tools/library.dart';
import 'package:client/ui/message_view/msg_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';

final _log = Logger("SoundMsg");

class SoundMsg extends StatefulWidget {
  final ChatMsg msg;
  final ChatUser user;
  SoundMsg(this.msg, this.user) : super(key: UniqueKey());

  @override
  _SoundMsgState createState() => _SoundMsgState();
}

class _SoundMsgState extends State<SoundMsg> with TickerProviderStateMixin {
  // Duration duration;
  // Duration position;

  late AnimationController controller;
  late Animation animation;
  late AnimationController playProcessC;
  late Animation playProcessAnima;
  UcSoundPlayer _myPlayer = new UcSoundPlayer();
  AudioPlayer audioPlayer = AudioPlayer();

  StreamSubscription? _positionSubscription;
  StreamSubscription? _audioPlayerStateSubscription;
  StreamSubscription? _playerSubscription;

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;

  late String urls;
  late int timeLen;
  @override
  void initState() {
    super.initState();
    _myPlayer.openAudioSession().then((value) {
      _log.info("Player.openAudioSession finish");
    });
    var arr = widget.msg.ext!.split(",");
    urls = arr[0];
    timeLen = int.parse(arr[1]) ~/ 1000;
    initializeDateFormatting();
    initAudioPlayer();
  }

  void initAudioPlayer() {
    //控制语音动画
    controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    // final Animation<double> curve =
    //     CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = IntTween(begin: 0, end: 3).animate(controller)
      ..addListener(() {
        // _log.info("animation value: ${animation.value}");
        setState(() {});
      })
      ..addStatusListener((status) {
        // _log.info("animation status: $status, value: ${animation.value}");
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    playProcessC =
        AnimationController(duration: Duration(seconds: timeLen), vsync: this);
    playProcessAnima = IntTween(begin: 0, end: timeLen).animate(playProcessC);
  }

  playNew(url) async {
    if (controller.isAnimating) {
      stopPlay();
      return;
    }
    controller.forward();
    playProcessC.forward(from: 0.0);
    await _myPlayer.startPlayer(
        fromURI: getMediaUrl(url),
        codec: Codec.aacADTS,
        whenFinished: () {
          controller.stop();
          playProcessC.stop();
          setState(() {});
        });

    setState(() {});
  }

  stopPlay() async {
    _myPlayer.stopPlayer();
    controller.stop();
    playProcessC.stop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var my = Global.get().curUser;
    bool isSelf = widget.msg.fromId == my.id;
    var soundImg;
    var leftSoundNames = [
      'assets/images/chat/sound_left_0.webp',
      'assets/images/chat/sound_left_1.webp',
      'assets/images/chat/sound_left_2.webp',
      'assets/images/chat/sound_left_3.webp',
    ];

    var rightSoundNames = [
      'assets/images/chat/sound_right_0.png',
      'assets/images/chat/sound_right_1.webp',
      'assets/images/chat/sound_right_2.webp',
      'assets/images/chat/sound_right_3.png',
    ];
    if (isSelf) {
      soundImg = rightSoundNames;
    } else {
      soundImg = leftSoundNames;
    }
    // var json = jsonDecode(widget.msg.ext!);
    // SoundMsgEntity model = SoundMsgEntity.fromJson(json);
    // ISoundMsgEntity iModel = ISoundMsgEntity.fromJson(json);
    // bool isIos = PlatformUtils.isIOS;
    // if (!listNoEmpty(isIos ? iModel.soundUrls : model.urls)) return Container();

    // var urls = isIos ? iModel.soundUrls![0] : model.urls![0];

    var body = [
      new MsgAvatar(
        model: widget.msg,
        user: widget.user,
      ),
      new Container(
        width: 90.0 + (timeLen - 1) * 3,
        padding: EdgeInsets.only(right: 10.0),
        child: new FlatButton(
          padding: EdgeInsets.only(left: 18.0, right: 4.0),
          child: new Row(
            mainAxisAlignment:
                isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              new Text(
                  controller.isAnimating
                      ? "${playProcessAnima.value}\""
                      : "$timeLen\"",
                  textAlign: TextAlign.start,
                  maxLines: 1),
              new Space(width: mainSpace / 2),
              new Image.asset(
                  controller.isAnimating
                      ? soundImg[animation.value % 3]
                      : soundImg[3],
                  height: 20.0,
                  color: Colors.black,
                  fit: BoxFit.cover),
              new Space(width: mainSpace)
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: widget.user.id == Global.get().curUser.account
              ? Color(0xff98E165)
              : Colors.white,
          onPressed: () {
            if (strNoEmpty(urls)) {
              playNew(urls);
            } else {
              showToast(context, '未知错误');
            }
          },
        ),
      ),
      new Spacer(),
    ];
    if (isSelf) {
      body = body.reversed.toList();
    } else {
      body = body;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: new Row(children: body),
    );
  }

  @override
  void dispose() {
    if (_positionSubscription != null) {
      _positionSubscription?.cancel();
    }
    if (_audioPlayerStateSubscription != null) {
      _audioPlayerStateSubscription?.cancel();
    }
    if (_playerSubscription != null) {
      _playerSubscription?.cancel();
    }
    playProcessC.dispose();
    controller.dispose();
    _myPlayer.closeAudioSession();
    super.dispose();
  }
}
