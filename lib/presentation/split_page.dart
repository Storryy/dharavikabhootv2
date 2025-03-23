import 'package:dharavikabhootv2/controllers/split_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SplitPage extends StatefulWidget {
  const SplitPage({super.key});

  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  final SplitPageController _splitPageController = SplitPageController();

  @override
  void initState() {
    super.initState();
    _splitPageController.initializeVideos(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _splitPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('split-page'),
      onVisibilityChanged: (visibilityInfo) {
        // If visibility is above a threshold (e.g., 90%), play music
        if (visibilityInfo.visibleFraction > 0.9) {
          _splitPageController.playMusic();
        } else {
          // Optionally pause when not visible
          _splitPageController.pauseMusic();
        }
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Pellentesque vehicula ultricies nulla, nec tincidunt arcu.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Variex',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: Container(
                child: _splitPageController.isInitialized &&
                        _splitPageController.controllers.isNotEmpty
                    ? StreamBuilder<Duration>(
                        stream:
                            _splitPageController.audioPlayer.onPositionChanged,
                        builder: (context, snapshot) {
                          double currentPosition =
                              snapshot.data?.inMilliseconds.toDouble() ?? 0.0;
                          // Use the current position to return the appropriate widget.
                          return mediaWithTiming(currentPosition);
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Inside SplitPageController class

  Widget mediaWithTiming(double position) {
    // Image image1a = Image.asset(
    //   'assets/images/1a.png',
    // );
    // precacheImage(image1a.image, context);
    List<String> imageNames = [
      '1a',
      '1b',
      '2a',
      '2b',
      '3a',
      '3b',
      '4a',
      '4b',
      '5a',
      '5b',
      '6a',
      '6b',
      '7a',
      '7b',
      '8a',
      '8b',
      '9a',
      '9b',
      '10a',
      '10b',
      '11a',
      '11b',
      '12a',
      '12b'
    ];

    List<Image> images = imageNames.map((name) {
      Image image = Image.asset('assets/images/$name.png');
      precacheImage(image.image, context);
      return image;
    }).toList();

    if (position < 9 * 1000) {
      _splitPageController.controllers[0].play();
      return AspectRatio(
          aspectRatio: _splitPageController.controllers[0].value.aspectRatio,
          child: VideoPlayer(_splitPageController.controllers[0]));
    } else if (position < 15 * 1000) {
      _splitPageController.controllers[1].play();
      return AspectRatio(
          aspectRatio: _splitPageController.controllers[1].value.aspectRatio,
          child: VideoPlayer(_splitPageController.controllers[1]));
    } else if (position < 19 * 1000) {
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: _splitPageController.controllers[1].value.aspectRatio,
            child: images[0],
          ),
          images[1]
        ],
      );
    } else if (position < 24 * 1000) {
      _splitPageController.controllers[2].play();
      return AspectRatio(
          aspectRatio: _splitPageController.controllers[2].value.aspectRatio,
          child: VideoPlayer(_splitPageController.controllers[2]));
    } else if (position < 28 * 1000) {
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: _splitPageController.controllers[1].value.aspectRatio,
            child: images[2],
          ),
          images[3]
        ],
      );
    } else if (position < 34 * 1000) {
      _splitPageController.controllers[3].play();
      return AspectRatio(
          aspectRatio: _splitPageController.controllers[3].value.aspectRatio,
          child: VideoPlayer(_splitPageController.controllers[3]));
    } else if (position < 39 * 1000) {
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: _splitPageController.controllers[1].value.aspectRatio,
            child: images[4],
          ),
          images[5]
        ],
      );
    } else if (position < 45 * 1000) {
      _splitPageController.controllers[4].play();
      return AspectRatio(
          aspectRatio: _splitPageController.controllers[4].value.aspectRatio,
          child: VideoPlayer(_splitPageController.controllers[4]));
    } else if (position < 49 * 1000) {
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: _splitPageController.controllers[1].value.aspectRatio,
            child: images[6],
          ),
          images[7]
        ],
      );
    } else if (position < 54 * 1000) {
      _splitPageController.controllers[5].play();
      return AspectRatio(
          aspectRatio: _splitPageController.controllers[5].value.aspectRatio,
          child: VideoPlayer(_splitPageController.controllers[5]));
    } else if (position < 58 * 1000) {
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: _splitPageController.controllers[1].value.aspectRatio,
            child: images[8],
          ),
          images[9]
        ],
      );
    } else if (position < 64 * 1000) {
      _splitPageController.controllers[6].play();
      return AspectRatio(
          aspectRatio: _splitPageController.controllers[6].value.aspectRatio,
          child: VideoPlayer(_splitPageController.controllers[6]));
    } else if (position < 68 * 1000) {
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: _splitPageController.controllers[1].value.aspectRatio,
            child: images[10],
          ),
          images[11]
        ],
      );
    } else if (position < 74 * 1000) {
      _splitPageController.controllers[7].play();
      return AspectRatio(
          aspectRatio: _splitPageController.controllers[7].value.aspectRatio,
          child: VideoPlayer(_splitPageController.controllers[7]));
    } else if (position < 78 * 1000) {
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: _splitPageController.controllers[1].value.aspectRatio,
            child: images[12],
          ),
          images[13]
        ],
      );
    } else if (position < 84 * 1000) {
      _splitPageController.controllers[8].play();
      return AspectRatio(
          aspectRatio: _splitPageController.controllers[8].value.aspectRatio,
          child: VideoPlayer(_splitPageController.controllers[8]));
    } else if (position < 88 * 1000) {
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: _splitPageController.controllers[1].value.aspectRatio,
            child: images[14],
          ),
          images[15]
        ],
      );
    } else if (position < 103 * 1000) {
      _splitPageController.controllers[9].play();
      return AspectRatio(
          aspectRatio: _splitPageController.controllers[9].value.aspectRatio,
          child: VideoPlayer(_splitPageController.controllers[9]));
    } else if (position < 107 * 1000) {
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: _splitPageController.controllers[1].value.aspectRatio,
            child: images[16],
          ),
          images[17]
        ],
      );
    } else if (position < 113 * 1000) {
      _splitPageController.controllers[10].play();
      return AspectRatio(
          aspectRatio: _splitPageController.controllers[10].value.aspectRatio,
          child: VideoPlayer(_splitPageController.controllers[10]));
    } else if (position < 117 * 1000) {
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: _splitPageController.controllers[1].value.aspectRatio,
            child: images[18],
          ),
          images[19]
        ],
      );
    } else if (position < 123 * 1000) {
      _splitPageController.controllers[11].play();
      return AspectRatio(
          aspectRatio: _splitPageController.controllers[11].value.aspectRatio,
          child: VideoPlayer(_splitPageController.controllers[11]));
    } else if (position < 127 * 1000) {
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: _splitPageController.controllers[1].value.aspectRatio,
            child: images[20],
          ),
          images[21]
        ],
      );
    } else if (position < 133 * 1000) {
      _splitPageController.controllers[12].play();
      return AspectRatio(
          aspectRatio: _splitPageController.controllers[12].value.aspectRatio,
          child: VideoPlayer(_splitPageController.controllers[12]));
    } else if (position < 137 * 1000) {
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: _splitPageController.controllers[1].value.aspectRatio,
            child: images[22],
          ),
          images[23]
        ],
      );
    } else if (position < 157 * 1000) {
      _splitPageController.controllers[13].play();
      return AspectRatio(
          aspectRatio: _splitPageController.controllers[13].value.aspectRatio,
          child: VideoPlayer(_splitPageController.controllers[13]));
    } else {
      return Container(
        color: Colors.blueGrey,
        child: const Center(
          child: Text(
            'Another View',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      );
    }
  }
}
