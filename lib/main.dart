import 'package:bird_player/classes/player_service.dart';
import 'package:bird_player/screens/permission_screen.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final audioQuery = OnAudioQuery();
    return MultiProvider(
      providers: [
        Provider<Future<List<SongModel>>>(
          create: (context) => audioQuery.querySongs(),
        ),
        ChangeNotifierProvider<PlayerService>(
          create: (context) => PlayerService(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: PermissionScreen(),
      ),
    );
  }
}
