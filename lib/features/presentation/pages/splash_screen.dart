import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_easy/core/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _pulseController;
  late final AnimationController _fadeOutController;
  late final AnimationController _particleController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _fadeOutAnimation;
  late final Animation<double> _subtitleSlide;
  late final Animation<double> _subtitleFade;

  @override
  void initState() {
    super.initState();

    // ── Logo entrance: scale + fade ──────────────────────────────────────
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _subtitleSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    // ── Pulse loop ───────────────────────────────────────────────────────
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // ── Particle float ───────────────────────────────────────────────────
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // ── Fade-out before navigation ───────────────────────────────────────
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeInCubic),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 1600));
    _pulseController.repeat(reverse: true);

    await Future.delayed(const Duration(milliseconds: 1800));
    await _fadeOutController.forward();

    if (mounted) {
      context.goNamed('signIn');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    _fadeOutController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortSide = size.shortestSide;
    final logoFontSize = shortSide * 0.12;
    final subtitleFontSize = shortSide * 0.04;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeOutAnimation,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
          child: Stack(
            children: [
              // ── Floating particles ─────────────────────────────────────
              ...List.generate(20, (i) => _buildParticle(i, size)),

              // ── Glowing orbs ───────────────────────────────────────────
              Positioned(
                top: size.height * 0.15,
                left: -size.width * 0.2,
                child: _buildGlowOrb(size.width * 0.6, 0.08),
              ),
              Positioned(
                bottom: size.height * 0.1,
                right: -size.width * 0.15,
                child: _buildGlowOrb(size.width * 0.5, 0.06),
              ),

              // ── Logo & subtitle ────────────────────────────────────────
              Center(
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _logoController,
                    _pulseController,
                  ]),
                  builder: (context, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // App icon
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: child,
                                );
                              },
                              child: Container(
                                width: shortSide * 0.22,
                                height: shortSide * 0.22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppTheme.primaryColor,
                                      AppTheme.primaryDark,
                                      AppTheme.secondary,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryColor
                                          .withValues(alpha: 0.5),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.bolt_rounded,
                                  size: shortSide * 0.12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: shortSide * 0.06),

                        // App name
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: ShaderMask(
                              shaderCallback: (bounds) {
                                return const LinearGradient(
                                  colors: [
                                    Colors.white,
                                    AppTheme.secondary,
                                    Colors.white,
                                  ],
                                ).createShader(bounds);
                              },
                              child: Text(
                                'Lazy Easy',
                                style: GoogleFonts.poppins(
                                  fontSize: logoFontSize,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: shortSide * 0.02),

                        // Subtitle
                        AnimatedBuilder(
                          animation: _logoController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _subtitleFade.value,
                              child: Transform.translate(
                                offset: Offset(0, _subtitleSlide.value),
                                child: Text(
                                  'Do Less. Achieve More.',
                                  style: GoogleFonts.poppins(
                                    fontSize: subtitleFontSize,
                                    fontWeight: FontWeight.w300,
                                    color: AppTheme.textMuted,
                                    letterSpacing: 3,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticle(int index, Size size) {
    final random = Random(index);
    final startX = random.nextDouble() * size.width;
    final startY = random.nextDouble() * size.height;
    final particleSize = random.nextDouble() * 4 + 2;
    final opacity = random.nextDouble() * 0.3 + 0.1;

    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        final progress = (_particleController.value + index * 0.05) % 1.0;
        final dx = sin(progress * 2 * pi) * 20;
        final dy = -progress * size.height * 0.3;
        return Positioned(
          left: startX + dx,
          top: startY + dy,
          child: Opacity(
            opacity: opacity * (1 - progress),
            child: Container(
              width: particleSize,
              height: particleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondary,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.secondary.withValues(alpha: 0.5),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlowOrb(double diameter, double opacity) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppTheme.primaryColor.withValues(alpha: opacity),
            AppTheme.primaryColor.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
