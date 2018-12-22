import 'dart:async';
import 'dart:convert';
import 'package:metronome/agent/api_model.dart';
import 'package:http/http.dart' as http;

class ApiBox {
  static const String Host = "";
  static const int TimeOut = 10;
  static const Map<String, String> BaseHeaders = <String, String>{
    'Cache-Control': 'no-cache',
  };
}

class HttpUtil {
  Future<ApiModel> post(
    String url, {
    Map<String, dynamic> params,
    Map<String, String> headers,
  }) async {
    Map<String, String> headerMap = Map.from(ApiBox.BaseHeaders);
    Map<String, dynamic> paramMap = {
      'version': '1.0',
    };
    Map<String, dynamic> customParams = params == null ? new Map() : params;
    Map<String, String> customHeaders = headers == null ? new Map() : headers;
    paramMap['data'] = json.encode(customParams);
    headerMap.addAll(customHeaders);
    return await _request(
      ApiBox.Host + url,
      headers: headerMap,
      params: paramMap,
    );
  }

  Future<ApiModel> _request(
    String url, {
    Map<String, String> headers,
    Map<String, dynamic> params,
  }) async {
    try {
      ApiModel requestModel = await _createRequest(
        url,
        headers: headers,
        params: params,
      );
      if (requestModel.data == null) {
        //接口数据异常
        return _handError('数据返回为空 url:' + url, -1);
      }
      if (requestModel.error == 0) {
        switch (requestModel.data['state']) {
          case 'TOKEN_EXPIRE': //token 过期
            requestModel.error = -2;
            break;
          case 'PROC_ERROR':
            requestModel.error = -3;
            break;
          case 'REQ_ILLEGAL':
            requestModel.error = -4;
            break;
          default:
        }
      }
      if (requestModel.error != 0) {
        print(url +
            ' error_state:' +
            requestModel.data['state'] +
            " params:" +
            params.toString());
      }
      return requestModel;
    } catch (exception) {
      return _handError(exception.toString(), -1);
    }
  }

  Future<ApiModel> _createRequest(
    String url, {
    Map<String, String> headers,
    Map<String, dynamic> params,
  }) async {
    String errorMsg; //错误信息
    var client = http.Client();
    //发起请求
    http.Response res = await client
        .post(url, body: params, headers: headers)
        //设置超时
        .timeout(Duration(seconds: ApiBox.TimeOut),
            onTimeout: () => Future.value(
                  http.Response(
                    "{message:api time out,state:0}",
                    408,
                  ),
                ));
    if (res.statusCode != 200) {
      //http请求异常
      errorMsg = "code:" + res.statusCode.toString() + ' body:' + res.body;
      return _handError(errorMsg, res.statusCode);
    }
    if (res.body == null || res.body == '') {
      //接口数据异常
      return _handError('数据返回为空 url:' + url, -1);
    }
    //正常返回
    final result = json.decode(res.body);
    var model = ApiModel.fromJson({'error': 0, 'data': result, 'message': ''});
    return model;
  }

  Future<ApiModel> _handError(String errorMsg, int code) {
    print("errorMsg :" + errorMsg);
    var model =
        ApiModel.fromJson({'error': code, 'data': null, 'message': errorMsg});
    return Future.value(model);
  }
}

final httpUtil = HttpUtil();
