import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
  
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

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
      
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
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
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Add or remove keys'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add or remove keys'),
      ),
      body: Padding(
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
                _saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('A♭'),
              value: _ab,
              onChanged: (bool value) {
                setState(() {
                  _ab = value;
                });
                _saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('B'),
              value: _b,
              onChanged: (bool value) {
                setState(() {
                  _b = value;
                });
                _saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('B♭'),
              value: _bb,
              onChanged: (bool value) {
                setState(() {
                  _bb = value;
                });
                _saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('C'),
              value: _c,
              onChanged: (bool value) {
                setState(() {
                  _c = value;
                });
                _saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('C♯'),
              value: _csharp,
              onChanged: (bool value) {
                setState(() {
                  _csharp = value;
                });
                _saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('D'),
              value: _d,
              onChanged: (bool value) {
                setState(() {
                  _d = value;
                });
                _saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('E'),
              value: _e,
              onChanged: (bool value) {
                setState(() {
                  _e = value;
                });
                _saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('E♭'),
              value: _eb,
              onChanged: (bool value) {
                setState(() {
                  _eb = value;
                });
                _saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('F'),
              value: _f,
              onChanged: (bool value) {
                setState(() {
                  _f = value;
                });
                _saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('F♯'),
              value: _fsharp,
              onChanged: (bool value) {
                setState(() {
                  _fsharp = value;
                });
                _saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('G'),
              value: _g,
              onChanged: (bool value) {
                setState(() {
                  _g = value;
                });
                _saveSettings();
              },
            ),
          ],
        ),
      ),
    );
  }
}