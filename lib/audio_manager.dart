import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerManager {
  static final AudioPlayerManager _instance = AudioPlayerManager._internal();
  factory AudioPlayerManager() => _instance;

  final AudioPlayer _player = AudioPlayer();
  final double _defaultVolume =
      0.65; // the audio files are too loud cause i messed up!!

  final Map<String, String> fileMap = {
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

  final Map<String, String> noteEquivs = {
    // enharmonics and converting ascii characters
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

  Future<void> playAudio(String note) async {
    final audioFile = fileMap[note] ?? fileMap[noteEquivs[note] ?? ''];
    if (audioFile == null) {
      debugPrint('Unrecognized note: $note');
      return;
    }

    await stopAudio();
    await _player.setSource(AssetSource(audioFile));
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(_defaultVolume);
    await _player.resume();
  }
}
