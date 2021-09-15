import 'dart:convert';

import 'package:client/provider/model/user.dart';

void main(List<String> args) {
  User u = User();
  u.nickName = "中文";
  var str = jsonEncode(u);
  print(str);
}
