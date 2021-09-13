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
    return this._request2(
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
    return this._request2(
      url,
      method: RequestType.POST,
      data: params,
      errorCallBack: errorCallBack,
      token: token,
    );
  }

  // Future<Response<T>> post<T>(
  //   String path, {
  //   data,
  //   Map<String, dynamic>? queryParameters,
  //   Options? options,
  //   CancelToken? cancelToken,
  //   ProgressCallback? onSendProgress,
  //   ProgressCallback? onReceiveProgress,
  // }) {
  //   try {
  //     return this._client.post(path);
  //   } catch (e) {}
  //   var op = new RequestOptions(path: path);
  //   return Future(() => new Response(requestOptions: op));
  // }

  //post请求
  Future<Response<T>> postUpload<T>(
    String url,
    OnData callBack,
    ProgressCallback progressCallBack, {
    required FormData formData,
    OnError? errorCallBack,
    CancelToken? token,
  }) async {
    return this._request2(
      url,
      method: RequestType.POST,
      formData: formData,
      errorCallBack: errorCallBack,
      progressCallBack: progressCallBack,
      token: token,
    );
  }

  // void _request(
  //   String url,
  //   OnData callBack, {
  //   required RequestType method,
  //   Map<String, String>? params,
  //   FormData? formData,
  //   OnError? errorCallBack,
  //   ProgressCallback? progressCallBack,
  //   CancelToken? token,
  // }) async {
  //   final id = _id++;
  //   int statusCode = 0;
  //   Response response;
  //   try {
  //     if (method == RequestType.GET) {
  //       ///组合GET请求的参数
  //       if (mapNoEmpty(params)) {
  //         response = await _client.get(url,
  //             queryParameters: params, cancelToken: token);
  //       } else {
  //         response = await _client.get(url, cancelToken: token);
  //       }
  //     } else {
  //       if (mapNoEmpty(params) || formData != null) {
  //         response = await _client.post(
  //           url,
  //           data: formData ?? params,
  //           onSendProgress: progressCallBack,
  //           cancelToken: token,
  //         );
  //       } else {
  //         response = await _client.post(url, cancelToken: token);
  //       }
  //     }

  //     statusCode = response.statusCode ?? 0;

  //     if (response.data is List) {
  //       Map data = response.data[0];
  //       callBack(data);
  //     } else {
  //       Map data = response.data;
  //       callBack(data);
  //     }
  //     print('HTTP_REQUEST_URL::[$id]::$url');
  //     print('HTTP_REQUEST_BODY::[$id]::${params ?? ' no'}');
  //     print('HTTP_RESPONSE_BODY::[$id]::${response.data}');

  //     ///处理错误部分
  //     if (statusCode < 0) {
  //       _handError(errorCallBack, statusCode);
  //       // return;
  //     }
  //   } catch (e) {
  //     _handError(errorCallBack, statusCode);
  //   }
  // }

  Future<Response<T>> _request2<T>(
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
        ///组合GET请求的参数
        if (mapNoEmpty(queryParameters)) {
          res = await _client.get(url,
              queryParameters: queryParameters, cancelToken: token);
        } else {
          res = await _client.get(url, cancelToken: token);
        }
      } else {
        res = await _client.post(
          url,
          data: FormData.fromMap(data),
          onSendProgress: progressCallBack,
          cancelToken: token,
        );
      }
      dynamic rsp = res.data;
      if (rsp["code"] == 401) {
        Notice.once(UcActions.logout());
      }
      return res;
    } catch (e) {
      print(e);
      _handError(errorCallBack, statusCode);
    }
    var op = new RequestOptions(path: url);
    return Future(() => new Response(requestOptions: op));
  }

  ///处理异常
  static void _handError(OnError? errorCallback, int statusCode) {
    String errorMsg = 'Network request error';
    if (errorCallback != null) {
      errorCallback(errorMsg, statusCode);
    }
    print("HTTP_RESPONSE_ERROR::$errorMsg code:$statusCode");
  }
}
