import 'dart:convert';

import 'package:client/provider/model/user.dart';

void main(List<String> args) {
  User u = User();
  var str = jsonEncode(u);
  print(str);
}
