import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
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

  bool major = true;
  bool minor = true;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
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

      _isLoading = false;
    });
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('a', _a);
    await prefs.setBool('ab', _ab);
    await prefs.setBool('b', _b);
    await prefs.setBool('bb', _bb);
    await prefs.setBool('c', _c);
    await prefs.setBool('csharp', _csharp);
    await prefs.setBool('d', _d);
    await prefs.setBool('e', _e);
    await prefs.setBool('eb', _eb);
    await prefs.setBool('f', _f);
    await prefs.setBool('fsharp', _fsharp);
    await prefs.setBool('g', _g);

    await prefs.setBool('major', major);
    await prefs.setBool('minor', minor);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Configuration'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('A'),
              value: _a,
              onChanged: (bool value) {
                setState(() {
                  _a = value;
                });
                saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('A♭'),
              value: _ab,
              onChanged: (bool value) {
                setState(() {
                  _ab = value;
                });
                saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('B'),
              value: _b,
              onChanged: (bool value) {
                setState(() {
                  _b = value;
                });
                saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('B♭'),
              value: _bb,
              onChanged: (bool value) {
                setState(() {
                  _bb = value;
                });
                saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('C'),
              value: _c,
              onChanged: (bool value) {
                setState(() {
                  _c = value;
                });
                saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('C♯'),
              value: _csharp,
              onChanged: (bool value) {
                setState(() {
                  _csharp = value;
                });
                saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('D'),
              value: _d,
              onChanged: (bool value) {
                setState(() {
                  _d = value;
                });
                saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('E'),
              value: _e,
              onChanged: (bool value) {
                setState(() {
                  _e = value;
                });
                saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('E♭'),
              value: _eb,
              onChanged: (bool value) {
                setState(() {
                  _eb = value;
                });
                saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('F'),
              value: _f,
              onChanged: (bool value) {
                setState(() {
                  _f = value;
                });
                saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('F♯'),
              value: _fsharp,
              onChanged: (bool value) {
                setState(() {
                  _fsharp = value;
                });
                saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('G'),
              value: _g,
              onChanged: (bool value) {
                setState(() {
                  _g = value;
                });
                saveSettings();
              },
            ),
            const Divider(),
            /*
            HONESTLY
            i have no idea how this code actually works
            i just typed in some stuff and it worked first try
            */
            SwitchListTile(
              title: const Text('Major'),
              value: major,
              onChanged: (bool value) {
                setState(() {
                  if (minor = true) major = value; // what the heck
                });
                saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('Minor'),
              value: minor,
              onChanged: (bool value) {
                setState(() {
                  if (major = true) minor = value;
                });
                saveSettings();
              },
            ),
          ],
        ),
      ),
    );
  }
}
