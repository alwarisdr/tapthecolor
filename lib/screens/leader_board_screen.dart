import 'package:flutter/material.dart';
import 'package:tapthecolor/medels/leader_board.dart';

class LeaderboardScreen extends StatelessWidget {
  LeaderboardScreen({super.key});
  
  final List<LeaderboardEntry> leaderboard = [
    LeaderboardEntry('Player1', 850),
    LeaderboardEntry('Player2', 720),
    LeaderboardEntry('Player3', 680),
    LeaderboardEntry('You', 540),
    LeaderboardEntry('Player5', 420),
  ];



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
        child: ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: leaderboard.length,
          itemBuilder: (context, index) {
            final entry = leaderboard[index];
            final isCurrentUser = entry.name == 'You';
            return Container(
              margin: EdgeInsets.only(bottom: 15),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isCurrentUser 
                    ? Colors.yellow.shade100 
                    : Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    '#${index + 1}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade700,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      entry.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  Text(
                    '${entry.score}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade700,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}