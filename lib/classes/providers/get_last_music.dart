import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GetLastMusic extends ChangeNotifier {
  final box = Hive.box('last');
  Future<Map<String, dynamic>> getLastSong() async {
    final song = await box.get('song');
    Map<String, dynamic> data = jsonDecode(song);
    return data;
  }
}
