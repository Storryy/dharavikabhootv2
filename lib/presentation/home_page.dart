import 'package:dharavikabhootv2/presentation/split_page.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  final VideoPlayerController videoController; // Specify the type properly

  HomePage({Key? key, required this.videoController}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Make sure the video plays when the page loads
    widget.videoController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC9C1C1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: VideoPlayer(widget.videoController),
            ),
            SplitPage()
          ],
        ),
      ),
    );
  }
}
