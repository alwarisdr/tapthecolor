import 'package:audioplayers/audioplayers.dart';
import 'package:logger/logger.dart';

class SoundManager {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool soundEnabled = true;

 
  
  static const Map<String, String> soundAssets = {
    'correct': 'sounds/correct.mp3',
    'wrong': 'sounds/wrong.mp3',
    'game_over': 'sounds/game_over.mp3',
    'button_click': 'sounds/click.mp3',
  };

  static Future<void> playSound(String sound) async {
    final logger = Logger();
    if (!soundEnabled) return;
    
    try {
       await _audioPlayer.play(AssetSource('sounds/$sound.mp3'));
    } catch (e) {
      // ไม่มีเสียงก็ไม่เป็นไร - เกมยังเล่นได้
      logger.w('Sound unavailable: $sound');
    }
  }

  static void toggleSound() {
    soundEnabled = !soundEnabled;
  }
  
  static Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}