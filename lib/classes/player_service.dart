import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerService extends ChangeNotifier {
  int selectedIndex = -1;
  var audioPlayer = AudioPlayer();
  bool isShuffle = false;

  Widget playPauseWidget = const Icon(
    Icons.play_arrow,
    color: Colors.white,
    size: 30,
  );
  Widget playWidget = const Icon(
    Icons.play_arrow,
    color: Colors.white,
    size: 30,
  );
  Widget repeatWidget = Icon(
    Icons.repeat,
    color: Colors.white.withOpacity(0.5),
    size: 25,
  );

  Widget shuffleWidget = Icon(
    Icons.shuffle,
    color: Colors.white.withOpacity(0.5),
    size: 25,
  );

  setIndex(int newIndex) {
    selectedIndex = newIndex;
    notifyListeners();
  }

  play(String url) {
    audioPlayer
      ..setFilePath(url)
      ..play();
    playWidget = LottieBuilder.asset(
      'assets/lottie.json',
      width: 30,
      height: 30,
    );
    playPauseWidget = const Icon(
      Icons.pause,
      color: Colors.white,
      size: 30,
    );
    notifyListeners();
  }

  playPause() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
      playWidget = LottieBuilder.asset(
        'assets/lottie.json',
        animate: false,
        width: 30,
        height: 30,
      );

      playPauseWidget = const Icon(
        Icons.play_arrow,
        color: Colors.white,
        size: 30,
      );
    } else {
      audioPlayer.play();
      playPauseWidget = const Icon(
        Icons.pause,
        color: Colors.white,
        size: 30,
      );
      playWidget = LottieBuilder.asset(
        'assets/lottie.json',
        animate: true,
        width: 30,
        height: 30,
      );
    }
    notifyListeners();
  }

  playNext(String url, int length) {
    audioPlayer
      ..setFilePath(url)
      ..play();
    selectedIndex++;
    notifyListeners();
  }

  playPrevious(String url, int length) {
    audioPlayer
      ..setFilePath(url)
      ..play();
    selectedIndex--;
    notifyListeners();
  }

  repeat() {
    if (audioPlayer.loopMode == LoopMode.one) {
      audioPlayer.setLoopMode(LoopMode.off);
      repeatWidget = Icon(
        Icons.repeat,
        color: Colors.white.withOpacity(0.5),
        size: 25,
      );
    } else if (audioPlayer.loopMode == LoopMode.off) {
      audioPlayer.setLoopMode(LoopMode.one);
      repeatWidget = const Icon(
        Icons.repeat_one,
        color: Colors.white,
        size: 25,
      );
    }

    notifyListeners();
  }

  shuffle() {
    isShuffle = !isShuffle;
    if (!isShuffle) {
      shuffleWidget = Icon(
        Icons.shuffle,
        color: Colors.white.withOpacity(0.5),
        size: 25,
      );
    } else {
      shuffleWidget = const Icon(
        Icons.shuffle,
        color: Colors.white,
        size: 25,
      );
    }
    notifyListeners();
  }

  playRandom(List<SongModel> songModel) {
    if (isShuffle) {
      var random = Random.secure();
      int i = random.nextInt(songModel.length);
      selectedIndex = i;
      play(songModel[i].data);
    }
    notifyListeners();
  }
}
