import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bird_player/classes/player_service.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class BottomMenu extends StatelessWidget {
  final Future<List<SongModel>> songModel;
  const BottomMenu({
    Key? key,
    required this.songModel,
  }) : super(key: key);
  Future<List<SongModel>> getData() async {
    return await songModel;
  }

  @override
  Widget build(BuildContext context) {
    final playerService = Provider.of<PlayerService>(context);
    List<SongModel> list = [];
    songModel.then((value) {
      list = value;
    });
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFFFFFFF).withOpacity(.33),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Container(),
          ),
          FutureBuilder<List<SongModel>>(
            future: songModel,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Consumer<PlayerService>(
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                            width: double.infinity,
                            child: value.selectedIndex == -1
                                ? const Text(
                                    'Unknown',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                : Marquee(
                                    text: snapshot
                                        .data![value.selectedIndex].displayName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    scrollAxis: Axis.horizontal,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    blankSpace: 20.0,
                                    velocity: 40.0,
                                    pauseAfterRound: const Duration(seconds: 1),
                                    startPadding: 10.0,
                                  ),
                          ),
                          Row(
                            children: [
                              Text(
                                value.selectedIndex != -1
                                    ? snapshot.data![value.selectedIndex]
                                            .artist ??
                                        'Unknown'
                                    : 'Unknown',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Row(
                  children: [Text('unknown')],
                );
              }
            },
          ),
          Column(
            children: [
              StreamBuilder<Duration>(
                  stream: playerService.audioPlayer.positionStream,
                  initialData: Duration.zero,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == playerService.audioPlayer.duration) {
                        if (playerService.selectedIndex == list.length - 1) {
                          playerService.playNext(list[0].data, list.length);
                          playerService.setIndex(0);
                        } else {
                          playerService.playNext(
                              list[playerService.selectedIndex + 1].data,
                              list.length);
                          playerService.setIndex(playerService.selectedIndex++);
                        }
                        songModel.then((value) {
                          playerService.playRandom(value);
                        });
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ProgressBar(
                        baseBarColor: Colors.white.withOpacity(0.5),
                        thumbRadius: 8,
                        thumbColor: Colors.white,
                        progressBarColor: Colors.white,
                        timeLabelLocation: TimeLabelLocation.sides,
                        timeLabelTextStyle:
                            const TextStyle(color: Colors.white),
                        progress: snapshot.data!,
                        total:
                            playerService.audioPlayer.duration ?? Duration.zero,
                        onSeek: (value) {
                          playerService.audioPlayer.seek(value);
                        },
                      ),
                    );
                  }),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        playerService.repeat();
                      },
                      child: Consumer<PlayerService>(
                        builder: (context, value, child) {
                          return value.repeatWidget;
                        },
                      ),
                    ),
                    Consumer<PlayerService>(
                      builder: (context, value, child) {
                        return InkWell(
                          onTap: () async {
                            final songs = await songModel;
                            if (value.selectedIndex == 0) {
                              playerService.playPrevious(
                                  songs.last.data, songs.length);
                              playerService.setIndex(songs.length - 1);
                            } else {
                              playerService.playPrevious(
                                  songs[value.selectedIndex - 1].data,
                                  songs.length);
                              playerService.setIndex(value.selectedIndex--);
                            }
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 30,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    GestureDetector(onTap: () {
                      playerService.playPause();
                    }, child: Consumer<PlayerService>(
                      builder: (context, value, child) {
                        return value.playPauseWidget;
                      },
                    )),
                    Consumer<PlayerService>(
                      builder: (context, value, child) {
                        return InkWell(
                          onTap: () async {
                            final songs = await songModel;
                            log(value.selectedIndex.toString());
                            if (value.selectedIndex == songs.length - 1) {
                              playerService.playNext(
                                  songs[0].data, songs.length);
                              playerService.setIndex(0);
                            } else {
                              playerService.playNext(
                                  songs[value.selectedIndex + 1].data,
                                  songs.length);
                              playerService.setIndex(value.selectedIndex++);
                            }
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 30,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    InkWell(
                      onTap: () async {
                        playerService.shuffle();
                      },
                      child: Consumer<PlayerService>(
                        builder: (context, value, child) {
                          return value.shuffleWidget;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
