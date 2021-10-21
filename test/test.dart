import 'dart:convert';

void main(List<String> args) {
  var str = showMediaTime(601);
  print(str);
}

String showMediaTime(int startSecond) {
  var s = startSecond % 60;
  var m = startSecond ~/ 60;
  var h = startSecond ~/ 3600;
  var ss = s < 10 ? "0$s" : s.toString();
  var mm = m < 10 ? "0$m" : m.toString();
  if (h == 0) {
    return "$mm:$ss";
  } else {
    var hh = h < 10 ? "0$h" : h.toString();
    return "$hh:$mm:$ss";
  }
}
