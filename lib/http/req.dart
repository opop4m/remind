import 'package:client/http/unicorn.dart';
import 'package:dio/dio.dart';
import 'package:client/tools/library.dart';

var _id = 0;

typedef OnData(t);
typedef OnError(String msg, int code);

enum RequestType { GET, POST }

class Req {
  static Req? _instance;

  ///连接超时时间为5秒
  static const int connectTimeOut = 5 * 1000;

  ///响应超时时间为7秒
  static const int receiveTimeOut = 7 * 1000;

  late Dio _client;

  static Req g() {
    if (_instance == null) {
      _instance = Req._internal();
    }
    return _instance!;
  }

  Req._internal() {
    BaseOptions options = new BaseOptions();
    options.connectTimeout = connectTimeOut;
    options.receiveTimeout = receiveTimeOut;
    _client = new Dio(options);
  }

  Dio get client => _client;

  ///get请求
  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? params,
    OnError? errorCallBack,
    CancelToken? token,
  }) async {
    return this._request(
      url,
      method: RequestType.GET,
      queryParameters: params,
      errorCallBack: errorCallBack,
      token: token,
    );
  }

  //post请求
  Future<Response<T>> post<T>(
    String url,
    dynamic params, {
    OnError? errorCallBack,
    CancelToken? token,
  }) async {
    return this._request(
      url,
      method: RequestType.POST,
      data: params,
      errorCallBack: errorCallBack,
      token: token,
    );
  }

  //post请求
  Future<Response<T>> postUpload<T>(
    String url,
    OnData callBack,
    ProgressCallback progressCallBack, {
    required FormData formData,
    OnError? errorCallBack,
    CancelToken? token,
  }) async {
    return this._request(
      url,
      method: RequestType.POST,
      formData: formData,
      errorCallBack: errorCallBack,
      progressCallBack: progressCallBack,
      token: token,
    );
  }

  Future<Response<T>> _request<T>(
    String url, {
    required RequestType method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    FormData? formData,
    OnError? errorCallBack,
    ProgressCallback? progressCallBack,
    CancelToken? token,
  }) async {
    final id = _id++;
    int statusCode = -1;
    _client.options.headers["unicorn"] = UnicornHttp.getHeaderFormat();

    Response<T> res;
    try {
      if (method == RequestType.GET) {
        //组合GET请求的参数
        if (mapNoEmpty(queryParameters)) {
          res = await _client.get(url,
              queryParameters: queryParameters, cancelToken: token);
        } else {
          res = await _client.get(url, cancelToken: token);
        }
      } else {
        res = await _client.post(
          url,
          data: formData ?? FormData.fromMap(data),
          onSendProgress: progressCallBack,
          cancelToken: token,
        );
      }
      dynamic rsp = res.data;
      if (rsp != null && rsp is Map) {
        var code = rsp["code"];
        if (code != null && code is int && code == 401) {
          Notice.once(UcActions.logout());
        }
      }
      return res;
    } catch (e, s) {
      print(e);
      print(s);

      _handError(errorCallBack, statusCode, url);
    }
    var op = new RequestOptions(path: url);
    return Future(
        () => new Response(requestOptions: op, statusCode: statusCode));
  }

  ///处理异常
  static void _handError(OnError? errorCallback, int statusCode, String url) {
    String errorMsg = 'Network request error';
    if (errorCallback != null) {
      errorCallback(errorMsg, statusCode);
    }
    print("HTTP_RESPONSE_ERROR::$errorMsg code:$statusCode, url: $url");
  }
}
