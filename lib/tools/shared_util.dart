import 'package:client/config/keys.dart';
export 'package:client/config/keys.dart';
import 'package:client/config/storage_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedUtil {
  factory SharedUtil() => _getInstance();

  static SharedUtil get instance => _getInstance();
  static SharedUtil? _instance;

  static late SharedPreferences sp;

  SharedUtil._internal() {
    //初始化
    //init
    SharedPreferences.getInstance().then((value) {
      sp = value;
    });
  }

  static SharedUtil _getInstance() {
    if (_instance == null) {
      _instance = new SharedUtil._internal();
    }
    return _instance!;
  }

  /// save
  Future saveString(String key, String value) async {
    if (key == Keys.account) {
      await StorageManager.sp.setString(key, value);
      return;
    }
    String account = StorageManager.sp.getString(Keys.account) ?? "default";
    await StorageManager.sp.setString(key + account, value);
  }

  Future saveInt(String key, int value) async {
    String account = StorageManager.sp.getString(Keys.account) ?? "default";
    await StorageManager.sp.setInt(key + account, value);
  }

  Future saveDouble(String key, double value) async {
    String account = StorageManager.sp.getString(Keys.account) ?? "default";
    await StorageManager.sp.setDouble(key + account, value);
  }

  Future saveBoolean(String key, bool value) async {
    String account = StorageManager.sp.getString(Keys.account) ?? "default";
    await StorageManager.sp.setBool(key + account, value);
  }

  Future saveStringList(String key, List<String> list) async {
    String account = StorageManager.sp.getString(Keys.account) ?? "default";
    await StorageManager.sp.setStringList(key + account, list);
  }

  Future<bool> readAndSaveList(String key, String data) async {
    String account = StorageManager.sp.getString(Keys.account) ?? "default";
    List<String> strings = StorageManager.sp.getStringList(key + account) ?? [];
    if (strings.length >= 10) return false;
    strings.add(data);
    await StorageManager.sp.setStringList(key + account, strings);
    return true;
  }

  void readAndExchangeList(String key, String data, int index) async {
    String account = StorageManager.sp.getString(Keys.account) ?? "default";
    List<String> strings = StorageManager.sp.getStringList(key + account) ?? [];
    strings[index] = data;
    await StorageManager.sp.setStringList(key + account, strings);
  }

  void readAndRemoveList(String key, int index) async {
    String account = StorageManager.sp.getString(Keys.account) ?? "default";
    List<String> strings = StorageManager.sp.getStringList(key + account) ?? [];
    strings.removeAt(index);
    await StorageManager.sp.setStringList(key + account, strings);
  }

  /// get
  Future<String> getString(String key) async {
    if (key == Keys.account) {
      return StorageManager.sp.getString(key) ?? "";
    }
    String account = StorageManager.sp.getString(Keys.account) ?? "default";
    return StorageManager.sp.getString(key + account) ?? "";
  }

  Future<int> getInt(String key) async {
    String account = StorageManager.sp.getString(Keys.account) ?? "default";
    return StorageManager.sp.getInt(key + account) ?? 0;
  }

  Future<double> getDouble(String key) async {
    String account = StorageManager.sp.getString(Keys.account) ?? "default";
    return StorageManager.sp.getDouble(key + account) ?? 0;
  }

  Future<bool> getBoolean(String key) async {
    String account = StorageManager.sp.getString(Keys.account) ?? "default";
    return StorageManager.sp.getBool(key + account) ?? false;
  }

  Future<List<String>> getStringList(String key) async {
    String account = StorageManager.sp.getString(Keys.account) ?? "default";
    List<String> res = StorageManager.sp.getStringList(key + account) ?? [];
    return res;
  }

  Future<List<String>> readList(String key) async {
    String account = StorageManager.sp.getString(Keys.account) ?? "default";
    List<String> strings = StorageManager.sp.getStringList(key + account) ?? [];
    return strings;
  }
}
