import 'package:client/config/provider_config.dart';
import 'package:client/tools/utils.dart';
import 'package:flutter/material.dart';
// import 'dart:io';
import 'package:flutter/services.dart';
import 'app.dart';
import 'config/storage_manager.dart';
import 'package:logging/logging.dart';

void main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    var format = '${record.level.name}: ' +
        '${record.loggerName} ' +
        '${record.time.hour}:${record.time.minute}:${record.time.second} ' +
        '${record.message}';
    print(format);
  });

  /// 确保初始化
  WidgetsFlutterBinding.ensureInitialized();

  /// 数据初始化
  // await Data.initData();

  /// 配置初始化
  await StorageManager.init();

  runApp(ProviderConfig.getInstance().getGlobal(MyApp()));

  /// Android状态栏透明
  if (PlatformUtils.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}
