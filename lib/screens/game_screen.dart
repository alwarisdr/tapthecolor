// Game Screen

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tapthecolor/managers/sound_manager.dart';
import 'package:tapthecolor/managers/storage_manager.dart';
import 'package:tapthecolor/medels/game_color.dart';
import 'dart:math';
import 'dart:async';

import 'package:vibration/vibration.dart';


class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State <GameScreen> with TickerProviderStateMixin {
  final List<GameColor> colors = [
    GameColor('แดง', Colors.red),
    GameColor('เขียว', Colors.green),
    GameColor('น้ำเงิน', Colors.blue),
    GameColor('เหลือง', Colors.yellow),
    GameColor('ม่วง', Colors.purple),
    GameColor('ส้ม', Colors.orange),
  ];

  late GameColor correctColor;
  late Color displayColor;
  late List<Color> buttonColors;
  
  int score = 0;
  int timeLeft = 30;
  int combo = 0;
  bool isGameOver = false;
  Timer? gameTimer;
  Random random = Random();

    // Animation controllers
  late AnimationController _shakeController;
  late AnimationController _pulseController;
  String feedbackText = '';
  Color feedbackColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
        _shakeController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _startGame();
  }

  void _startGame() {
    _generateNewRound();
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          _endGame();
        }
      });
    });
  }

  void _generateNewRound() {
    setState(() {
      // สุ่มคำที่ต้องการ (คำตอบที่ถูก)
      correctColor = colors[random.nextInt(colors.length)];
      
      // สุ่มสีที่แสดง (อาจไม่ตรงกับความหมาย)
      displayColor = colors[random.nextInt(colors.length)].color;
      
      // สร้างปุ่มตัวเลือก
      buttonColors = List.from(colors.map((c) => c.color));
      buttonColors.shuffle();
    });
  }

Future<void> _checkAnswer(Color selectedColor) async {
  if (isGameOver) return;

  final bool isCorrect = selectedColor == correctColor.color;

  // Sound
  await SoundManager.playSound(isCorrect ? 'correct' : 'wrong');

  if (isCorrect) {
    _pulseController.forward().then((_) => _pulseController.reverse());

    score += 10 + combo * 2;
    combo++;
    timeLeft += 2;

    feedbackText = '✓ ถูกต้อง!';
    feedbackColor = Colors.green;

    _generateNewRound();
  } else {
    // Vibrate
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 100);
    }

    _shakeController.forward().then((_) => _shakeController.reverse());

    combo = 0;
    score = max(0, score - 5);

    feedbackText = '✗ ผิด!';
    feedbackColor = Colors.red;
  }

  // Update UI
  setState(() {});

  // Clear feedback automatically
  _clearFeedback();
}

void _clearFeedback() {
  Future.delayed(const Duration(milliseconds: 500), () {
    if (!mounted) return;
    setState(() => feedbackText = '');
  });
}


  Future<void> _endGame() async {
    gameTimer?.cancel();
    setState(() {
      isGameOver = true;
    });

    await SoundManager.playSound('game_over');
    await StorageManager.saveHighScore(score);
    await StorageManager.incrementGamesPlayed();
    
    final highScore = await StorageManager.getHighScore();
    final isNewRecord = score == highScore && score > 0;
    
    if (!mounted) return; //
    
    // แสดงผลลัพธ์
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            if (isNewRecord)
              Text(
                '🎉 สถิติใหม่! 🎉',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ).animate().scale(duration: 600.ms),
            Text(
              'เกมจบ!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'คะแนนของคุณ',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              '$score',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Combo สูงสุด:'),
                      Text('$combo', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('คะแนนสูงสุด:'),
                      Text('$highScore', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('กลับหน้าหลัก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                score = 0;
                timeLeft = 30;
                combo = 0;
                isGameOver = false;
              });
              _startGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: Text('เล่นอีกครั้ง',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade300, Colors.blue.shade300],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoCard('⏱️ $timeLeft', Colors.white),
                    _buildInfoCard('🔥 x$combo', Colors.orange.shade100),
                    _buildInfoCard('⭐ $score', Colors.yellow.shade100),
                  ],
                ),
              ),

              Spacer(),

              // คำที่ต้องกด
              Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Text(
                      'กดสีที่ความหมายคือ:',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      correctColor.name,
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: displayColor,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black26,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(),

              // ปุ่มตัวเลือก
              Padding(
                padding: EdgeInsets.all(20),
                child: Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.center,
                  children: buttonColors.map((color) {
                    return _buildColorButton(color);
                  }).toList(),
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String text, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () => _checkAnswer(color),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),
    );
  }
}