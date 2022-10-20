import 'dart:convert';

import 'package:bird_player/classes/models/favourites_model.dart';
import 'package:hive/hive.dart';

class Functions {
  static Future<ListFavoutes> getFavoutires() async {
    final source = Hive.box('favourites');
    List<Map<String, dynamic>> list = [];
    for (var element in source.values) {
      list.add(jsonDecode(element));
    }
    return ListFavoutes.fromMap(list);
  }
}
