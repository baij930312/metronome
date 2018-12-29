// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiModel _$ApiModelFromJson(Map<String, dynamic> json) {
  return ApiModel()
    ..error = json['error'] as int
    ..data = json['data'] as Map<String, dynamic>
    ..message = json['message'] as String;
}

Map<String, dynamic> _$ApiModelToJson(ApiModel instance) => <String, dynamic>{
      'error': instance.error,
      'data': instance.data,
      'message': instance.message
    };
