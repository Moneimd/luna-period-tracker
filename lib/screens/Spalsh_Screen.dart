// lib/screens/splash_screen.dart

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trackpe/ads/src/multi_ads_factory.dart';
import 'package:trackpe/const.dart';
import '../utils/theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _particleController;
  late AnimationController _progressController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _taglineOpacity;
  late Animation<double> _progressValue;
  late Animation<double> _pulse;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    _textController.forward();
    _progressController.forward();

    // Initialize app (fetch config + ads)
    await _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      var url = Uri.parse(Constants.jsonConfigUrl);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data2 = json.decode(response.body);
        gAds = MultiAds(response.body);
        await gAds.init();
        await gAds.loadAds();

        isInterShowed = false;
        if (mounted) _goHome();
      } else {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          _showErrorSnackbar('You are offline');
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      print('Error initializing app: $e');
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _showErrorSnackbar(
          'Failed to load configuration. Please check your internet connection.',
        );
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () {
            setState(() => _isLoading = true);
            _initializeApp();
          },
        ),
      ),
    );
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _particleController.dispose();
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE4F0), Color(0xFFFFF0F5), Color(0xFFFFD6E8)],
          ),
        ),
        child: Stack(
          children: [
            // Floating particles
            AnimatedBuilder(
              animation: _particleController,
              builder: (_, __) => CustomPaint(
                size: size,
                painter: _ParticlePainter(_particleController.value),
              ),
            ),

            // Decorative circles
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primary.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -60,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryLight.withOpacity(0.12),
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo with pulse
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _logoController,
                      _pulseController,
                    ]),
                    builder: (_, __) => Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value * _pulse.value,
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppTheme.primary, AppTheme.primaryDark],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.4),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 52,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // App name + tagline
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (_, __) => FadeTransition(
                      opacity: _textOpacity,
                      child: SlideTransition(
                        position: _textSlide,
                        child: Column(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  AppTheme.primary,
                                  AppTheme.primaryDark,
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                'Luna Period Tracker',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            FadeTransition(
                              opacity: _taglineOpacity,
                              child: const Text(
                                'Votre cycle, votre rythme',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppTheme.textMedium,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom: progress or retry
            Positioned(
              bottom: 80,
              left: 60,
              right: 60,
              child: Column(
                children: [
                  if (_isLoading)
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (_, __) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _progressValue.value < 1.0
                              ? _progressValue.value
                              : null, // indeterminate while waiting for API
                          minHeight: 4,
                          backgroundColor: AppTheme.primary.withOpacity(0.15),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.primary,
                          ),
                        ),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _isLoading = true);
                        _progressController.reset();
                        _progressController.forward();
                        _initializeApp();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Version 2.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMedium.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Particle Painter ──────────────────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  final double progress;
  static final List<_Particle> _particles = List.generate(
    18,
    (i) => _Particle(
      x: (i * 73 % 100) / 100,
      y: (i * 47 % 100) / 100,
      radius: 3.0 + (i % 5) * 2.0,
      speed: 0.2 + (i % 4) * 0.15,
      phase: i * 0.35,
    ),
  );

  _ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final p in _particles) {
      final t = (progress * p.speed + p.phase) % 1.0;
      final dy = -t * size.height * 0.4;
      final dx = sin(t * pi * 2 + p.phase) * 20;
      final opacity = (sin(t * pi)).clamp(0.0, 1.0) * 0.35;
      paint.color = AppTheme.primary.withOpacity(opacity);
      canvas.drawCircle(
        Offset(p.x * size.width + dx, p.y * size.height + dy),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _Particle {
  final double x, y, radius, speed, phase;
  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.phase,
  });
}
