import 'dart:ui';
import 'package:dharavikabhootv2/controllers/split_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SplitPage extends StatefulWidget {
  const SplitPage({super.key});

  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> with TickerProviderStateMixin {
  final SplitPageController _splitPageController = SplitPageController();
  // Map to store animation controllers for each image pair
  final Map<int, AnimationController> _hoverControllers = {};
  // Map to store animations for each image pair
  final Map<int, Animation<Offset>> _hoverAnimations = {};
  // Keep track of which image is currently being hovered
  int? _hoveredImageIndex;
  bool isPlaying = true;
  @override
  void initState() {
    super.initState();
    _splitPageController.initializeVideos(() {
      if (mounted) {
        setState(() {});
      }
    });
    _splitPageController.highlightedLyricStream.stream
        .listen((highlightedIndex) {
      setState(() {});
    });

    // Initialize animation controllers for each of the image pairs (12 pairs)
    for (int i = 0; i < 12; i++) {
      _hoverControllers[i] = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );

      _hoverAnimations[i] = Tween<Offset>(
        begin: const Offset(1.1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _hoverControllers[i]!,
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  @override
  void dispose() {
    _splitPageController.dispose();
    // Dispose all animation controllers
    for (var controller in _hoverControllers.values) {
      controller.dispose();
    }
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
            // Add a flexible or expanded widget with flex to give it a proportion of the screen
            Flexible(
              child: ListView(
                children: [
                  ..._splitPageController.lyricGroups
                      .asMap()
                      .entries
                      .map((entry) {
                    List<Map<String, dynamic>> group = entry.value;
                    return SizedBox(
                      height: 500, // Fixed height for each group container
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: group.map((lyric) {
                            int lyricIndex = _splitPageController.lyricsData
                                .indexWhere((item) =>
                                    item["lyrics"] == lyric["lyrics"] &&
                                    item["timestamp"] == lyric["timestamp"]);

                            bool isHighlighted =
                                _splitPageController.currentLyricIndex ==
                                    lyricIndex;
                            bool isClickable = lyric.containsKey("type") &&
                                lyric["type"] == "clickable";
                            ValueNotifier<bool> isHovered =
                                ValueNotifier(false);
                            return GestureDetector(
                              onTap: () {
                                _splitPageController.stopMusic();
                                _splitPageController
                                    .playMusicFromPosition(lyric["timestamp"]);
                              },
                              child: ValueListenableBuilder<bool>(
                                valueListenable: isHovered,
                                builder: (context, hovered, child) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      decoration: BoxDecoration(
                                        color: isHighlighted
                                            ? Colors.blue.withOpacity(0.3)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        lyric["lyrics"]!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Variex',
                                          fontSize: isClickable &&
                                                  (hovered || isHighlighted)
                                              ? 40
                                              : 30,
                                          fontWeight:
                                              (isClickable || isHighlighted)
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          fontStyle: isClickable
                                              ? FontStyle.italic
                                              : FontStyle.normal,
                                          color: isHighlighted
                                              ? Colors.blue.shade700
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () async {
                      setState(() {
                        isPlaying = !isPlaying;
                        if (!isPlaying) {
                          _splitPageController.pauseMusic();
                        } else if (isPlaying) {
                          _splitPageController.resumeMusic();
                        }
                      });
                    },
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow)),
              ],
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.zero,
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

  // Helper method to create a glass hover effect stack for image pairs
  Widget _buildGlassHoverStack(
      int pairIndex, Widget baseImage, Widget overlayImage, String paragraph) {
    // Ensure both base and overlay images have appropriate sizing
    return AspectRatio(
      aspectRatio: _splitPageController.controllers[0].value.aspectRatio,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            child: MouseRegion(
              onEnter: (_) {
                _splitPageController.pauseMusic();
                setState(() => _hoveredImageIndex = pairIndex);
                _hoverControllers[pairIndex]?.forward();
              },
              onExit: (_) {
                _splitPageController.resumeMusic();

                setState(() => _hoveredImageIndex = null);
                _hoverControllers[pairIndex]?.reverse();
              },
              child: Stack(
                fit: StackFit
                    .expand, // Make all children expand to fill the stack
                children: [
                  // Base image - ensure it has a size
                  Positioned.fill(child: baseImage),

                  // Overlay image with glass effect - ensure it has a size
                  Positioned.fill(child: overlayImage),

                  // Glass effect overlay that slides in on hover
                  if (_hoveredImageIndex == pairIndex)
                    SlideTransition(
                      position: _hoverAnimations[pairIndex]!,
                      child: ClipRect(
                        // Use ClipRect instead of ClipRRect for better performance
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            color: Colors.white.withOpacity(0.45),
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  paragraph,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'mvboli'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white.withOpacity(0.5), width: 8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget mediaWithTiming(double position) {
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
      Image image = Image.asset(
        'assets/images/$name.png',
        fit: BoxFit.cover, // Ensure the image covers its container
      );
      precacheImage(image.image, context);
      return image;
    }).toList();

    if (position < 9 * 1000) {
      _splitPageController.controllers[0].play();
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 8),
        ),
        child: AspectRatio(
            aspectRatio: _splitPageController.controllers[0].value.aspectRatio,
            child: Builder(builder: (context) {
              if (isPlaying) {
                _splitPageController.controllers[0].play();
              } else {
                _splitPageController.controllers[0].pause();
              }
              return VideoPlayer(_splitPageController.controllers[0]);
            })),
      );
    } else if (position < 15 * 1000) {
      _splitPageController.controllers[1].play();
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 8),
        ),
        child: AspectRatio(
            aspectRatio: _splitPageController.controllers[1].value.aspectRatio,
            child: VideoPlayer(_splitPageController.controllers[1])),
      );
    } else if (position < 19 * 1000) {
      return _buildGlassHoverStack(0, images[0], images[1],
          "The walls and the lanes whisper to its people about the need to start at the right time. It ingrains the spirit of hunt, rigor, and sincerity to work and fulfill their own dreams. It guides people in silence and loudness at the same time. There are enough struggles in Dharavi, but it is a starting point, after all, for lives that have an invoked fire within them and take up pace to move ahead in life. It doesn't degrade them for their social conditions but simply makes them realize they should follow their dreams and passions and live a content life. The voices have a certain weight—light or heavy—they are carried out in the city with these lives.");
    } else if (position < 24 * 1000) {
      _splitPageController.controllers[2].play();
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 8),
        ),
        child: AspectRatio(
            aspectRatio: _splitPageController.controllers[2].value.aspectRatio,
            child: VideoPlayer(_splitPageController.controllers[2])),
      );
    } else if (position < 28 * 1000) {
      return _buildGlassHoverStack(1, images[2], images[3],
          "Be it a Mumbaikar or not, if you happen to be an outsider to this dense maze of Dharavi, you end up losing track of your route—a loop so tangled within itself, with every face a lookalike. The loop is so ingrained in the memory of the residents and localities of Dharavi. But that's about the map of routes—what about the map of their dreams? How often have they been kept track of? Passion seems to get lost or stuck in the maze of life—that life is Dharavi. The lives here, burdened with so many social complexities, are often dismissed from their own choices and dreams. Each corner echoes a hustle for survival, and the same corner echoes a wish for accomplishment.\nA walk so silent, waiting to hear voices trapped in the walls that whisper only to themselves in silence. There's no lie in the talent that exists in these narrow lanes, and there's no lie that they struggle to breathe as well. These narrow lanes call for opportunities as broad as they can get. Many knocks come at their doors, but is every knock answered? Each echo of talent is masked by some other voice—or maybe, they choose to mask it themselves.\nThey do seek the bright sun but fear if the dark chases them back. You hunt for the talent, and it doesn't run away from you—it simply camouflages itself. So now you know—maybe the talent's not lost, but hidden.");
    } else if (position < 34 * 1000) {
      _splitPageController.controllers[3].play();
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 8),
        ),
        child: AspectRatio(
            aspectRatio: _splitPageController.controllers[3].value.aspectRatio,
            child: VideoPlayer(_splitPageController.controllers[3])),
      );
    } else if (position < 39 * 1000) {
      return _buildGlassHoverStack(2, images[4], images[5],
          "The lanes of Dharavi are filled with young, enthusiastic spirits who are driven by their passion and talent. They have a rigorous attitude that draws them closer to their dreams. But little do these young voices get a chance to speak for themselves. Often, these kids are restricted to service- or job-oriented fields of science, commerce, and arts. They are deprived of the freedom to explore beyond these streams, whether in a creative field or sports.\nThey are so burdened with academic pressure that they tend to lose touch with their own passion and talent. Parents fear that if their children choose such career paths, they wouldn't earn enough and would fail to survive in the long run, given their already lower social background. Each young voice awaits the chance to be heard on a bigger platform and to open up to a larger world.");
    } else if (position < 45 * 1000) {
      _splitPageController.controllers[4].play();
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 8),
        ),
        child: AspectRatio(
            aspectRatio: _splitPageController.controllers[4].value.aspectRatio,
            child: VideoPlayer(_splitPageController.controllers[4])),
      );
    } else if (position < 49 * 1000) {
      return _buildGlassHoverStack(3, images[6], images[7],
          "Amidst the struggle of privilege and class, communities belonging to underprivileged social backgrounds lack breathing equality. This equality is not just absent in space but also in status, opportunities, and more. This often hinders the growth of individuals as well as the community.\nIt creates a separate base for competition—not to prove superiority, but rather to exclude them entirely from competition, as they are deprived of opportunities. However, this does not put a stop to their budding spirit. It may add layers of obstruction to their path, but they choose not to give up.");
    } else if (position < 54 * 1000) {
      _splitPageController.controllers[5].play();
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 8),
        ),
        child: AspectRatio(
            aspectRatio: _splitPageController.controllers[5].value.aspectRatio,
            child: VideoPlayer(_splitPageController.controllers[5])),
      );
    } else if (position < 58 * 1000) {
      return _buildGlassHoverStack(4, images[8], images[9],
          "The lanes of Dharavi are often heard screaming for help. These voices echo deep pain and frustration. Women and their voices here often remain ignored. They have become accustomed to facing domestic violence. Their daily lives have become prone to such violence, which they often try to resist, but many have sadly accepted their fate.\nScenarios where women resist and fight against patriarchy are frequently suppressed. This suppression and oppression remain constants in society. What begins as regular chaos eventually becomes an accepted trauma for both women and children. The youth, deeply immersed in hip-hop and rap culture, attempt to represent these unheard voices");
    } else if (position < 64 * 1000) {
      _splitPageController.controllers[6].play();
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 8),
        ),
        child: AspectRatio(
            aspectRatio: _splitPageController.controllers[6].value.aspectRatio,
            child: VideoPlayer(_splitPageController.controllers[6])),
      );
    } else if (position < 68 * 1000) {
      return _buildGlassHoverStack(5, images[10], images[11],
          "The ball is seen as a metaphor for ambition. It urges the young spirits from these narrow lanes to recognize the need to be passionate and driven by enthusiasm. It reminds them not to be ignorant of their social conditions and pushes them beyond their limits");
    } else if (position < 74 * 1000) {
      _splitPageController.controllers[7].play();
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 8),
        ),
        child: AspectRatio(
            aspectRatio: _splitPageController.controllers[7].value.aspectRatio,
            child: VideoPlayer(_splitPageController.controllers[7])),
      );
    } else if (position < 78 * 1000) {
      return _buildGlassHoverStack(6, images[12], images[13],
          "The spirit of the youth here in Dharavi is often questioned or, rather, forced to conform to a certain way of life. Family conditions and background take away the freedom of these spirits, whether intentionally or unintentionally. The desires among the youth vary—each carries a different story, a different wish, and a different purpose.\nTalent is often dismissed here by its own people. Anyone interested in pursuits beyond academics can be questioned or restricted from chasing their dreams. People tend to judge the choices these individuals make for a living. Each one wishes and hopes for a life that is unlike Dharavi—and, more importantly, outside Dharavi.\nParents fear that hip-hop, rap, and similar cultures could obstruct their children's escape from here");
    } else if (position < 84 * 1000) {
      _splitPageController.controllers[8].play();
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 8),
        ),
        child: AspectRatio(
            aspectRatio: _splitPageController.controllers[8].value.aspectRatio,
            child: VideoPlayer(_splitPageController.controllers[8])),
      );
    } else if (position < 88 * 1000) {
      return _buildGlassHoverStack(7, images[14], images[15],
          "In the initial stages of their journey, budding hip-hop artists or rappers seek exposure through collaborations—either with other similar artists or with brands that can help advertise them. Unfortunately, coming from such a social background, they are often deprived of these opportunities and are forced to rely on their own productions, which are mostly showcased on platforms like YouTube.");
    } else if (position < 103 * 1000) {
      _splitPageController.controllers[9].play();
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 8),
        ),
        child: AspectRatio(
            aspectRatio: _splitPageController.controllers[9].value.aspectRatio,
            child: VideoPlayer(_splitPageController.controllers[9])),
      );
    } else if (position < 107 * 1000) {
      return _buildGlassHoverStack(8, images[16], images[17],
          "Promises are meant to be broken, and politicians prove it. There are people who want to escape Dharavi, and then there are those who would rather change the map of Dharavi first. They envision a developed Dharavi for themselves.\nPeople here, regardless of their social conditions, share an emotional connection with the place. They do wish for a better life but might not want to completely detach from it. Dharavi, in its own way, nourishes them as well. Sadly, they have to live among the many lies told by politicians—the very ones who are supposedly responsible for fostering development. Corrupt politics only makes life in Dharavi worse.");
    } else if (position < 113 * 1000) {
      _splitPageController.controllers[10].play();
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 8),
        ),
        child: AspectRatio(
            aspectRatio: _splitPageController.controllers[10].value.aspectRatio,
            child: VideoPlayer(_splitPageController.controllers[10])),
      );
    } else if (position < 117 * 1000) {
      return _buildGlassHoverStack(9, images[18], images[19],
          "Rap—Rhythm and Poetry—roots itself in the daily social environment here. This hip-hop and rap culture pens down the everyday struggles and expresses them in a funky and unique manner. They choose to be a representative voice for the many social issues in Dharavi, carrying voices that are trapped within these walls out onto the streets and beyond. However, the voices that echo from here are often looked down upon due to the societal hierarchy outside.\nA genre of music and dance with a unique identity of its own—independent of others—fails to receive the same respect that other genres do, primarily because it stems from these very lanes. The informality of this culture gets sidelined. Yet, despite such social struggles, the culture chooses to stay true to itself and its people, serving as a poetic narrative for all the unheard voices while proudly carrying the slang and stylistic influences rooted in Dharavi\n");
    } else if (position < 123 * 1000) {
      _splitPageController.controllers[11].play();
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 8),
        ),
        child: AspectRatio(
            aspectRatio: _splitPageController.controllers[11].value.aspectRatio,
            child: VideoPlayer(_splitPageController.controllers[11])),
      );
    } else if (position < 127 * 1000) {
      return _buildGlassHoverStack(10, images[20], images[21],
          "Houses here are small and congested, yet they are home to countless dreams and desires—so many that they often outgrow the size of the house itself. Despite living in such compact spaces, people do not feel trapped; instead, they strive for freedom.\nThe small size of their homes does not measure the size of their dreams. Their rigor and sincerity make their worth even greater and more valuable. And even after achieving success, they remain humble");
    } else if (position < 133 * 1000) {
      _splitPageController.controllers[12].play();
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 8),
        ),
        child: AspectRatio(
            aspectRatio: _splitPageController.controllers[12].value.aspectRatio,
            child: VideoPlayer(_splitPageController.controllers[12])),
      );
    } else if (position < 137 * 1000) {
      return _buildGlassHoverStack(11, images[22], images[23],
          "After years of struggle and pain, when one makes it big out of Dharavi, it becomes a moment of sheer happiness. The lanes that breathe hard work and hardship begin to breathe a sense of relief and satisfaction.\nIn the hip-hop culture, during the initial stages, artists often choose to remain underground. Many know that once their voices are heard, there is a chance they may be willingly oppressed. The path is already burdened with social struggles, and no one wants to add more obstacles to their journey. Instead, they wait until they can be heard on bigger platforms. Once they make it to the big screen, it's a triumph.\nBut not every screen accomplishment guarantees a happy ending—some things remain the same.");
    } else if (position < 170 * 1000) {
      _splitPageController.controllers[13].play();
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 8),
        ),
        child: AspectRatio(
            aspectRatio: _splitPageController.controllers[13].value.aspectRatio,
            child: VideoPlayer(_splitPageController.controllers[13])),
      );
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
