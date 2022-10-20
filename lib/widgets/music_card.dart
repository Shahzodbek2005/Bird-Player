import 'dart:convert';
import 'dart:developer';

import 'package:bird_player/classes/player_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MusicCard extends StatelessWidget {
  final int id;
  final int savedId;
  final String artist;
  final String songName;
  final String url;
  final int index;
  const MusicCard(
      {Key? key,
      required this.id,
      required this.savedId,
      required this.artist,
      required this.songName,
      required this.url,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerService = Provider.of<PlayerService>(context);
    return Column(
      children: [
        Container(
          height: 54,
          width: double.infinity,
          decoration: BoxDecoration(
              color: const Color(0xFFC4C4C4).withOpacity(.41),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              const SizedBox(
                width: 8,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: QueryArtworkWidget(
                  id: id,
                  type: ArtworkType.AUDIO,
                  keepOldArtwork: true,
                  artworkHeight: 40,
                  artworkWidth: 40,
                  nullArtworkWidget: const SizedBox(
                      height: 40,
                      width: 40,
                      child: Icon(Icons.music_note, color: Color(0xff7300ff))),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          songName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      artist,
                      style: const TextStyle(
                          color: Color(0xFFD8D8D8), fontSize: 12),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  log("Liked");
                  final box = Hive.box<String>('favourites');
                  final id_ = id;
                  final songName_ = songName;
                  final artist_ = artist;
                  final path_ = url;
                  final details = {
                    'id': '$id_',
                    'songName': songName_,
                    'artist': artist_,
                    'url': path_,
                  };
                  await box.add("kk");
                },
                child: Icon(
                  (id != savedId) ? Icons.favorite_border : Icons.favorite,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  playerService
                    ..play(url)
                    ..setIndex(index);
                },
                child: Consumer<PlayerService>(
                  builder: (context, value, child) {
                    if (value.selectedIndex == index) {
                      return value.playWidget;
                    } else {
                      return const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              )
            ],
          ),
        ),
        Divider(
          color: const Color(0xFFC4C4C4).withOpacity(.4),
          height: 10,
          thickness: 2,
          indent: 4,
          endIndent: 4,
        )
      ],
    );
  }
}
