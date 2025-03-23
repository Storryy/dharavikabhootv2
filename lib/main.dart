import 'package:dharavikabhootv2/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final VideoPlayerController videoController =
      VideoPlayerController.asset("assets/videos/header.mp4");

  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    widget.videoController.initialize();
    widget.videoController.setLooping(true);
  }

  @override
  void dispose() {
    widget.videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dharavi Ka Bhoot',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(videoController: widget.videoController));
  }
}
