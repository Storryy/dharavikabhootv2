import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';

class SplitPageController {
  final List<VideoPlayerController> _controllers = [];
  bool _isInitialized = false;

  List<VideoPlayerController> get controllers => _controllers;
  bool get isInitialized => _isInitialized;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  Future<void> initializeVideos(VoidCallback onInitialized) async {
    final List<String> videoUrls = [
      'assets/videos/startvideo.mp4',
      'assets/videos/1v.mp4',
      'assets/videos/2v.mp4',
      'assets/videos/3v.mp4',
      'assets/videos/4v.mp4',
      'assets/videos/5v.mp4',
      'assets/videos/6v.mp4',
      'assets/videos/7v.mp4',
      'assets/videos/8v.mp4',
      'assets/videos/9v.mp4',
      'assets/videos/10v.mp4',
      'assets/videos/11v.mp4',
      'assets/videos/12v.mp4',
      'assets/videos/finalend.mp4',
    ];

    final List<Map<String, dynamic>> lyricsData = [
      {"lyrics": "Aree sun be bhidu, ye hai Dharavi ka bhoot", "timestamp": 9},
      {
        "lyrics": "Yahan koi nahi phokat ka, sab hai khud ka root!",
        "timestamp": 12
      },
      {
        "lyrics": "Halka leke baitha, toh life dega jhatka,",
        "timestamp": 14.661000,
        "type": "clickable",
        "number": 1,
      },
      {
        "lyrics": "Raste pe gir gaya toh, koi nahi uthane wala patka!",
        "timestamp": 16.9
      },
      {"lyrics": "", "timestamp": -1, "type": "spacer", "height": 20},
      {
        "lyrics": "Maa machine pe silai, baap ka haath me chhalla,",
        "timestamp": 19.715000,
        "type": "clickable",
        "number": 2
      },
      {
        "lyrics": "Bachpan ka sapna, cricket ya chhoti galli ka dhanda?",
        "timestamp": 22.310000,
        "type": "clickable",
        "number": 2
      },
      {"lyrics": "Bhai bole, 'Beta safe खेल',", "timestamp": 24.866000},
      {
        "lyrics": "Par sapne heavy, toh dil kaise fail?",
        "timestamp": 26.662000
      },
      {"lyrics": "", "timestamp": -1, "type": "spacer", "height": 20},
      {
        "lyrics": "Rap likhne baithe, toh gharwale bole, 'Yeh kya hai?'",
        "timestamp": 29.510000
      },
      {
        "lyrics": "'Bhaag school ja, nahi toh kal koi naukri na hai!'",
        "timestamp": 32.3,
        "type": "clickable",
        "number": 3
      },
      {
        "lyrics": "Bollywood wale bole, 'Hip-hop toh faltu hai,'",
        "timestamp": 34.63
      },
      {
        "lyrics": "Par yahi beat jab trending gayi, tab sab ka jadoo hai!",
        "timestamp": 36.862000
      },
      {"lyrics": "", "timestamp": -1, "type": "spacer", "height": 20},
      {
        "lyrics": "Scene बना underground, par budget hai zero,",
        "timestamp": 39.338000
      },
      {
        "lyrics": "Maa ke phone pe record, studio door ka sapna hero!",
        "timestamp": 41.35
      },
      {
        "lyrics": "Class privilege ke wajah se gatekeepers high,",
        "timestamp": 44.166000,
        "type": "clickable",
        "number": 4,
      },
      {
        "lyrics": "Par hum galiyo se aaye, aur beat pe laaye bhai!",
        "timestamp": 46.718000
      },
      {
        "lyrics": "",
        "timestamp": -1,
        "type": "spacer",
        "height": 20,
      },
      {
        "lyrics": "'Raat ka time, galiyon ka crime,'",
        "timestamp": 49.613000,
      },
      {
        "lyrics": "'Andar ke dukh bhi, beat pe rhyme!'",
        "timestamp": 52.247000,
      },
      {
        "lyrics": "'Ghar ke andar chillam chale,'",
        "timestamp": 54.338000,
        "type": "clickable",
        "number": 5
      },
      {
        "lyrics": "'Maa ke aansu kisi ko dikhe naa bhale!'",
        "timestamp": 56.732000,
        "type": "clickable",
        "number": 5
      },
      {"lyrics": "", "timestamp": -1, "type": "spacer", "height": 20},
      {
        "lyrics": "Galli ka ladka ball fake bohot tight,",
        "timestamp": 58.917000
      },
      {
        "lyrics": "Par school ki kitaab bole, 'Beta future bright!'",
        "timestamp": 61
      },
      {"lyrics": "Maa bole, 'Bheja mat garam kar,'", "timestamp": 63.848000},
      {
        "lyrics": "Baap bole, 'Zindagi ye hai, koi nahi hero yaar!'",
        "timestamp": 65.901000
      },
      {"lyrics": "", "timestamp": -1, "type": "spacer", "height": 20},
      {
        "lyrics": "Magar mic uthaye, toh duniya lagi judge karne,",
        "timestamp": 68.651000,
        "type": "clickable",
        "number": 6,
      },
      {
        "lyrics": "'Yeh kya be faltu hai, koi job dhang ka कर ले?'",
        "timestamp": 71.333000
      },
      {
        "lyrics": "Rap ka matlab struggle hai, par yeh nahi samjhe,",
        "timestamp": 73.768
      },
      {
        "lyrics": "Bhai padh likh ke bhi naukri nahi mile, toh kaun jhant ले?",
        "timestamp": 75.762
      },
      {"lyrics": "", "timestamp": -1, "type": "spacer", "height": 20},
      {
        "lyrics": "Hip-hop wale bolte, 'Game toh maara hi hai,'",
        "timestamp": 78.949000
      },
      {
        "lyrics": "Par privilege walo ke saamne, hum niche se aaye hai!",
        "timestamp": 81.037000
      },
      {
        "lyrics": "YouTube views pe chalega, par brands nahi denge,",
        "timestamp": 83.686000
      },
      {
        "lyrics": "Ek din yahi beat pe stadium bhar denge!",
        "timestamp": 86.13000
      },
      {
        "lyrics": "",
        "timestamp": -1,
        "type": "spacer",
        "height": 20,
      },
      {
        "lyrics": "'Suno suno, saara system hi mute,'",
        "timestamp": 88.703000,
      },
      {
        "lyrics": "'Andar se chillaye, par koi nahi sunt!'",
        "timestamp": 91,
      },
      {
        "lyrics": "'Paisa bolega, tabhi milega loot,'",
        "timestamp": 93.517,
      },
      {
        "lyrics": "'Duniya chhoti, Dharavi ka bhoot!'",
        "timestamp": 96.267,
      },
      {
        "lyrics": "",
        "timestamp": -1,
        "type": "spacer",
        "height": 20,
      },
      {
        "lyrics": "Arrey neta aaye, promise ki barsaat,",
        "timestamp": 98.165,
        "type": "clickable",
        "number": 7,
      },
      {
        "lyrics": "Phir gayab jaise chhatt se barsi sau chhat!",
        "timestamp": 100.262000
      },
      {"lyrics": "Gutter ka paani, sadkon pe kheech,", "timestamp": 102.885000},
      {
        "lyrics": "Par Dharavi bole, 'Hum todenge ye deewar ke beech!'",
        "timestamp": 104.864
      },
      {"lyrics": "", "timestamp": -1, "type": "spacer", "height": 20},
      {
        "lyrics": "Par jab mic uthaye, toh log judge karte,",
        "timestamp": 107.573000
      },
      {
        "lyrics": "'Hip-hop toh sadak pe hai, yeh kaun sunta bhai?'",
        "timestamp": 109.816000,
        "type": "clickable",
        "number": 8,
      },
      {
        "lyrics": "Par bhai ka verse jab trending ho jaye,",
        "timestamp": 112.429000
      },
      {
        "lyrics": "Tabhi wahi log bolte, 'Bhai collab kab aaye?'",
        "timestamp": 114.800000
      },
      {"lyrics": "", "timestamp": -1, "type": "spacer", "height": 20},
      {
        "lyrics": "Ghar chhota, par aukaat badi,",
        "timestamp": 117.665000,
        "type": "clickable",
        "number": 9,
      },
      {
        "lyrics": "Ek din TV pe naam likhwayenge, ghadi ghadi!",
        "timestamp": 119.697000,
        "type": "clickable",
        "number": 10,
      },
      {
        "lyrics": "Poverty ka system, par mentality rich,",
        "timestamp": 122.381000
      },
      {
        "lyrics": "Kaam se badlenge game, no time for snitch!",
        "timestamp": 124.479000
      },
      {"lyrics": "", "timestamp": -1, "type": "spacer", "height": 20},
      {
        "lyrics": "'Yeh Dharavi ka bhoot, sapne hai tezz,'",
        "timestamp": 127.098000
      },
      {
        "lyrics": "'Ek din name hoga, pura shahar dega craze!'",
        "timestamp": 129.832000
      },
      {"lyrics": "", "timestamp": -1, "type": "spacer", "height": 20},
      {
        "lyrics": "'Yeh Dharavi ka bhoot, sapne hai tezz,'",
        "timestamp": 151,
      },
      {
        "lyrics": "'Ek din name hoga, pura shahar dega craze!'",
        "timestamp": 154.28000
      },
    ];

    for (final videoUrl in videoUrls) {
      final controller = VideoPlayerController.asset(videoUrl);
      _controllers.add(controller);
      await controller.initialize();
    }

    _isInitialized = true;
    _controllers.first.play();
    onInitialized();
  }

  Future<void> playMusic({double timeStamp = 0.0}) async {
    int seconds = timeStamp.floor();
    int milliseconds = ((timeStamp - seconds) * 1000).round();

    await audioPlayer.setSource(AssetSource('music/dharavikabhoot.mp3'));
    await audioPlayer
        .seek(Duration(seconds: seconds, milliseconds: milliseconds));
    await audioPlayer.resume();
    isPlaying = true;
  }

  // Pauses the music playback
  Future<void> pauseMusic() async {
    if (isPlaying) {
      await audioPlayer.pause();
      isPlaying = false;
    }
  }

  // Resumes playback if paused
  Future<void> resumeMusic() async {
    if (!isPlaying) {
      await audioPlayer.resume();
      isPlaying = true;
    }
  }

  // Stops the music playback completely
  Future<void> stopMusic() async {
    await audioPlayer.stop();
    isPlaying = false;
  }

  // Gets current position of audio playback
  Future<double> getCurrentPosition() async {
    Duration? position = await audioPlayer.getCurrentPosition();
    return position != null ? position.inMilliseconds / 1000 : 0.0;
  }

  Future<dynamic> mediaWithTiming(double currentPosition) async {}

  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
      audioPlayer.dispose();
    }
  }
}
