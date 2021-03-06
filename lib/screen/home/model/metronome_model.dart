import 'package:json_annotation/json_annotation.dart';
part 'metronome_model.g.dart';

@JsonSerializable()
class MetronomeModel implements Comparable<MetronomeModel> {
  int index;
  int counts;
  int beatsOfBar;
  int beatsOfMinute;
  bool isBegain = false;
  MetronomeModel({
    this.index,
    this.counts,
    this.beatsOfBar,
    this.beatsOfMinute,
  });

  Map<String, dynamic> toJson() =>
      _$MetronomeModelToJson(this);

  factory MetronomeModel.fromJson(Map<String, dynamic> json) =>
      _$MetronomeModelFromJson(json);

  MetronomeModel.from(MetronomeModel item)
      : index = item.index,
        counts = item.counts,
        beatsOfBar = item.beatsOfBar,
        beatsOfMinute = item.beatsOfMinute,
        isBegain = item.isBegain;

  int compareTo(MetronomeModel other) => index.compareTo(other.index);
}
