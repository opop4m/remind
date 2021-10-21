import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart' show Level;

class UcVoice extends FlutterSoundRecorder {
  UcVoice() : super(logLevel: Level.warning);

  // Future<void> doStartRecorder({
  //   StreamSink<Food>? toStream,
  //   int sampleRate = 16000,
  //   int numChannels = 1,
  //   int bitRate = 16000,
  //   AudioSource audioSource = AudioSource.defaultSource,
  // }) async {
  //   Codec codec;
  //   // String? toFile;
  //   if (PlatformUtils.isWeb) {
  //     codec = Codec.opusWebM;
  //     // toFile = "uc_chat_sound";
  //   } else {
  //     codec = Codec.aacADTS;
  //     // var tempDir = await getTemporaryDirectory();
  //     // toFile = '${tempDir.path}/flutter_sound.aac';
  //   }
  //   return super.startRecorder(
  //       codec: codec,
  //       toFile: null,
  //       toStream: toStream,
  //       sampleRate: sampleRate,
  //       numChannels: numChannels,
  //       bitRate: bitRate,
  //       audioSource: audioSource);
  // }
}

class UcSoundPlayer extends FlutterSoundPlayer {
  UcSoundPlayer() : super(logLevel: Level.error);
}
