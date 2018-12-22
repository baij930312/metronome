class PlayState{
  int index;//节奏item索引
  bool playing;//播放状态
  int totelCount;//总小节数
  int currentCount;//当前小结数
  int totelCountOfBar;//每小节拍数
  int currentBeat;//在小节中时第几拍

  PlayState({this.index,this.playing,this.totelCount,this.currentCount});
}
