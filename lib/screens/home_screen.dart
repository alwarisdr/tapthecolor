import 'package:flutter/material.dart';
import 'package:tapthecolor/managers/sound_manager.dart';
import 'package:tapthecolor/managers/storage_manager.dart';
import 'package:tapthecolor/screens/game_screen.dart';
import 'package:tapthecolor/screens/leader_board_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int highScore = 0;
  int gamesPlayed = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final high = await StorageManager.getHighScore();
    final games = await StorageManager.getGamesPlayed();
    final soundEnabled = await StorageManager.getSoundEnabled();
    setState(() {
      highScore = high;
      gamesPlayed = games;
      SoundManager.soundEnabled = soundEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple.shade400, Colors.blue.shade400],
          ),
        ),
        child: SafeArea(
          child:  Stack(
            children: [
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    icon: Icon(
                      SoundManager.soundEnabled ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {
                      SoundManager.toggleSound();
                      await StorageManager.setSoundEnabled(SoundManager.soundEnabled);
                      setState(() {});
                      SoundManager.playSound('button_click');
                    },
                  ),
                ),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'TAP THE COLOR',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black26,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 600.ms).scale(),

                      SizedBox(height: 20),

                      Text(
                        'กดสีที่ตรงกับความหมายของคำ\nไม่ใช่สีของตัวอักษร!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ).animate().fadeIn(delay: 300.ms),

                      // Stats Cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStatCard('🏆', 'คะแนนสูงสุด', '$highScore'),
                          SizedBox(width: 20),
                          _buildStatCard('🎮', 'เล่นไปแล้ว', '$gamesPlayed'),
                        ],
                      ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3, end: 0),

                      SizedBox(height: 60),

                      _buildButton(
                        context,
                        'เริ่มเล่น',
                        Colors.white,
                        Colors.purple.shade700,
                        () {
                          SoundManager.playSound('button_click');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GameScreen()),
                          ).then((_) => _loadStats());
                        },
                      ).animate().fadeIn(delay: 700.ms).scale(),

                      SizedBox(height: 20),

                      _buildButton(
                        context,
                        'อันดับคะแนน',
                        Colors.white.withValues(alpha: 0.3),
                        Colors.white,
                        () {
                          SoundManager.playSound('button_click');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LeaderboardScreen()),
                          );
                        },
                      ).animate().fadeIn(delay: 900.ms).scale(),
                    ],
                  ),
                ),
            ]
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String emoji, String label, String value) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 30)),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
