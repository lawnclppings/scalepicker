import 'dart:math';
import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Scale Picker',
    home: MyApp(),
  ));
}

class Settings {
  bool a;
  bool ab;
  bool b;
  bool bb;
  bool c;
  bool csharp;
  bool d;
  bool e;
  bool eb;
  bool f;
  bool fsharp;
  bool g;
  bool major;
  bool minor;

  Settings({
    required this.a,
    required this.ab,
    required this.b,
    required this.bb,
    required this.c,
    required this.csharp,
    required this.d,
    required this.e,
    required this.eb,
    required this.f,
    required this.fsharp,
    required this.g,

    required this.major,
    required this.minor,
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //var keys = ["A", "A♭", "B", "B♭", "C", "C♯", "D", "E", "E♭", "F", "F♯", "G"];
  bool _a = true, _ab = true, _b = true, _bb = true, _c = true, _csharp = true;
  bool _d = true, _e = true, _eb = true, _f = true, _fsharp = true, _g = true;
  bool major = true, minor = true;
  List<String> keys = [];
  List<String> qualities = [];

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
    "Practicing scales is like eating your veggies."
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
    generateScale();
  }

  void generateScale() {
    if (keys.isEmpty || qualities.isEmpty || (keys.length <= 1 && qualities.length <= 1)) {
      return; //prevent generating literally nothing
    }
    String newScale;
    String randScale;
    do {
      int randomNumber = random.nextInt(keys.length);
      int randomQuality = random.nextInt(qualities.length);
      randScale = "${keys[randomNumber]} ${qualities[randomQuality]}";
      //convert enharmonics
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

    //QUOTES
    String newQuote;
    do {
      int randQuote = random.nextInt(quotes.length);
      newQuote = quotes[randQuote];
    } while (newQuote == previousQuote);
      previousQuote = newQuote;
    setState(() {
      quote = newQuote;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                // naviate to second page
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage()
                    ),
                ).then((_){
                  setState(() {
                    updateKeys();
                  });
                });
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: generateScale,
          child: Center(
            child: Text(
              scale,
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            child: Text(
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
              quote,
            )),
      ),
    );
  }
}
