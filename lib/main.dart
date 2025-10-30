import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:tapthecolor/screens/home_screen.dart';


void main() {
  runApp(TapTheColorApp());
}

class TapTheColorApp extends StatelessWidget {
  const TapTheColorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tap The Color',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: HomeScreen(),
    );
  }
}

