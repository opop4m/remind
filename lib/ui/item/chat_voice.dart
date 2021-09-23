import 'dart:async';
import 'package:client/http/api.dart';
import 'package:client/tools/adapter/voice.dart';
import 'package:client/tools/date.dart';
import 'package:client/tools/library.dart';
import 'package:client/ui/dialog/voice_dialog.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

typedef VoiceFile = void Function(String path, int time);

final _log = Logger("ChatVoice");

class ChatVoice extends StatefulWidget {
  final VoiceFile voiceFile;

  ChatVoice({required this.voiceFile});

  @override
  _ChatVoiceWidgetState createState() => _ChatVoiceWidgetState();
}

class _ChatVoiceWidgetState extends State<ChatVoice> {
  double startY = 0.0;
  double offset = 0.0;
  int index = 0;

  bool isUp = false;
  String textShow = "按住说话";
  String toastShow = "手指上滑,取消发送";
  String voiceIco = "images/voice_volume_1.png";

  StreamSubscription? _recorderSubscription;
  StreamSubscription? _dbPeakSubscription;

  ///默认隐藏状态
  bool voiceState = true;
  OverlayEntry? overlayEntry;
  UcVoice _myRecorder = UcVoice();
  late String _path;

  @override
  void initState() {
    super.initState();
    _myRecorder.openAudioSession().then((value) {
      _log.info("openAudioSession finish.");
    });
    getTemporaryDirectory().then((value) {
      var tempDir = value;
      _path = '${tempDir.path}/flutter_sound.aac';
    });
    // flutterSound = new FlutterSound();
    // flutterSound.setSubscriptionDuration(0.01);
    // flutterSound.setDbPeakLevelUpdate(0.8);
    // flutterSound.setDbLevelEnabled(true);
    initializeDateFormatting();
  }

  int startTimeMillis = DateTime.now().millisecondsSinceEpoch;

  void start() async {
    print('开始拉。当前路径');
    startTimeMillis = DateTime.now().millisecondsSinceEpoch;
    try {
      await _myRecorder.startRecorder(codec: Codec.aacADTS, toFile: _path);
      // String path = await flutterSound
      //     .startRecorder(Platform.isIOS ? 'ios.m4a' : 'android.mp4');
      // widget.voiceFile(path);
      // _recorderSubscription =
      //     flutterSound.onRecorderStateChanged.listen((e) {});
    } catch (err, s) {
      print(err.toString());
      print(s);
      showToast(context, 'startRecorder error: ${err}');
    }
  }

  Future stop() async {
    try {
      await _myRecorder.stopRecorder();
      File f = File(_path);
      if (!isUp) {
        int timeLen = DateTime.now().millisecondsSinceEpoch - startTimeMillis;
        if (timeLen < 1000) {
          showToast(context, '时间太短了');
        }

        var recordBuff = await f.readAsBytes();
        var voicePath = await uploadMediaApi(recordBuff, ".aac", "voice");
        _log.info("-------success   voicePath: $voicePath, timeLen:$timeLen");
        widget.voiceFile(voicePath, timeLen);
      }

      // String result = await flutterSound.stopRecorder();
      // print('stopRecorder: $result');
      f.delete();
    } catch (err, s) {
      print(err);
      print(s);
      showToast(context, 'stopRecorder error');
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_recorderSubscription != null) {
      _recorderSubscription?.cancel();
      _recorderSubscription = null;
    }
    if (_dbPeakSubscription != null) {
      _dbPeakSubscription?.cancel();
      _dbPeakSubscription = null;
    }
    _myRecorder.closeAudioSession();
  }

  showVoiceView() {
    int index = 0;
    setState(() {
      textShow = "松开结束";
      voiceState = false;
      DateTime now = new DateTime.now();
      int date = now.millisecondsSinceEpoch;
      DateTime current = DateTime.fromMillisecondsSinceEpoch(date);

      String recordingTime =
          DateTimeForMater.formatDateV(current, format: "ss:SS");
      index = int.parse(recordingTime.toString().substring(3, 5));
    });

    start();

    if (overlayEntry == null) {
      overlayEntry = showVoiceDialog(context, index: index);
    }
  }

  hideVoiceView() async {
    setState(() {
      textShow = "按住说话";
      voiceState = true;
    });

    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
    //loading...
    await stop();

    if (isUp) {
      print("取消发送");
    } else {
      print("进行发送");
      // Notice.send(UcActions.voiceImg(), true);
    }
  }

  moveVoiceView() {
    setState(() {
      isUp = startY - offset > 100 ? true : false;
      if (isUp) {
        textShow = "松开手指,取消发送";
        toastShow = textShow;
      } else {
        textShow = "松开结束";
        toastShow = "手指上滑,取消发送";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onVerticalDragStart: (details) {
        startY = details.globalPosition.dy;
        showVoiceView();
      },
      onVerticalDragDown: (details) {
        startY = details.globalPosition.dy;
        showVoiceView();
      },
      onVerticalDragCancel: () => hideVoiceView(),
      onVerticalDragEnd: (details) => hideVoiceView(),
      onVerticalDragUpdate: (details) {
        offset = details.globalPosition.dy;
        moveVoiceView();
      },
      child: new Container(
        height: 50.0,
        alignment: Alignment.center,
        width: winWidth(context),
        color: Colors.white,
        child: Text(textShow),
      ),
    );
  }
}
