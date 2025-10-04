import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

// imports locais
import '/constants.dart';
import '/pages/radio_player_page.dart';

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
            image: AssetImage(kBackgroundImg),
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
                  kWalkCycleJson,
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
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.leftToRight,
      duration: 3000,
      backgroundColor: kColor3,
    );
  }
}
