import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
    _scale    = Tween(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0, .4, curve: Curves.elasticOut)));
    _fade     = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(.2, .6, curve: Curves.easeOut)));
    _progress = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(.4, 1.0, curve: Curves.easeInOut)));
    _ctrl.forward();
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacementNamed('/language');
      }
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0F), Color(0xFF1A0A20)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Column(mainAxisSize: MainAxisSize.min, children: [
              // Logo
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    gradient: TM.primaryGrad,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(color: TM.primary.withOpacity(.4), blurRadius: 40),
                      BoxShadow(color: TM.primary.withOpacity(.15), blurRadius: 80),
                    ],
                  ),
                  child: const Center(child: Text('🛒', style: TextStyle(fontSize: 44))),
                ),
              ),
              const SizedBox(height: 20),
              // Title
              FadeTransition(
                opacity: _fade,
                child: Column(children: [
                  RichText(text: const TextSpan(children: [
                    TextSpan(text: 'Twende\n', style: TextStyle(
                      fontSize: 34, fontWeight: FontWeight.w800, color: TM.text,
                      height: 1.1, fontFamily: 'PlusJakartaSans')),
                    TextSpan(text: 'Markiti', style: TextStyle(
                      fontSize: 34, fontWeight: FontWeight.w800, color: TM.primary,
                      fontFamily: 'PlusJakartaSans')),
                  ]), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const Text('Soko Lako la Mtandaoni',
                    style: TextStyle(fontSize: 14, color: TM.text2)),
                ]),
              ),
              const SizedBox(height: 40),
              // Progress bar
              FadeTransition(
                opacity: _fade,
                child: SizedBox(
                  width: 48,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: _progress.value,
                      backgroundColor: Colors.white.withOpacity(.1),
                      color: TM.primary, minHeight: 3),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
