import '../library.dart';

class UcNotice {
  UcNotice._();

  static final _eventMap = <String, StreamController>{};

  static Stream addListener(String event) {
    StreamController? c = _eventMap[event];
    if (c == null) {
      _eventMap[event] = c = StreamController.broadcast();
    }

    return c.stream;
  }

  static send(String event, obj) {
    // ignore: close_sinks
    StreamController? c = _eventMap[event];
    if (c == null) {
      return;
    }
    c.add(obj);
  }
}
