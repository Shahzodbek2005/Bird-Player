import 'dart:io';

import 'package:bird_player/classes/player_service.dart';
import 'package:bird_player/classes/providers/get_last_music.dart';
import 'package:bird_player/screens/main_screen.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    getStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    final playerService = Provider.of<PlayerService>(context);
    return Scaffold(
      body: FutureBuilder(
        future: GetLastMusic().getLastSong(),
        initialData: const {},
        builder: (context, snapshot) {
          playerService.audioPlayer
            ..setFilePath(snapshot.data!['path'])
            ..seek(
              Duration(
                seconds: int.parse(snapshot.data!['position'].toString()),
              ),
            );
          return const SizedBox();
        },
      ),
    );
  }
}
