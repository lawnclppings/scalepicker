import 'dart:math';
import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
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
  bool darkMode;

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
    required this.darkMode,
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //var keys = ["A", "A♭", "B", "B♭", "C", "C♯", "D", "E", "E♭", "F", "F♯", "G"];
  var keys = [];

  bool _a = true;
  bool _ab = true;
  bool _b = true;
  bool _bb = true;
  bool _c = true;
  bool _csharp = true;
  bool _d = true;
  bool _e = true;
  bool _eb = true;
  bool _f = true;
  bool _fsharp = true;
  bool _g = true;


  Future<void> _loadSettings() async {
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
    });
  }

  Future<void> updateKeys() async { // im sure there is a better way to code this lmao
    _loadSettings();
    keys.clear();
    
    if (_a == true){
          keys.add('A');
    }
    if (_ab == true){
          keys.add('A♭');
    }
    if (_b == true){
          keys.add('B');
    }
    if (_bb == true){
          keys.add('B♭');
    }
    if (_c == true){
          keys.add('C');
    }
    if (_csharp == true){
          keys.add('C♯');
    }
    if (_d == true){
          keys.add('D');
    }
    if (_e == true){
          keys.add('E');
    }
    if (_eb == true){
          keys.add('E♭');
    }
    if (_f == true){
          keys.add('F');
    }
    if (_fsharp == true){
          keys.add('F♯');
    }
    if (_g == true){
          keys.add('G');
    }
  }

  var qualities = ["major", "minor"];
  var quotes = ["You can do this!", "Live, laugh, love.", "Your teacher will be proud.",
  "Good luck!", "Nothing is impossible.", "No, this is Patrick!", "Keep yourself safe", 
  "Intonation...", "Practice 40hrs a day!"];
  String quote = '';
  String scale = '';

  @override
  void initState() {
    super.initState();
    onPressed();
  }

  void onPressed() {
    Random random = Random();
    int randomNumber;
    int randomQuality;
    int randQuote;
    String previousQuote = '';
    String previousScale = '';
    updateKeys();
    if (keys.length >= 2){
      do {
      randomNumber = random.nextInt(keys.length);
      randomQuality = random.nextInt(qualities.length);
    } while ("${keys[randomNumber]} ${qualities[randomQuality]}" == previousScale);
    scale = "${keys[randomNumber]} ${qualities[randomQuality]}";

    do {
      randQuote = random.nextInt(quotes.length);
    } while (quotes[randQuote] == previousQuote);
    quote = quotes[randQuote];

    setState(() {
      scale;
      previousScale = scale;
      previousQuote = quote;
    });
    }
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
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              }, 
              icon: const Icon(Icons.settings),
            ),
        ],
      ),
        body: GestureDetector(
          onTap: onPressed,
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
          )
        ),
      ),
    );
  }
}