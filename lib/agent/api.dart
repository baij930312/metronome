import 'package:metronome/agent/agent.dart';
import 'package:metronome/agent/api_model.dart';
import 'package:metronome/bloc/app_bloc.dart';
import 'package:meta/meta.dart';

class Api {
  Future<ApiModel> login({
    @required String accessKey,
    @required String secretKey,
  }) async {
    return httpUtil.post(
      '/authen.do',
      params: {
        "access_key": accessKey ?? '',
        'secret_key': secretKey ?? '',
        'version': '3.0',
        'device_info': '{}',
      },
    );
  }

}

final Api api = Api();
