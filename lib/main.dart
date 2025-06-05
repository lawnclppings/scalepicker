import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// local import
import 'settings_page.dart';
import 'audio_manager.dart';

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
  late SharedPreferences prefs;
  late bool _a, _ab, _b, _bb, _c, _csharp, _d, _e, _eb, _f, _fsharp, _g;
  late bool major, minor;
  String scale = "C major"; // default scale

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final systemDarkMode =
          MediaQuery.of(context).platformBrightness == Brightness.dark;
      _initializeApp(systemDarkMode);
    }
  }

  Future<void> _initializeApp(bool systemDarkMode) async {
    final instance = await SharedPreferences.getInstance();
    setState(() {
      prefs = instance;
      darkMode = prefs.getBool('darkMode') ?? systemDarkMode;
      _a = prefs.getBool('a') ?? true;
      _ab = prefs.getBool('ab') ?? true;
      _b = prefs.getBool('b') ?? true;
      _bb = prefs.getBool('bb') ?? true;
      _c = prefs.getBool('c') ?? true;
      _csharp = prefs.getBool('csharp') ?? true;
      _d = prefs.getBool('d') ?? true;
      _eb = prefs.getBool('eb') ?? true;
      _e = prefs.getBool('e') ?? true;
      _f = prefs.getBool('f') ?? true;
      _fsharp = prefs.getBool('fsharp') ?? true;
      _g = prefs.getBool('g') ?? true;
      major = prefs.getBool('major') ?? true;
      minor = prefs.getBool('minor') ?? true;
      isInitialized = true;
    });
    updateKeys();
  }

  Future<void> updateKeys() async {
    List<String> keys = [
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
      if (_g) 'G',
    ];

    if (keys.isEmpty) {
      keys.add('C');
    }

    List<String> qualities = [if (major) 'major', if (minor) 'minor'];

    if (keys.isEmpty || qualities.isEmpty) {
      setState(() {
        scale = "C major";
      });
    }
    setState(() {
      if (keys.isNotEmpty && qualities.isNotEmpty) {
        scale = "${keys.first} ${qualities.first}";
      } else {
        scale = "C major";
      }
    });
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    await prefs.setBool('darkMode', isDarkMode);
  }

  void _toggleTheme() async {
    bool newDarkMode = !darkMode;
    _saveThemePreference(newDarkMode);
    setState(() {
      darkMode = newDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scale Picker',
      theme: darkMode
          ? ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Color(0xFF6AB7F5),
                brightness: Brightness.dark,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0, // Remove shadow for transparency
              ),
              textTheme: TextTheme(
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white),
                bodySmall: TextStyle(color: Colors.white),
                titleLarge: TextStyle(color: Colors.white),
              ),
            )
          : ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Color(0xFF6AB7F5),
                brightness: Brightness.light,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: darkMode ? Colors.white : Colors.grey[700],
                ),
                actionsIconTheme: IconThemeData(
                  color: darkMode ? Colors.white : Colors.grey[700],
                ),
              ),
              textTheme: TextTheme(
                bodyLarge: TextStyle(color: Colors.black),
                bodyMedium: TextStyle(color: Colors.black),
                bodySmall: TextStyle(color: Colors.black),
                titleLarge: TextStyle(color: Colors.black),
              ),
            ),
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
  final List<String> quotes = [
    "You can do this!",
    "Live, laugh, love.",
    "Your teacher will be proud.",
    "Good luck!",
    "Nothing is impossible.",
    "No, this is Patrick!",
    "Intonation...",
    "Practice 40 hours a day!",
    "Geniuses are born, not created.",
    "Practicing scales is like eating your veggies.",
    "Life without music would B♭.",
    "Don't give up!",
    "Slow practice. Or else...",
    "Lock in!",
  ];
  String scale = '';
  String quote = '';
  String previousQuote = '';
  String previousScale = '';
  bool dronePlaying = false;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    AudioPlayerManager().stopAudio();
    super.dispose();
  }

  Future<void> initialize() async {
    await loadSettings();
    await updateKeys();

    if (keys.isEmpty || qualities.isEmpty) {
      setState(() {
        scale = "C major"; // default scale
      });
    }
    await generateScale();
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
      _eb = prefs.getBool('eb') ?? true;
      _e = prefs.getBool('e') ?? true;
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
        if (_g) 'G',
      ]);
    if (keys.isEmpty) {
      keys.add('C');
    }
    qualities
      ..clear()
      ..addAll([if (major) 'major', if (minor) 'minor']);
  }

  Future<void> generateScale() async {
    if (keys.isEmpty || qualities.isEmpty) {
      scale = "C major"; // default scale
      return;
    }

    List<String> allScales = [
      for (var key in keys)
        for (var quality in qualities) _convertEnharmonics("$key $quality")
    ];

    String newScale = allScales[(Random().nextInt(allScales.length))];

    while (newScale == previousScale && allScales.length > 1) {
      newScale = allScales[(Random().nextInt(allScales.length))];
    }

    previousScale = newScale;
    setState(() {
      scale = newScale;
    });

    List<String> availableQuotes = List.from(quotes);

    String newQuote =
        availableQuotes[(Random().nextInt(availableQuotes.length))];

    while (newQuote == previousQuote && availableQuotes.length > 1) {
      newQuote = availableQuotes[(Random().nextInt(availableQuotes.length))];
    }

    previousQuote = newQuote;

    setState(() {
      quote = newQuote;
    });

    if (dronePlaying) {
      await AudioPlayerManager().playAudio(scale.split(' ')[0]);
    }
  }

  String _convertEnharmonics(String scale) {
    switch (scale) {
      case "C♯ major":
        return "D♭ major";
      case "A♭ minor":
        return "G♯ minor";
      default:
        return scale;
    }
  }

  void toggleDrone() {
    setState(() {
      dronePlaying = !dronePlaying;
    });
    if (dronePlaying) {
      AudioPlayerManager().playAudio(scale.split(' ')[0]);
    } else {
      AudioPlayerManager().stopAudio();
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
            onPressed: () {
              if (dronePlaying) {
                toggleDrone();
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsPage(toggleTheme: widget.toggleTheme),
                ),
              ).then((_) {
                setState(() {
                  updateKeys(); // Re-load the keys after settings change
                });
              });
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Stack(
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
              color: Colors.transparent,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
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
