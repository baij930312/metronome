import 'package:json_annotation/json_annotation.dart';
import 'package:metronome/app/model/local_store_metronome_model.dart';
export 'package:metronome/app/model/local_store_metronome_model.dart';
part 'local_cache_model.g.dart';

@JsonSerializable()
class LocalCacheModel {
  List<LocalStoreMetronomeModel> metronomesStore;

  LocalCacheModel();
  factory LocalCacheModel.fromJson(Map<String, dynamic> json) =>
      _$LocalCacheModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$LocalCacheModelToJson(this);
}
