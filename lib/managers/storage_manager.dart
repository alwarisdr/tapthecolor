import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapthecolor/managers/sound_manager.dart';


class StorageManager {
  static const String HIGH_SCORE_KEY = 'high_score';
  static const String GAMES_PLAYED_KEY = 'games_played';
  static const String SOUND_ENABLED_KEY = 'sound_enabled';

  static Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(HIGH_SCORE_KEY) ?? 0;
  }

  static Future<void> saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHigh = await getHighScore();
    if (score > currentHigh) {
      await prefs.setInt(HIGH_SCORE_KEY, score);
    }
  }
  static Future<int> getGamesPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(GAMES_PLAYED_KEY) ?? 0;
  }

  static Future<void> incrementGamesPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getGamesPlayed();
    await prefs.setInt(GAMES_PLAYED_KEY, current + 1);
  }

  static Future<bool> getSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SOUND_ENABLED_KEY) ?? true;
  }

  static Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SOUND_ENABLED_KEY, enabled);
    SoundManager.soundEnabled = enabled;
  }
}
