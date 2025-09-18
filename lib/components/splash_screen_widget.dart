import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// imports locais
import '../pages/radio_player_page.dart';

class AnimatedSplashScreenWidget extends StatelessWidget {
  const AnimatedSplashScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background.jpg', fit: BoxFit.cover),
          Center(
            child: Lottie.asset(
              'assets/animation/Walk_Cycle.json',
              height: 200,
              width: 200,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Image.asset('assets/brandingimage.png', height: 80),
            ),
          ),
        ],
      ),

      nextScreen: RadioPlayerPage(),
      splashIconSize: double.infinity,
      duration: 3000,
    );
  }
}
