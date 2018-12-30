import 'package:json_annotation/json_annotation.dart';
import 'package:metronome/screen/home/model/metronome_model.dart';

part 'local_store_metronome_model.g.dart';

@JsonSerializable()
class LocalStoreMetronomeModel implements Comparable<LocalStoreMetronomeModel> {
  String name;
  List<MetronomeModel> metronomes; //节奏列表
  int creatTimeStamp; //添加日期

  LocalStoreMetronomeModel({
    this.name,
    this.metronomes,
    this.creatTimeStamp,
  });

  LocalStoreMetronomeModel.from(LocalStoreMetronomeModel item)
      : metronomes = List.from(item.metronomes),
        creatTimeStamp = item.creatTimeStamp;

  factory LocalStoreMetronomeModel.fromJson(Map<String, dynamic> json) =>
      _$LocalStoreMetronomeModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$LocalStoreMetronomeModelToJson(this);

  int compareTo(LocalStoreMetronomeModel other) =>
      creatTimeStamp.compareTo(other.creatTimeStamp);
}
