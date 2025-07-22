import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/providers/pin_provider.dart';
import 'package:handycraft_app/screens/pin_screen.dart';
import 'package:handycraft_app/widgets/navbottom.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await ref.read(pinProvider.notifier).loadSettings();
    _startProgressAnimation();
    _navigateToAppropriateScreen();
  }

  void _startProgressAnimation() {
    const totalDuration = Duration(seconds: 3);
    const frameRate = Duration(milliseconds: 30);
    final totalFrames =
        totalDuration.inMilliseconds ~/ frameRate.inMilliseconds;

    var frameCount = 0;
    _progressValue = 0.0;

    void updateProgress() {
      if (mounted) {
        setState(() {
          frameCount++;
          _progressValue = frameCount / totalFrames;
        });

        if (frameCount < totalFrames) {
          Future.delayed(frameRate, updateProgress);
        }
      }
    }

    Future.delayed(frameRate, updateProgress);
  }

  Future<void> _navigateToAppropriateScreen() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    final pinState = ref.read(pinProvider);

    if (pinState.isPinEnabled) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const PinScreen()));
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = const Color(0xFFFF9800);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'app-logo',
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/logo-app.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 500),
              style: theme.textTheme.headlineMedium!.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: const Text('Rahmad HandyCraft App'),
            ),
            const SizedBox(height: 10),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 1000),
              opacity: 1,
              child: Text(
                'Keuangan UMKM Pengrajin Kayu',
                style: theme.textTheme.titleMedium!.copyWith(
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: _progressValue,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${(_progressValue * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
