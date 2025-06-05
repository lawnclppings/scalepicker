import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerManager {
  static final AudioPlayerManager _instance = AudioPlayerManager._internal();
  factory AudioPlayerManager() => _instance;

  final AudioPlayer _player = AudioPlayer();
  final double _defaultVolume = 0.60;

  final Map<String, String> _fileMap = {
    'A': 'a.mp3',
    'Ab': 'ab.mp3',
    'B': 'b.mp3',
    'Bb': 'bb.mp3',
    'C': 'c.mp3',
    'C#': 'csharp.mp3',
    'D': 'd.mp3',
    'Eb': 'eb.mp3',
    'E': 'e.mp3',
    'F': 'f.mp3',
    'F#': 'fsharp.mp3',
    'G': 'g.mp3',
  };

  final Map<String, String> _enharmonics = {
    'A♭': 'Ab',
    'G♯': 'Ab',
    'B♭': 'Bb',
    'C♯': 'C#',
    'D♭': 'C#',
    'E♭': 'Eb',
    'F♯': 'F#',
  };

  AudioPlayerManager._internal();

  Future<void> stopAudio() async {
    await _player.stop();
  }

  String? _getFileForNote(String note) {
    return _fileMap[note] ?? _fileMap[_enharmonics[note] ?? ''];
  }

  Future<void> playAudio(String note) async {
    final audioFile = _getFileForNote(note);
    if (audioFile == null) {
      debugPrint('Unrecognized note: $note');
      return;
    }

    try {
      await stopAudio();
      await _player.setSource(AssetSource(audioFile));
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(_defaultVolume);
      await _player.resume();
    } catch (e) {
      debugPrint('Audio playback error: $e');
    }
  }
}
