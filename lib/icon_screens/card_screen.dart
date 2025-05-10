import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:confetti/confetti.dart';

class BirthdayCardScreen extends StatefulWidget {
  const BirthdayCardScreen({super.key});

  @override
  State<BirthdayCardScreen> createState() => _BirthdayCardScreenState();
}

class _BirthdayCardScreenState extends State<BirthdayCardScreen> with TickerProviderStateMixin {
  late AudioPlayer _player;
  late ConfettiController _confettiController;
  late AnimationController _balloonController1;
  late AnimationController _balloonController2;
  late AnimationController _balloonController3;
  late AnimationController _balloonController4;
  late AnimationController _balloonController5;

  @override
  void initState() {
    super.initState();

    // Music
    _player = AudioPlayer();
    _player.setAsset('assets/audio/birthday_song.mp3').then((_) {
      _player.play(); // Auto-play on screen load
    });

    // Confetti
    _confettiController = ConfettiController();
    _confettiController.play();

    // Balloons
    _balloonController1 = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
    _balloonController2 = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    _balloonController3 = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
    _balloonController4 = AnimationController(vsync: this, duration: const Duration(seconds: 9))..repeat();
    _balloonController5 = AnimationController(vsync: this, duration: const Duration(seconds: 11))..repeat();
  }

  @override
  void dispose() {
    _player.dispose();
    _confettiController.dispose();
    _balloonController1.dispose();
    _balloonController2.dispose();
    _balloonController3.dispose();
    _balloonController4.dispose();
    _balloonController5.dispose();
    super.dispose();
  }

  void _stopMusic() {
    _player.stop();
  }

  Widget _buildBalloon(AnimationController controller, double startX) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final progress = controller.value;
        final screenHeight = MediaQuery.of(context).size.height;
        return Positioned(
          bottom: progress * screenHeight,
          left: startX,
          child: Image.asset(
            'assets/images/ballon.jpg',
            width: 100,
            height: 140,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Confetti background
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            gravity: 0.3,
            emissionFrequency: 0.3, // Dense confetti
            numberOfParticles: 60,
            maxBlastForce: 30,
            minBlastForce: 20,
            colors: const [
              Colors.blue,
              Colors.lightBlueAccent,
              Colors.indigo,
              Colors.cyan,
              Colors.white,
            ],
          ),

          // Floating Balloons
          _buildBalloon(_balloonController1, screenWidth * 0.1),
          _buildBalloon(_balloonController2, screenWidth * 0.3),
          _buildBalloon(_balloonController3, screenWidth * 0.5),
          _buildBalloon(_balloonController4, screenWidth * 0.7),
          _buildBalloon(_balloonController5, screenWidth * 0.85),

          // Main content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              const Center(
                child: Text(
                  'Wishing You\nthe \nHappiest Birthday!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'ComicSans',
                    fontSize: 32,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),
              const Spacer(flex: 3),

              // Stop Music Button
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: _stopMusic,
                    icon: const Icon(Icons.stop),
                    label: const Text("Stop Music"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
