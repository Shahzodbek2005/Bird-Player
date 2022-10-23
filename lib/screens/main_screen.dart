import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bird_player/classes/functions.dart';
import 'package:bird_player/classes/models/favourites_model.dart';
import 'package:bird_player/classes/my_behavior.dart';
import 'package:bird_player/classes/player_service.dart';
import 'package:bird_player/classes/providers/last_music.dart';
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
  final pageController = PageController(initialPage: 0);
  final streamController = StreamController<int>.broadcast();

  @override
  Widget build(BuildContext context) {
    final songs = Provider.of<Future<List<SongModel>>>(context);
    final lastSong = Provider.of<LastMusic>(context);
    final playerService = Provider.of<PlayerService>(context);
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text("Do you want to exit the app?"),
            actions: [
              TextButton(
                onPressed: () async {
                  final box = Hive.box('last');
                  await box.put('song', lastSong.lastSong);
                  await box.put('duration', playerService.audioPlayer.duration);
                },
                child: const Text("Ok"),
              ),
              const SizedBox(
                width: 5,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              const SizedBox(
                width: 4,
              ),
            ],
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF792CAC),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 18, bottom: 14, left: 17, right: 17),
                child: GestureDetector(
                  onTap: () async {
                    await Hive.box('new').put('isNew', true);
                    setState(() {});
                  },
                  child: const TopMenu(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 13, left: 17, right: 17),
                child: Categories(
                  streamController: streamController,
                  allPressed: () {
                    pageController.jumpToPage(0);
                  },
                  favPressed: () {
                    pageController.jumpToPage(1);
                  },
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: PageView(
                    allowImplicitScrolling: true,
                    controller: pageController,
                    onPageChanged: (value) {
                      streamController.sink.add(value);
                    },
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
                                      if (!ids.contains(
                                          data[index].id.toString())) {
                                        await box.add(jsonEncode(details));
                                      } else {
                                        final position =
                                            ids.indexWhere((value) {
                                          return ids.contains(
                                              data[index].id.toString());
                                        });
                                        await box.deleteAt(position);
                                      }
                                      setState(() {});
                                    },
                                    isSaved:
                                        ids.contains(data[index].id.toString()),
                                    onPlay: () async {
                                      final box = Hive.box('new');
                                      if (box.get('isNew') == true) {
                                        await box.put('isNew', false);
                                        setState(() {});
                                      }
                                    },
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
                                        return ids.contains(
                                            data[index].id.toString());
                                      });
                                      await box.deleteAt(position);
                                      setState(() {});
                                    },
                                    isSaved: true,
                                    onPlay: () async {
                                      final box = Hive.box('new');
                                      if (box.get('isNew') == true) {
                                        await box.put('isNew', false);
                                        setState(() {});
                                      }
                                    },
                                  );
                                }),
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  "Siz yoqtirgan qo'shiqlar mavjud emas...",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Builder(builder: (context) {
                final box = Hive.box('new');
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: box.get('isNew') ? 0 : 150,
                  child: BottomMenu(
                    songModel: songs,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
