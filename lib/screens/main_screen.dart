import 'dart:async';
import 'dart:developer';

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
                  log("toza");
                },
                child: const TopMenu(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 13, left: 17, right: 17),
              child: GestureDetector(
                  onTap: () async {
                    log("see");
                    final data = Hive.box<String>('favourites').length;
                    log("Hive data: $data");
                  },
                  child: const Categories()),
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
                          if (snapshot.hasData) {
                            final data = snapshot.data!;
                            final box = Hive.box('favourites');
                            if (data.isNotEmpty) {
                              return ListView(
                                controller: scrollController,
                                physics: const BouncingScrollPhysics(),
                                children: List.generate(data.length, (index) {
                                  return MusicCard(
                                    artist: data[index].artist ?? "Unknown",
                                    id: data[index].id,
                                    songName: data[index].displayName,
                                    url: data[index].data,
                                    index: index,
                                    savedId: box.isNotEmpty
                                        ? int.parse(box.getAt(index)!['id'])
                                        : -1,
                                  );
                                }),
                              );
                            } else {
                              return const Center(
                                child: Text("Sizda qo'shiqlar mavjud emas..."),
                              );
                            }
                          } else {
                            return const Center(
                              child: Text("Nimadir xato ketdi..."),
                            );
                          }
                        },
                      ),
                    ),
                    ListView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      children: List.generate(10, (index) {
                        return MusicCard(
                          savedId: 0,
                          artist: "Diyorbek",
                          id: 1,
                          songName: "Ert",
                          url: "sclnksniksk",
                          index: index,
                        );
                      }),
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
