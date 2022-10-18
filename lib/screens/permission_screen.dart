import 'dart:io';

import 'package:bird_player/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
    return const Scaffold();
  }
}
