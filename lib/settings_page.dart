import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const SettingsPage(
      {super.key, required this.toggleTheme}); // handle theme on settings page

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  static const List<String> keys = [
    'a',
    'ab',
    'b',
    'bb',
    'c',
    'csharp',
    'd',
    'e',
    'eb',
    'f',
    'fsharp',
    'g',
  ];

  final Map<String, bool> noteToggles = {
    for (var note in keys) note: true,
  };

  bool major = true;
  bool minor = true;
  bool _snackBarVisible = false;
  bool _isLoading = true;
  Timer? _debounceTimer;
  List<String> presets = [];

  @override
  void initState() {
    super.initState();
    initializeSettings();
  }

  Future<void> initializeSettings() async {
    await loadSettings();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final newToggles = Map<String, bool>.from(noteToggles);
    newToggles.updateAll((key, value) => prefs.getBool(key) ?? true);
    final newMajor = prefs.getBool('major') ?? true;
    final newMinor = prefs.getBool('minor') ?? true;
    final rawPresets = prefs.getStringList('presets') ?? [];
    presets = rawPresets;

    if (mounted) {
      setState(() {
        noteToggles.clear();
        noteToggles.addAll(newToggles);
        major = newMajor;
        minor = newMinor;
      });
    }
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in noteToggles.entries) {
      await prefs.setBool(entry.key, entry.value);
    }
    await prefs.setBool('major', major);
    await prefs.setBool('minor', minor);
  }

  Future<void> savePreset(String name) async {
    if (presets.length >= 10) {
      // make sure the user cant set too many presets, sorry if you wanted 100 presets it is not happening.
      if (mounted) {
        _showWarning(context, 'Maximum of 10 presets allowed.');
      }
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final presetKey = 'preset_$name';
    final presetData = {
      'notes':
          noteToggles.entries.where((e) => e.value).map((e) => e.key).toList(),
      'major': major,
      'minor': minor,
    };
    await prefs.setString(presetKey, jsonEncode(presetData));

    if (!presets.contains(name)) {
      setState(() {
        presets.add(name);
      });
      await prefs.setStringList('presets', presets);
    }
  }

  Future<void> loadPreset(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final presetKey = 'preset_$name';
    final jsonString = prefs.getString(presetKey);
    if (jsonString == null) return;

    final Map<String, dynamic> presetData = jsonDecode(jsonString);
    final selectedNotes = List<String>.from(presetData['notes'] ?? []);
    final newMajor = presetData['major'] ?? true;
    final newMinor = presetData['minor'] ?? true;

    setState(() {
      noteToggles.updateAll((key, _) => selectedNotes.contains(key));
      major = newMajor;
      minor = newMinor;
    });

    debouncedSaveSettings();
  }

  void deletePreset(String name, VoidCallback updateDialog) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('preset_$name');
    setState(() {
      presets.remove(name);
    });
    await prefs.setStringList('presets', presets);
    updateDialog(); // ensure dialog updates too
  }

  void debouncedSaveSettings() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), saveSettings);
  }

  void _showWarning(BuildContext context, String message) {
    if (_snackBarVisible) return;
    _snackBarVisible = true;
// warning messages to tell the user they cant deselect everything (or else the app breaks duh)
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      )).closed.then((_) {
        if (mounted) {
          setState(() {
            _snackBarVisible = false;
          });
        }
      });
  }

  void openPresetsDialog(BuildContext context) {
    final TextEditingController presetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            titlePadding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            actionsPadding: const EdgeInsets.only(right: 12, bottom: 8),
            title: Text(
              'Presets',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors
                        .black, // for some reason light theme displays this text as white..
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (presets.isNotEmpty)
                  ...presets.map((presetName) {
                    return ListTile(
                      dense: true,
                      visualDensity: const VisualDensity(
                          vertical: -2), // tight vertical spacing
                      contentPadding: EdgeInsets.zero,
                      title: Text(presetName),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).brightness ==
                                  Brightness
                                      .dark // changes based on theme so it doesnt look weird
                              ? Colors.red
                              : Colors.red[800],
                        ),
                        onPressed: () async {
                          deletePreset(presetName, () => setDialogState(() {}));
                        },
                      ),
                      onTap: () {
                        loadPreset(presetName);
                        Navigator.pop(context);
                      },
                    );
                  })
                else
                  const Text("No presets saved."),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: presetController,
                        decoration: const InputDecoration(
                          labelText: 'Preset Name',
                        ),
                        onSubmitted: (name) async {
                          final trimmedName = name.trim();
                          if (trimmedName.isNotEmpty &&
                              !presets.contains(trimmedName) &&
                              presets.length < 10) {
                            await savePreset(trimmedName);
                            presetController.clear();
                            setDialogState(() {});
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: IconButton(
                        icon: const Icon(Icons.save),
                        onPressed: presets.length >= 10
                            ? null
                            : () async {
                                final name = presetController.text.trim();
                                if (name.isNotEmpty &&
                                    !presets.contains(name)) {
                                  await savePreset(name);
                                  presetController.clear();
                                  setDialogState(() {});
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Close"),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => openPresetsDialog(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...noteToggles.entries.map((entry) {
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          final selectedCount =
                              noteToggles.values.where((v) => v).length;
                          if (selectedCount == 1 && entry.value) {
                            noteToggles.updateAll((_, __) => true);
                          } else {
                            noteToggles.updateAll((k, _) => k == entry.key);
                          }
                          debouncedSaveSettings();
                        });
                      },
                      child: SwitchListTile(
                        title: Text(_formatNoteLabel(entry.key)),
                        value: entry.value,
                        onChanged: (bool value) {
                          final trueCount =
                              noteToggles.values.where((v) => v).length;
                          if (!value && trueCount <= 1) {
                            _showWarning(
                                context, 'At least one key must be selected.');
                            return;
                          }
                          setState(() {
                            noteToggles[entry.key] = value;
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
                          noteToggles.values.where((v) => v).length;
                      setState(() {
                        setState(() {
                          if (selectedCount == 1) {
                            major = value;
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
                      });
                      debouncedSaveSettings();
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Minor'),
                    value: minor,
                    onChanged: (bool value) {
                      final selectedCount =
                          noteToggles.values.where((v) => v).length;
                      setState(() {
                        if (selectedCount == 1) {
                          minor = value;
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
