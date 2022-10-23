import 'dart:developer';
import 'dart:io';

import 'package:bird_player/classes/music_id.dart';
import 'package:bird_player/classes/player_service.dart';
import 'package:bird_player/classes/providers/get_last_music.dart';
import 'package:bird_player/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  getStoragePermission() async {
    PermissionStatus permissionResult = await Permission.storage.request();
    if (permissionResult.isDenied) {
      exit(0);
    } else {
      await Future.delayed(const Duration(seconds: 1));
      toMainScreen();
    }
  }

  toMainScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
    );
  }

  forNew() async {
    final box = Hive.box('new');
    if (await box.get('isNew') == null) {
      await box.put('isNew', true);
    }
  }

  @override
  void initState() {
    super.initState();
    forNew();
    getStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    final playerService = Provider.of<PlayerService>(context);
    final songs = Provider.of<Future<List<SongModel>>>(context);
    final musicID = Provider.of<MusicID>(context);
    return Scaffold(
      body: FutureBuilder(
        future: GetLastMusic().getLastSong(),
        initialData: const {},
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            playerService.audioPlayer
              ..setFilePath(snapshot.data!['path'])
              ..seek(
                Duration(
                  seconds: int.parse(snapshot.data!['duration'].toString()),
                ),
              );
            playerService.setinitialIndex(songs, snapshot.data!['id']);
            musicID.setMusicID(snapshot.data!['id']);
          }
          return const SizedBox();
        },
      ),
    );
  }
}
