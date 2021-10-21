// import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:client/provider/global_cache.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/tools/library.dart';
import 'package:client/ui/message_view/msg_avatar.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_audio_manager/flutter_audio_manager.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:logging/logging.dart' as log;

final _log = log.Logger("SoundMsg");

class SoundMsg extends StatefulWidget {
  final ChatMsg msg;
  final ChatUser user;
  SoundMsg(this.msg, this.user) : super(key: UniqueKey());

  @override
  _SoundMsgState createState() => _SoundMsgState();
}

// UcSoundPlayer? _myPlayer;
bool _isNear = false;
StreamSubscription? _subProximity;
List<_Cache> _cachePlaying = [];

class _Cache {
  _SoundMsgState state;
  List<AnimationController> playing;
  _Cache(this.state, this.playing);
}

// AudioCache audioCache = AudioCache();
// AudioPlayer advancedPlayer = AudioPlayer();

class _SoundMsgState extends State<SoundMsg> with TickerProviderStateMixin {
  // Duration duration;
  // Duration position;

  late AnimationController controller;
  late Animation animation;
  // late AnimationController playProcessC;
  // late Animation playProcessAnima;
  Duration playProcess = Duration();
  PlayerState curStatus = PlayerState.STOPPED;
  // UcSoundPlayer _myPlayer = new UcSoundPlayer();
  // AudioPlayer audioPlayer = AudioPlayer();

  StreamSubscription? _positionSubscription;
  StreamSubscription? _audioPlayerStateSubscription;
  StreamSubscription? _playerSubscription;

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;

  AudioPlayer _audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  PlayingRoute _playingRouteState = PlayingRoute.SPEAKERS;
  bool get _isPlayingThroughEarpiece =>
      _playingRouteState == PlayingRoute.EARPIECE;
  late String urls;
  late int timeLen;

  @override
  void initState() {
    super.initState();
    // _log.info("initState");
    // if (_myPlayer == null) {
    //   _myPlayer = new UcSoundPlayer();
    //   _myPlayer!
    //       .openAudioSession(mode: SessionMode.modeVoiceChat)
    //       .then((value) {
    //     _log.info("Player.openAudioSession finish");
    //   });
    // }

    var arr = widget.msg.ext!.split(",");
    urls = getMediaUrl(arr[0])!;
    timeLen = int.parse(arr[1]);
    initializeDateFormatting();
    initAudioPlayer();
    if (PlatformUtils.isMobile) {
      // FlutterAudioManager.changeToReceiver();
    }
    // if (Platform.isIOS) {
    //   audioCache.fixedPlayer?.notificationService.startHeadlessService();
    // }
  }

  void initAudioPlayer() {
    //控制语音动画
    controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
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
    // playProcessC =
    //     AnimationController(duration: Duration(seconds: timeLen), vsync: this);
    // playProcessAnima = IntTween(begin: 0, end: timeLen).animate(playProcessC);
    // _log.info(
    //     "_audioPlayer.onDurationChanged : ${_audioPlayer.onDurationChanged.isBroadcast}");
    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((duration) {
      // _log.info("playProcess : $playProcess");
      playProcess = duration;
      if (PlatformUtils.isWeb) {
        int cur = playProcess.inMilliseconds;
        if (cur > timeLen - 500) {
          // end.
          stopPlay();
          if (mounted) setState(() => {});
        }
      }
    });
    _audioPlayerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((event) {
      _log.info("onPlayerStateChanged : $event");
      curStatus = event;
      if (event == PlayerState.COMPLETED) {
        stopPlay();
        if (mounted) setState(() {});
      }
    });
  }

  cleanCachePlaying() {
    _cachePlaying.forEach((cache) {
      cache.playing.forEach((ctl) {
        if (ctl.isAnimating) ctl.stop();
      });
      if (cache.state.mounted) cache.state.setState(() {});
    });
    _cachePlaying.clear();
  }

  // StreamSubscription<int>? _subProximity;

  playNew(url) async {
    if (curStatus != PlayerState.STOPPED) {
      await stopPlay();
      if (mounted) setState(() {});
      return;
    }
    cleanCachePlaying();
    controller.forward();
    // await _myPlayer!.startPlayer(
    //     fromURI: getMediaUrl(url),
    //     codec: Codec.aacADTS,
    //     whenFinished: () {
    //       stopPlay();
    //       if (mounted) setState(() {});
    //     });
    await _audioPlayer.play(url);
    _cachePlaying.add(_Cache(this, [controller]));
    if (_subProximity == null && PlatformUtils.isMobile)
      _subProximity = ProximitySensor.events.listen((event) {
        bool isNear = (event > 0) ? true : false;
        if (isNear == _isNear) return;
        _isNear = isNear;
        if (!mounted) return;
        // if (isNear) {
        //   _myPlayer!.setAudioFocus(
        //       device: AudioDevice.earPiece,
        //       mode: SessionMode.modeVoiceChat,
        //       audioFlags: allowBlueTooth |
        //           allowBlueToothA2DP |
        //           allowEarPiece |
        //           allowHeadset);
        // } else {
        //   _myPlayer!.setAudioFocus();
        // }
        _log.info("ProximitySensor is $_isNear");
        if (_isNear) {
          _earpieceOrSpeakersToggle();
          // FlutterAudioManager.changeToReceiver();
        } else {
          // FlutterAudioManager.changeToSpeaker();
          _earpieceOrSpeakersToggle();
        }
      });
    _subProximity?.resume();
    if (mounted) setState(() {});
  }

  Future<int> _earpieceOrSpeakersToggle() async {
    final result = await _audioPlayer.earpieceOrSpeakersToggle();
    if (result == 1) {
      _playingRouteState = _playingRouteState.toggle();
    }
    return result;
  }

  stopPlay() async {
    controller.stop();
    if (curStatus != PlayerState.STOPPED) await _audioPlayer.stop();

    // playProcessC.stop();

    _subProximity?.cancel();
    _subProximity = null;
    if (_isPlayingThroughEarpiece && PlatformUtils.isMobile) {
      _earpieceOrSpeakersToggle();
    }
    // if (PlatformUtils.isMobile) FlutterAudioManager.changeToSpeaker();
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
    int len = timeLen ~/ 1000;
    var body = [
      new MsgAvatar(
        model: widget.msg,
        user: widget.user,
      ),
      new Container(
        width: 90.0 + (len - 1) * 3,
        padding: EdgeInsets.only(right: 10.0),
        child: new FlatButton(
          padding: EdgeInsets.only(left: 18.0, right: 4.0),
          child: new Row(
            mainAxisAlignment:
                isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              new Text(
                  controller.isAnimating
                      ? "${playProcess.inSeconds}\""
                      : "$len\"",
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
              showToast('未知错误');
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
    stopPlay();
    if (_positionSubscription != null) {
      _positionSubscription?.cancel();
    }
    if (_audioPlayerStateSubscription != null) {
      _audioPlayerStateSubscription?.cancel();
    }
    if (_playerSubscription != null) {
      _playerSubscription?.cancel();
    }
    // _log.info("dispose");
    // playProcessC.dispose();
    controller.dispose();
    _subProximity?.cancel();
    _subProximity = null;
    // _myPlayer.closeAudioSession();
    super.dispose();
  }
}
