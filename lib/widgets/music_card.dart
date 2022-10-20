import 'package:bird_player/classes/music_id.dart';
import 'package:bird_player/classes/player_service.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MusicCard extends StatefulWidget {
  final int id;
  final bool isSaved;
  final String artist;
  final String songName;
  final String url;
  final int index;
  VoidCallback onTap;
  MusicCard(
      {Key? key,
      required this.id,
      required this.isSaved,
      required this.artist,
      required this.songName,
      required this.url,
      required this.index,
      required this.onTap})
      : super(key: key);

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  @override
  Widget build(BuildContext context) {
    final playerService = Provider.of<PlayerService>(context);
    final musicID = Provider.of<MusicID>(context);
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
                  id: widget.id,
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
                          widget.songName,
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
                      widget.artist,
                      style: const TextStyle(
                          color: Color(0xFFD8D8D8), fontSize: 12),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: widget.onTap,
                child: Icon(
                  (!widget.isSaved) ? Icons.favorite_border : Icons.favorite,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  if (musicID.getMusicID != widget.id) {
                    playerService
                      ..play(widget.url)
                      ..setIndex(widget.index);
                    musicID.setMusicID(widget.id);
                  }
                },
                child: Consumer<PlayerService>(
                  builder: (context, value, child) {
                    if (widget.id == musicID.getMusicID) {
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
