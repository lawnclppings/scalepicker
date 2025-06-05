import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class SettingsPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  const SettingsPage({super.key, required this.toggleTheme});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final Map<String, bool> _noteToggles = {
    'a': true,
    'ab': true,
    'b': true,
    'bb': true,
    'c': true,
    'csharp': true,
    'd': true,
    'e': true,
    'eb': true,
    'f': true,
    'fsharp': true,
    'g': true,
  };

  bool major = true;
  bool minor = true;
  bool _isLoading = true;
  bool _snackBarVisible = false;
  Timer? _debounceTimer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadSettings());
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _updateMajorMinor() {
    final selectedCount = _noteToggles.values.where((v) => v).length;
    if (selectedCount == 1) {
      major = true;
      minor = true;
    }
  }

  void debouncedSaveSettings() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      saveSettings(); // call the actual save method after 300ms
    });
  }

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final newToggles = Map<String, bool>.from(_noteToggles);
      newToggles.updateAll((key, value) => prefs.getBool(key) ?? true);
      final newMajor = prefs.getBool('major') ?? true;
      final newMinor = prefs.getBool('minor') ?? true;

      if (mounted) {
        setState(() {
          _noteToggles.clear();
          _noteToggles.addAll(newToggles);
          major = newMajor;
          minor = newMinor;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final toggles = Map<String, bool>.from(_noteToggles);

      for (final entry in toggles.entries) {
        try {
          bool valueToSave = entry.value;
          await prefs.setBool(entry.key, valueToSave);
        } catch (e) {
          debugPrint('Error saving ${entry.key}: $e');
        }
      }
      await prefs.setBool('major', major);
      await prefs.setBool('minor', minor);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  void _showWarning(BuildContext context, String message) {
    if (_snackBarVisible) return;

    _snackBarVisible = true;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ).closed.then((_) {
        if (mounted) {
          setState(() {
            _snackBarVisible = false;
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (_isLoading) {
          final prefs = snapshot.data!;
          _noteToggles.updateAll((k, _) => prefs.getBool(k) ?? true);
          major = prefs.getBool('major') ?? true;
          minor = prefs.getBool('minor') ?? true;
          _isLoading = false;
        }

        return buildSettingsContent(context);
      },
    );
  }

  Widget buildSettingsContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._noteToggles.entries.map((entry) {
              return GestureDetector(
                onLongPress: () {
                  final selectedCount =
                      _noteToggles.values.where((v) => v).length;

                  setState(() {
                    // long press to select all scales if only one is marked
                    if (selectedCount == 1 && _noteToggles[entry.key] == true) {
                      _noteToggles
                          .updateAll((_, __) => true); // select every scale
                    } else {
                      // toggle
                      _noteToggles.updateAll((k, _) => k == entry.key);
                    }

                    _updateMajorMinor();
                  });
                  debouncedSaveSettings();
                },
                child: SwitchListTile(
                  title: Text(_formatNoteLabel(entry.key)),
                  value: entry.value,
                  onChanged: (bool value) {
                    int trueCount = _noteToggles.values.where((v) => v).length;

                    if (!value && trueCount <= 1) {
                      _showWarning(
                          context, 'At least one key must be selected.');
                      return;
                    }

                    setState(() {
                      _noteToggles[entry.key] = value;
                      _updateMajorMinor();
                    });

                    debouncedSaveSettings();
                  },
                ),
              );
            }),
            const Divider(),
            SwitchListTile(
              title: const Text('Major'),
              value: major,
              onChanged: (bool value) {
                final selectedCount =
                    _noteToggles.values.where((v) => v).length;

                setState(() {
                  if (selectedCount == 1) {
                    _showWarning(context,
                        'You must have more than one scale to generate.');
                    major = true;
                    minor = true;
                  } else {
                    if (!value && !minor) {
                      major = false;
                      minor = true;
                    } else {
                      major = value;
                    }
                  }
                });
                debouncedSaveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('Minor'),
              value: minor,
              onChanged: (bool value) {
                final selectedCount =
                    _noteToggles.values.where((v) => v).length;

                setState(() {
                  if (selectedCount == 1) {
                    _showWarning(context,
                        'You must have more than one scale to generate.');
                    major = true;
                    minor = true;
                  } else {
                    if (!value && !major) {
                      minor = false;
                      major = true;
                    } else {
                      minor = value;
                    }
                  }
                });
                debouncedSaveSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatNoteLabel(String key) {
    switch (key) {
      case 'ab':
        return 'A♭ / G♯';
      case 'bb':
        return 'B♭';
      case 'csharp':
        return 'C♯ / D♭';
      case 'eb':
        return 'E♭';
      case 'fsharp':
        return 'F♯';
      default:
        return key.toUpperCase();
    }
  }
}
