class PlayState {
  int index; //节奏item索引
  bool playing; //播放状态
  int currentBarIndex; //当前小结数
  int totelCountOfBar; //总小节数
  int currentBeatIndex; //在小节中时第几拍
  int totelBeatsOfBar; //每小节拍数

  PlayState({
    this.index,
    this.playing,
    this.totelCountOfBar,
    this.currentBarIndex,
    this.totelBeatsOfBar,
    this.currentBeatIndex,
  });
}
