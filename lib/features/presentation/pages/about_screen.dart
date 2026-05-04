import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_easy/core/app_theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin {
  late final AnimationController _staggerController;
  late final AnimationController _pulseController;
  late final AnimationController _shimmerController;

  late final Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Animation<double> _fade(int index) {
    final start = (index * 0.08).clamp(0.0, 0.7);
    final end = (start + 0.3).clamp(0.0, 1.0);
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: Interval(start, end, curve: Curves.easeIn),
      ),
    );
  }

  Animation<double> _slide(int index) {
    final start = (index * 0.08).clamp(0.0, 0.7);
    final end = (start + 0.3).clamp(0.0, 1.0);
    return Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  Widget _animated(int index, Widget child) {
    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, _slide(index).value),
          child: Opacity(opacity: _fade(index).value, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 400;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────
              _animated(
                0,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmall ? 16 : 20,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppTheme.cardDark.withValues(alpha: 0.6),
                            border: Border.all(
                              color: AppTheme.secondary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppTheme.secondary,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'About',
                        style: GoogleFonts.poppins(
                          fontSize: isSmall ? 20 : 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Content ─────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmall ? 16 : 20,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // ── Logo ────────────────────────────────────────
                      _animated(
                        1,
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseScale.value,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.secondary,
                                  AppTheme.primaryColor,
                                  AppTheme.primaryDark,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.5,
                                  ),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.bolt_rounded,
                              color: Colors.white,
                              size: 52,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── App name shimmer ────────────────────────────
                      _animated(
                        2,
                        AnimatedBuilder(
                          animation: _shimmerController,
                          builder: (context, _) {
                            return ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: const [
                                    AppTheme.textMuted,
                                    Colors.white,
                                    AppTheme.secondary,
                                    Colors.white,
                                    AppTheme.textMuted,
                                  ],
                                  stops: [
                                    0.0,
                                    (_shimmerController.value - 0.2)
                                        .clamp(0.0, 1.0),
                                    _shimmerController.value,
                                    (_shimmerController.value + 0.2)
                                        .clamp(0.0, 1.0),
                                    1.0,
                                  ],
                                ).createShader(bounds);
                              },
                              child: Text(
                                'Lazy Easy',
                                style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 4),

                      _animated(
                        2,
                        Text(
                          'Do Less. Achieve More.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: AppTheme.textMuted,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      _animated(
                        2,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: AppTheme.buttonGradient,
                          ),
                          child: Text(
                            'v1.0.0',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── What is Lazy Easy ───────────────────────────
                      _animated(3, _buildSection(
                        icon: Icons.info_outline_rounded,
                        iconColor: AppTheme.primaryColor,
                        title: 'What is Lazy Easy?',
                        body: 'Lazy Easy is a habit-building app designed for '
                            'people who want to improve their lives without '
                            'overwhelming themselves. We believe that small, '
                            'consistent actions lead to extraordinary results. '
                            'Whether it\'s reading a few pages, meditating for '
                            '10 minutes, or just drinking enough water — every '
                            'little step counts.',
                      )),

                      const SizedBox(height: 14),

                      // ── Why Lazy Easy ───────────────────────────────
                      _animated(4, _buildSection(
                        icon: Icons.lightbulb_outline_rounded,
                        iconColor: const Color(0xFFFFD600),
                        title: 'Why Lazy Easy?',
                        body: 'Most productivity apps make you feel guilty for '
                            'not doing enough. Lazy Easy flips the script — we '
                            'celebrate what you DID do, no matter how small. '
                            'Built on the science of micro-habits, we help you '
                            'build momentum through gentle daily streaks rather '
                            'than punishing goals.',
                      )),

                      const SizedBox(height: 14),

                      // ── What it's for ───────────────────────────────
                      _animated(5, _buildSection(
                        icon: Icons.rocket_launch_rounded,
                        iconColor: const Color(0xFFFF7043),
                        title: 'What is it for?',
                        body: 'Track daily habits, build streaks, and compete '
                            'with friends on the leaderboard. Lazy Easy keeps '
                            'you accountable without the pressure. Perfect for '
                            'building routines in fitness, mindfulness, reading, '
                            'journaling, and more — one lazy step at a time.',
                      )),

                      const SizedBox(height: 14),

                      // ── Our Values ──────────────────────────────────
                      _animated(6, _buildValuesCard()),

                      const SizedBox(height: 24),

                      // ── Footer ──────────────────────────────────────
                      _animated(
                        7,
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Made with ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                                const Icon(
                                  Icons.favorite_rounded,
                                  color: Color(0xFFFF5252),
                                  size: 16,
                                ),
                                Text(
                                  ' by Keerthivasan',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '© 2026 Lazy Easy. All rights reserved.',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppTheme.textMuted.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String body,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppTheme.cardDark,
        border: Border.all(
          color: AppTheme.secondary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: iconColor.withValues(alpha: 0.15),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppTheme.textMuted,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValuesCard() {
    final values = [
      _Value(Icons.favorite_rounded, 'Compassion', 'Be kind to yourself',
          const Color(0xFFE91E63)),
      _Value(Icons.trending_up_rounded, 'Progress', 'Small steps matter',
          const Color(0xFF66BB6A)),
      _Value(Icons.groups_rounded, 'Community', 'Grow together',
          const Color(0xFF42A5F5)),
      _Value(Icons.auto_awesome_rounded, 'Simplicity', 'Keep it easy',
          AppTheme.secondary),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.12),
            AppTheme.cardDark,
          ],
        ),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Values',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.onPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ...values.map((v) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: v.color.withValues(alpha: 0.15),
                      ),
                      child: Icon(v.icon, color: v.color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v.title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onPrimary,
                          ),
                        ),
                        Text(
                          v.subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _Value {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  _Value(this.icon, this.title, this.subtitle, this.color);
}
