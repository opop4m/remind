import 'package:flutter/material.dart';

showVoiceDialog(BuildContext context, Key key) {
  var voiceDialog = VoiceDialog(key);
  OverlayEntry overlayEntry = new OverlayEntry(builder: (content) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.5 - 80,
      left: MediaQuery.of(context).size.width * 0.5 - 80,
      child: voiceDialog,
    );
  });
  Overlay.of(context)!.insert(overlayEntry);

  return overlayEntry;
}

class VoiceDialog extends StatefulWidget {
  // final int index;
  VoiceDialog(Key key) : super(key: key);

  @override
  VoiceDialogState createState() => VoiceDialogState();
}

class VoiceDialogState extends State<VoiceDialog> {
  int _index = 0;

  void update(int decibel) {
    _index = decibel;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int index = _index;

    String icon() {
      if (index > 0 && index <= 16) {
        return 'assets/images/chat/voice_volume_2.webp';
      } else if (16 < index && index <= 32) {
        return 'assets/images/chat/voice_volume_3.webp';
      } else if (32 < index && index <= 48) {
        return 'assets/images/chat/voice_volume_4.webp';
      } else if (48 < index && index <= 64) {
        return 'assets/images/chat/voice_volume_5.webp';
      } else if (64 < index && index <= 80) {
        return 'assets/images/chat/voice_volume_6.webp';
      } else if (80 < index && index <= 99) {
        return 'assets/images/chat/voice_volume_7.webp';
      } else {
        return 'assets/images/chat/voice_volume_1.webp';
      }
    }

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Opacity(
          opacity: 0.8,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Color(0xff77797A),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: new Image.asset(icon(), width: 100, height: 100),
                ),
                Text(
                  '语音功能待完善',
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
