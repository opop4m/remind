import 'package:moor/moor_web.dart';

getMoorDataBase(String account) {
  return WebDatabase("${account}_unicorn");
}
