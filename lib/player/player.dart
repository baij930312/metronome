import 'package:audioplayer/audioplayer.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

enum PlayerState { stopped, playing, paused }

class Player {
  Duration duration;
  Duration position;
  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  Player() {
    initAudioPlayer();
  }

  Future copyLocalAssets() async {
    final bundleDir = 'assets/audio';
    final assetName1 = 'clatter.mp3';
    final localDir = await getApplicationDocumentsDirectory();
    final localAssetFile1 =
        await copyLocalAsset(localDir, bundleDir, assetName1);
    localFilePath = localAssetFile1.path;
  }

  Future<File> copyLocalAsset(
      Directory localDir, String bundleDir, String assetName) async {
    final data = await rootBundle.load('$bundleDir/$assetName');
    final bytes = data.buffer.asUint8List();
    final localAssetFile = File('${localDir.path}/$assetName');
    await localAssetFile.writeAsBytes(bytes, flush: true);
    return localAssetFile;
  }

  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
  }

  void initAudioPlayer() async {
    await copyLocalAssets();
    audioPlayer = new AudioPlayer();
    _positionSubscription =
        audioPlayer.onAudioPositionChanged.listen((p) => {});
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
      }
    }, onError: (msg) {});
    await mute(true);
    await playLocal();
    Future.delayed(Duration(seconds: 5), () async => await mute(false));
  }

  Future play() async {
    await audioPlayer.play('kUrl');
  }

  Future playLocal() async {
    // await stop();
    if (localFilePath == null) {
      return;
    }
    await audioPlayer.play(localFilePath, isLocal: true);
  }

  Future pause() async {
    await audioPlayer.pause();
  }

  Future stop() async {
    await audioPlayer.stop();
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
  }

  void onComplete() {
 
  }
}
