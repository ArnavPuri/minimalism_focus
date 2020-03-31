import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AudioCache cache = AudioCache();
  AudioPlayer player = AudioPlayer();
  PageController _swipeController;
  bool isPlaying = false;

  List<String> sounds = ['rain', 'forest', 'wind', 'flute'];

  String _currentSound = 'rain';

  @override
  void initState() {
    super.initState();
    _swipeController = PageController(viewportFraction: 0.6);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
          primaryColor: Colors.white,
          primaryTextTheme: TextTheme(title: TextStyle(color: Colors.black87)),
          scaffoldBackgroundColor: Colors.white,
          accentColor: Colors.black),
      home: Scaffold(
        appBar: AppBar(
          title: Text("FocusMax"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView(
                controller: _swipeController,
                onPageChanged: (index) async {
                  _currentSound = sounds[index];
                  if (isPlaying) {
                    player.pause();
                    player = await cache.loop('$_currentSound.ogg');
                  }
                },
                children: <Widget>[
                  buildColumn('rain'),
                  buildColumn('forest'),
                  buildColumn('wind'),
                  buildColumn('flute'),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: IconButton(
                    iconSize: 72,
                    icon: Icon(isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled),
                    onPressed: () async {
                      if (isPlaying) {
                        isPlaying = false;
                        player.pause();
                      } else {
                        isPlaying = true;
                        player = await cache.loop('$_currentSound.ogg');
                      }
                      setState(() {});
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Column buildColumn(String sound) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(
          sound.toUpperCase(),
          style: TextStyle(fontSize: 52, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 30,
        ),
        Image(
          image: AssetImage('assets/$sound.png'),
          height: 120,
        ),
      ],
    );
  }
}
