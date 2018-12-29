// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metronome_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetronomeModel _$MetronomeModelFromJson(Map<String, dynamic> json) {
  return MetronomeModel(
      index: json['index'] as int,
      counts: json['counts'] as int,
      beatsOfBar: json['beatsOfBar'] as int,
      beatsOfMinute: json['beatsOfMinute'] as int)
    ..isBegain = json['isBegain'] as bool;
}

Map<String, dynamic> _$MetronomeModelToJson(MetronomeModel instance) =>
    <String, dynamic>{
      'index': instance.index,
      'counts': instance.counts,
      'beatsOfBar': instance.beatsOfBar,
      'beatsOfMinute': instance.beatsOfMinute,
      'isBegain': instance.isBegain
    };
