import 'package:client/config/api.dart';
import 'package:client/http/req.dart';
import 'package:client/provider/login_model.dart';
import 'package:client/provider/model/user.dart';
import 'package:client/tools/shared_util.dart';
import 'package:client/tools/library.dart';

class LoginLogic {
  final LoginModel _model;

  LoginLogic(this._model);

  ///获取当前选择的地区号码
  Future getArea() async {
    final area = await SharedUtil.instance.getString(Keys.area);
    if (area == "") return;
    if (area == _model.area) return;
    _model.area = area;
  }
}
