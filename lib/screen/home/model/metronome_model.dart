class MetronomeModel implements Comparable<MetronomeModel> {
  int index;
  int counts = 10;
  int beatsOfBar = 4;
  int beatsOfMinute = 60;
  bool isBegain = false;
  MetronomeModel({
    this.index,
    this.counts,
    this.beatsOfBar,
    this.beatsOfMinute,
  });

  MetronomeModel.from(MetronomeModel item)
      : index = item.index,
        counts = item.counts,
        beatsOfBar = item.beatsOfBar,
        beatsOfMinute = item.beatsOfMinute,
        isBegain = item.isBegain;

  int compareTo(MetronomeModel other) => index.compareTo(other.index);
}
