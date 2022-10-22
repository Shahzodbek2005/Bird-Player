import 'dart:convert';

import 'package:flutter/material.dart';

class LastMusic extends ChangeNotifier {
  String lastSong = '';
  String get getLastSong => lastSong;
  setLastSong(
      int id, String name, String artist, String url, Duration duration) {
    lastSong = jsonEncode({
      'id': id,
      'name': name,
      'artist': artist,
      'path': url,
      'position': duration.inSeconds,
    });
    notifyListeners();
  }
}
