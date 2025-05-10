import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _textFadeController;
  final Random random = Random();
  final List<_Confetti> _confettiList = [];

  @override
  void initState() {
    super.initState();

    _confettiController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _textFadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward(); // start fading in text

    _generateConfetti();

    Timer(const Duration(seconds: 7), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BirthdayHomeScreen())
      );
    });
  }

  void _generateConfetti() {
    for (int i = 0; i < 30; i++) {
      _confettiList.add(_Confetti(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 8 + 4,
        color: [
          Colors.white.withValues(),
          Colors.blueAccent.withValues(),
          Colors.lightBlue.withValues(),
        ][random.nextInt(3)],
        shape: [
          Icons.circle,
          Icons.star,
          Icons.square,
        ][random.nextInt(3)],
        speed: random.nextDouble() * 0.0015 + 0.0005,
      ));
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _textFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: AnimatedBuilder(
        animation: _confettiController,
        builder: (context, child) {
          return Stack(
            children: [
              ..._confettiList.map((confetti) {
                double top = (confetti.y + _confettiController.value * confetti.speed * 1000) % 1.0;
                return Positioned(
                  top: top * size.height,
                  left: confetti.x * size.width,
                  child: Icon(
                    confetti.shape,
                    color: confetti.color,
                    size: confetti.size,
                  ),
                );
              }),
              Center(
                child: FadeTransition(
                  opacity: _textFadeController,
                  child: Text(
                    "Happy\nBirthday,\nAbasifreke\nJohn",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.comicNeue(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Confetti {
  final double x;
  final double y;
  final double size;
  final Color color;
  final IconData shape;
  final double speed;

  _Confetti({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.shape,
    required this.speed,
  });
}
