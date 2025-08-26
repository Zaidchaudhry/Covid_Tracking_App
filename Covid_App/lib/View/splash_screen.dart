import 'dart:async';
import 'package:covid_app/World_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SPLASH_SCREEN extends StatefulWidget {
  const SPLASH_SCREEN({super.key});

  @override
  State<SPLASH_SCREEN> createState() => _SPLASH_SCREENState();
}

class _SPLASH_SCREENState extends State<SPLASH_SCREEN>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  )..repeat();

  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  late final AnimationController _fadeController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..forward();

  late final AnimationController _slideController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..forward();

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 4),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WorldScreen()),
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset(0.0,0.0 ),
              end: FractionalOffset(1.0, 1.0),
              stops: [0.2,0.8,1.0],
              colors: [
                Color(0xFF000000), // Pure Black
                Color(0xFF0F2027), // Dark Greyish Cyan
                Color(0xFF031833), // Emerald Teal
              ]
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rotating + scaling logo
            AnimatedBuilder(
              animation: _rotationController,
              child: ScaleTransition(
                scale: Tween(begin: 0.9, end: 1.1).animate(
                  CurvedAnimation(
                    parent: _scaleController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: SizedBox(
                  height: 160,
                  width: 160,
                  child: const Image(
                    image: AssetImage('assets/Images/covid.png'),
                  ),
                ),
              ),
              builder: (BuildContext context, Widget? child) {
                return Transform.rotate(
                  angle: _rotationController.value * 2 * math.pi,
                  child: child,
                );
              },
            ),

            const SizedBox(height: 40),

            // Fade + Slide + Gradient Text
            SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: _fadeController,
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF00F260), Color(0xFF0575E6)], // Green to Blue
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    'Covid-19\nTracking App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.white, // Important (Shader applies here)
                      shadows: [
                        Shadow(
                          blurRadius: 12,
                          color: Colors.black54,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Dots Loading Animation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _scaleController,
                  builder: (context, child) {
                    double scale = (index == 0)
                        ? _scaleController.value
                        : (index == 1)
                        ? (1 - _scaleController.value)
                        : (_scaleController.value * 0.5 + 0.5);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        shape: BoxShape.circle,
                      ),
                      transform: Matrix4.identity()..scale(scale),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
