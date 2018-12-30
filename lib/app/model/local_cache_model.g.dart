// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_cache_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalCacheModel _$LocalCacheModelFromJson(Map<String, dynamic> json) {
  return LocalCacheModel()
    ..metronomesStore = (json['metronomesStore'] as List)
        ?.map((e) => e == null
            ? null
            : LocalStoreMetronomeModel.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$LocalCacheModelToJson(LocalCacheModel instance) =>
    <String, dynamic>{'metronomesStore': instance.metronomesStore};
