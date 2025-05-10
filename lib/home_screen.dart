import 'package:birthday_app/icon_screens/card_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';

import 'icon_screens/gift_screen.dart';
import 'icon_screens/memory_screen.dart';
import 'icon_screens/surprise_screen.dart';

class BirthdayHomeScreen extends ConsumerStatefulWidget {
  const BirthdayHomeScreen({super.key});

  @override
  ConsumerState<BirthdayHomeScreen> createState() => _BirthdayHomeScreenState();
}

class _BirthdayHomeScreenState extends ConsumerState<BirthdayHomeScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController();
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    return '$days days\n$hours hours left';
  }

  @override
  Widget build(BuildContext context) {
    final countdownAsync = ref.watch(countdownProvider);

    return Scaffold(
      backgroundColor: Color(0xFF0D1A3B),
      body: Stack(
        children: [
          // 🎊 Confetti background
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: true,
              colors: [Colors.blue, Colors.indigo, Colors.lightBlueAccent],
              numberOfParticles: 100,
              emissionFrequency: 0.9,
              gravity: 0.4,
              maxBlastForce: 35,
              minBlastForce: 20,
              particleDrag: 0.05,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      color: Colors.indigo, // or any color you prefer
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.all(16), // optional
                      child: Padding(
                        padding: const EdgeInsets.all(24), // space inside the card
                        child: Text(
                          "Happy\nBirthday\n Abas",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.comicNeue(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: countdownAsync.when(
                        data: (duration) => Text(
                          formatDuration(duration),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.comicNeue(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        loading: () => CircularProgressIndicator(),
                        error: (e, _) => Text('Error'),
                      ),
                    ),
                    Spacer(),
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildNavButton(Icons.favorite, "Birthday\nCard", const BirthdayCardScreen()),
                          _buildNavButton(Icons.photo, "Memory\nGallery", const MemoryGalleryScreen()),
                          _buildNavButton(Icons.card_giftcard, "Gift\nList", const GiftScreen()),
                          _buildNavButton(Icons.mail, "Surprise\nMessages", const SurpriseMessagesScreen()),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label, Widget destination) {
    return InkWell(
        onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => destination),
      );
    },
      child: Column(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.indigo, size: 30),
        ),
        SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.comicNeue(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
      )
    );
  }
}
