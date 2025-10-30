import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tapthecolor/managers/storage_manager.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('อันดับคะแนน'),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade400, Colors.blue.shade400],
          ),
        ),
        child: FutureBuilder(
          future: StorageManager.getHighScore(), 
          builder: (context, snapshot){
            final hightscore = snapshot.data ?? 0;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🏆',
                    style: TextStyle(fontSize: 80),
                  ).animate().scale(duration: 800.ms),
                  SizedBox(height: 20),
                  Text(
                    'คะแนนสูงสุดของคุณ',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$hightscore',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 20.0,
                          color: Colors.black26,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                  SizedBox(height: 40),
                  Text(
                    'Online Leaderboard\nมาในเวอร์ชันถัดไป!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}