import 'dart:developer';
import 'dart:io';

import 'package:bird_player/widgets/bottom_menu.dart';
import 'package:bird_player/widgets/categories.dart';
import 'package:bird_player/widgets/music_card.dart';
import 'package:bird_player/widgets/top_menu.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final songs = Provider.of<Future<List<SongModel>>>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF792CAC),
      body: SafeArea(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 18, bottom: 14, left: 17, right: 17),
            child: TopMenu(),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 13, left: 17, right: 17),
            child: Categories(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: FutureBuilder<List<SongModel>>(
                future: songs,
                initialData: const [],
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    if (data.isNotEmpty) {
                      for (var element in data) {
                        log(element.displayName);
                      }
                      return ListView.builder(
                        itemCount: data.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return MusicCard(
                            artist: data[index].artist ?? "Unknown",
                            id: data[index].id,
                            songName: data[index].displayName,
                            url: data[index].data,
                            index: index,
                          );
                        },
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
          ),
          BottomMenu(songModel: songs),
        ],
      )),
    );
  }
}
