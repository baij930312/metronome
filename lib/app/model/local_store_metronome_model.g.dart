// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_store_metronome_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalStoreMetronomeModel _$LocalStoreMetronomeModelFromJson(
    Map<String, dynamic> json) {
  return LocalStoreMetronomeModel(
      name: json['name'] as String,
      metronomes: (json['metronomes'] as List)
          ?.map((e) => e == null
              ? null
              : MetronomeModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      creatTimeStamp: json['creatTimeStamp'] as int);
}

Map<String, dynamic> _$LocalStoreMetronomeModelToJson(
        LocalStoreMetronomeModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'metronomes': instance.metronomes,
      'creatTimeStamp': instance.creatTimeStamp
    };
