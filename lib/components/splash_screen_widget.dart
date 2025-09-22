import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:webradio_parque_verde/constants.dart';

// imports locais
import '../pages/radio_player_page.dart';

class AnimatedSplashScreenWidget extends StatelessWidget {
  const AnimatedSplashScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedSplashScreen(
      splash: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/animation/animated_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            SizedBox(
              height: screenHeight / 3,
              child: Center(
                child: Lottie.asset(
                  'assets/animation/Walk_Cycle.json',
                  height: 200,
                  fit: BoxFit.contain,
                ), // Lottie
              ),
            ),
            Image.asset(
              'assets/brandingimage.png',
              height: 80,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),

      nextScreen: RadioPlayerPage(),
      splashIconSize: double.infinity,
      duration: 3000,
      backgroundColor: kColor3,
    );
  }
}
