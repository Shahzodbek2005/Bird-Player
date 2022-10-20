import 'dart:async';
import 'dart:convert';

import 'package:bird_player/classes/functions.dart';
import 'package:bird_player/classes/models/favourites_model.dart';
import 'package:bird_player/classes/my_behavior.dart';
import 'package:bird_player/widgets/bottom_menu.dart';
import 'package:bird_player/widgets/categories.dart';
import 'package:bird_player/widgets/music_card.dart';
import 'package:bird_player/widgets/top_menu.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final songs = Provider.of<Future<List<SongModel>>>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF792CAC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 18, bottom: 14, left: 17, right: 17),
              child: GestureDetector(
                onTap: () async {
                  await Hive.box('favourites').clear();
                  setState(() {});
                },
                child: const TopMenu(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 13, left: 17, right: 17),
              child: GestureDetector(
                onTap: () {},
                child: const Categories(),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: PageView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: FutureBuilder<List<SongModel>>(
                        future: songs,
                        initialData: const [],
                        builder: (context, snapshot) {
                          final data = snapshot.data!;
                          final box = Hive.box('favourites');
                          if (data.isNotEmpty) {
                            return ListView(
                              controller: scrollController,
                              physics: const BouncingScrollPhysics(),
                              children: List.generate(data.length, (index) {
                                List ids = [];
                                for (var element in box.values) {
                                  ids.add(jsonDecode(element)['id']);
                                }
                                return MusicCard(
                                  artist: data[index].artist ?? "Unknown",
                                  id: data[index].id,
                                  songName: data[index].displayName,
                                  url: data[index].data,
                                  index: index,
                                  onTap: () async {
                                    final box = Hive.box('favourites');
                                    final id_ = data[index].id;
                                    final songName_ = data[index].displayName;
                                    final artist_ =
                                        data[index].artist ?? "Unknown";
                                    final path_ = data[index].data;
                                    final details = {
                                      'id': '$id_',
                                      'songName': songName_,
                                      'artist': artist_,
                                      'path': path_,
                                    };
                                    if (!ids
                                        .contains(data[index].id.toString())) {
                                      await box.add(jsonEncode(details));
                                    } else {
                                      final position = ids.indexWhere((value) {
                                        return ids.contains(
                                            data[index].id.toString());
                                      });
                                      await box.deleteAt(position);
                                    }
                                    setState(() {});
                                  },
                                  isSaved:
                                      ids.contains(data[index].id.toString()),
                                );
                              }),
                            );
                          } else {
                            return const Center(
                              child: Text("Sizda qo'shiqlar mavjud emas..."),
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: FutureBuilder<ListFavoutes>(
                        future: Functions.getFavoutires(),
                        initialData: ListFavoutes(favourites: []),
                        builder: (context, snapshot) {
                          final data = snapshot.data!.favourites;
                          if (data.isNotEmpty) {
                            return ListView(
                              physics: const BouncingScrollPhysics(),
                              children: List.generate(data.length, (index) {
                                return MusicCard(
                                  artist: data[index].artist,
                                  id: int.parse(data[index].id),
                                  songName: data[index].songName,
                                  url: data[index].path,
                                  index: index,
                                  onTap: () async {
                                    final box = Hive.box('favourites');
                                    List ids = [];
                                    for (var element in box.values) {
                                      ids.add(jsonDecode(element)['id']);
                                    }
                                    final position = ids.indexWhere((value) {
                                      return ids
                                          .contains(data[index].id.toString());
                                    });
                                    await box.deleteAt(position);
                                    setState(() {});
                                  },
                                  isSaved: true,
                                );
                              }),
                            );
                          } else {
                            return const Center(
                              child: Text(
                                  "Siz yoqtirgan qo'shiqlar mavjud emas..."),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomMenu(
              songModel: songs,
            ),
          ],
        ),
      ),
    );
  }
}
