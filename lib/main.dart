import 'dart:math';
import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkMode = false;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Load theme preference
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
      isInitialized = true;
    });
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', isDarkMode);
  }

  void _toggleTheme() async {
    setState(() {
      darkMode = !darkMode;
    });
    await _saveThemePreference(darkMode); // Save the new theme preference
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scale Picker',
      theme: darkMode ? ThemeData.dark(): ThemeData.light(),
      home: isInitialized
          ? HomePage(toggleTheme: _toggleTheme)
          : const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _a = true, _ab = true, _b = true, _bb = true, _c = true, _csharp = true;
  bool _d = true, _e = true, _eb = true, _f = true, _fsharp = true, _g = true;
  bool major = true, minor = true;
  List<String> keys = [];
  List<String> qualities = [];
  bool dronePlaying = false;
  final player = AudioPlayer();
  final List<String> quotes = [
    "You can do this!",
    "Live, laugh, love.",
    "Your teacher will be proud.",
    "Good luck!",
    "Nothing is impossible.",
    "No, this is Patrick!",
    "Keep Yourself Safe.",
    "Intonation...",
    "Practice 40hrs a day!",
    "Geniuses are born, not created.",
    "Practicing scales is like eating your veggies.",
    "Life without music would B♭.",
    "Don't give up!",
    "Slow practice. Or else...",
  ];
  String scale = '';
  String quote = '';
  String previousQuote = '';
  String previousScale = '';
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await updateKeys();
    if (keys.isEmpty ||
        qualities.isEmpty ||
        (keys.length <= 1 && qualities.length <= 1)) {
      scale = "C major";
    }
    generateScale();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _a = prefs.getBool('a') ?? true;
      _ab = prefs.getBool('ab') ?? true;
      _b = prefs.getBool('b') ?? true;
      _bb = prefs.getBool('bb') ?? true;
      _c = prefs.getBool('c') ?? true;
      _csharp = prefs.getBool('csharp') ?? true;
      _d = prefs.getBool('d') ?? true;
      _e = prefs.getBool('e') ?? true;
      _eb = prefs.getBool('eb') ?? true;
      _f = prefs.getBool('f') ?? true;
      _fsharp = prefs.getBool('fsharp') ?? true;
      _g = prefs.getBool('g') ?? true;
      major = prefs.getBool('major') ?? true;
      minor = prefs.getBool('minor') ?? true;
    });
  }

  Future<void> updateKeys() async {
    await loadSettings();
    keys
      ..clear()
      ..addAll([
        if (_a) 'A',
        if (_ab) 'A♭',
        if (_b) 'B',
        if (_bb) 'B♭',
        if (_c) 'C',
        if (_csharp) 'C♯',
        if (_d) 'D',
        if (_e) 'E',
        if (_eb) 'E♭',
        if (_f) 'F',
        if (_fsharp) 'F♯',
        if (_g) 'G'
      ]);

    qualities
      ..clear()
      ..addAll([if (major) 'major', if (minor) 'minor']);
  }

  Future<void> generateScale() async {
    if (keys.isEmpty ||
        qualities.isEmpty ||
        (keys.length <= 1 && qualities.length <= 1)) {
      return; // Prevent generating literally nothing
    }
    String newScale;
    String randScale;
    do {
      int randomNumber = random.nextInt(keys.length);
      int randomQuality = random.nextInt(qualities.length);
      randScale = "${keys[randomNumber]} ${qualities[randomQuality]}";
      // Convert enharmonics
      if (randScale == "C♯ major") {
        newScale = "D♭ major";
      } else if (randScale == "A♭ minor") {
        newScale = "G♯ minor";
      } else {
        newScale = randScale;
      }
    } while (newScale == previousScale);
    previousScale = newScale;
    setState(() {
      scale = newScale;
    });
    // QUOTES
    String newQuote;
    do {
      int randQuote = random.nextInt(quotes.length);
      newQuote = quotes[randQuote];
    } while (newQuote == previousQuote);
    previousQuote = newQuote;
    setState(() {
      quote = newQuote;
    });

    // HANDLE AUDIO DRONES
    if (dronePlaying) {
      await play();
    }
  }

  Future<void> play() async {
    final noteToFile = {
      'A': 'a.mp3',
      'A♭': 'ab.mp3',
      'G♯': 'ab.mp3',
      'B': 'b.mp3',
      'B♭': 'bb.mp3',
      'C': 'c.mp3',
      'C♯': 'csharp.mp3',
      'D♭': 'csharp.mp3',
      'D': 'd.mp3',
      'E♭': 'eb.mp3',
      'E': 'e.mp3',
      'F': 'f.mp3',
      'F♯': 'fsharp.mp3',
      'G': 'g.mp3',
    };
    await player.stop();

    var splitScale = scale.split(' ');
    if (splitScale.isEmpty) {
      return; // No scale found, do nothing
    }

    var audioFile = noteToFile[splitScale[0]];

    if (audioFile == null) {
      return; // If no audio file found, do nothing
    }

    await player.play(AssetSource(audioFile));
    player.setReleaseMode(ReleaseMode.loop);
    player.setVolume(0.75); // Cause the audio files are too loud
  }

  void toggleDrone() {
    setState(() {
      dronePlaying = !dronePlaying;
    });
    if (dronePlaying) {
      play();
    } else {
      player.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              dronePlaying ? Icons.volume_up : Icons.volume_off,
            ),
            onPressed: toggleDrone,
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              ).then((_) {
                setState(() {
                  updateKeys();
                });
              });
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Stack( // to make sure the gesturedetector covers the entire screen
        children: [
          Center(
            child: Text(
              scale,
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: generateScale,
            child: Container(
              color: Colors
                  .transparent, // Make sure it's transparent to not block content
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
            elevation: 0,
            child: Container(
            color: Colors.transparent,
              child: Text(
                textAlign: TextAlign.center,
                style: const TextStyle(
                color: Colors.grey,
              ),
              quote,
            ),
            ),
      ),
    );
  }
}