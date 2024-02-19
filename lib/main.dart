import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(const MaterialApp(
    title: 'Scale Picker',
    home: MyApp(),
  ));
  writeData(true);
}

Future<void> writeData(b) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('useAccidentals', b);
}

Future<bool?> readData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? useAccidentals = prefs.getBool('useAccidentals');
  return prefs.getBool('useAccidentals');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var keys = ["A", "B", "C", "D", "E", "F", "G", "A♭", "B♭", "D♭", "E♭", "G♭", "C♯"];
  var qualities = ["major", "minor"];
  var quotes = ["You can do this!", "Live, laugh, love.", "Your teacher will be proud.",
    "Good luck!", "Nothing is impossible.", "No, this is Patrick!"];
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
    print(readData());
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(
        title: const Text('Scale Picker'),
        actions: [
          IconButton(
            onPressed: () {
              // naviate to second page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
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
          child: Container(
            child: Text(
              textAlign: TextAlign.center, 
              style: const TextStyle(
                color: Colors.grey,
              ),
              quote,
            )
          )
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool useAccidentals = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          actions: [
            IconButton(
              onPressed: () {
                // naviate to second page
                Navigator.pop(context, useAccidentals);
              },  
              icon: const Icon(Icons.arrow_back),
              ),
          ],
        ),

        body: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('Section 1'),
              tiles: [
                SettingsTile.switchTile(
                  title: const Text('Accidentals'),
                  initialValue: useAccidentals, 
                  onToggle: (value) {
                    setState(() {
                      useAccidentals = value;
                    });
                    print(useAccidentals);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}