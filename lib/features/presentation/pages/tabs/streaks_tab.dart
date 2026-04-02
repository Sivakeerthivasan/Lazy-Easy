import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_easy/core/app_theme.dart';

class StreaksTab extends StatefulWidget {
  const StreaksTab({super.key});

  @override
  State<StreaksTab> createState() => _StreaksTabState();
}

class _StreaksTabState extends State<StreaksTab> with TickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final AnimationController _orbitController;
  late final AnimationController _pulseController;
  late final AnimationController _shimmerController;

  late final Animation<double> _bounceAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // Bouncing bolt icon
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _bounceAnim = Tween<double>(begin: 0, end: -18).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Orbit animation
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // Pulse ring
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Shimmer
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _orbitController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;
    final orbitRadius = size.width * 0.22;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 24),

          // ── Hero animation area ──────────────────────────────────────
          // ── Hero animation area ──────────────────────────────────────
          SizedBox(
            height: 300, // Fixed height instead of size.height * 0.36 to be more robust
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outermost glow
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final scale = 1.0 + _pulseController.value * 0.15;
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: orbitRadius * 2.6,
                        height: orbitRadius * 2.6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.primaryColor.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Orbit ring
                Container(
                  width: orbitRadius * 2.2,
                  height: orbitRadius * 2.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.secondary.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                ),

                // Inner ring
                Container(
                  width: orbitRadius * 1.5,
                  height: orbitRadius * 1.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.15),
                    ),
                  ),
                ),

                // Orbiting dots
                AnimatedBuilder(
                  animation: _orbitController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: List.generate(6, (i) {
                        final angle = 2 * pi * i / 6 + _orbitController.value * 2 * pi;
                        final dx = orbitRadius * 1.1 * cos(angle);
                        final dy = orbitRadius * 1.1 * sin(angle);
                        return Transform.translate(
                          offset: Offset(dx, dy),
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i % 2 == 0 ? AppTheme.primaryColor : AppTheme.secondary,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.6),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),

                // Central bouncing bolt
                AnimatedBuilder(
                  animation: _bounceController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _bounceAnim.value),
                      child: Transform.scale(
                        scale: _scaleAnim.value,
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
                                color: AppTheme.primaryColor.withValues(alpha: 0.6),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                              BoxShadow(
                                color: AppTheme.secondary.withValues(alpha: 0.3),
                                blurRadius: 60,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.bolt_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Shadow squish (bottom)
                AnimatedBuilder(
                  animation: _bounceController,
                  builder: (context, child) {
                    final shadowScale = 1.0 - (_bounceAnim.value.abs() / 18) * 0.4;
                    return Positioned(
                      bottom: 40,
                      child: Transform.scale(
                        scaleX: shadowScale,
                        child: Container(
                          width: 60,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppTheme.primaryColor.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),


          // ── Shimmer title ─────────────────────────────────────────────
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
                      (_shimmerController.value - 0.2).clamp(0.0, 1.0),
                      _shimmerController.value.clamp(0.0, 1.0),
                      (_shimmerController.value + 0.2).clamp(0.0, 1.0),
                      1.0,
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  '12 Day Streak! 🔥',
                  style: GoogleFonts.poppins(
                    fontSize: isSmall ? 22 : 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          Text(
            'Keep it up! You\'re on fire.',
            style: GoogleFonts.poppins(
              fontSize: isSmall ? 13 : 15,
              color: AppTheme.textMuted,
            ),
          ),

          const SizedBox(height: 28),

          // ── Weekly calendar ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _WeeklyCalendar(),
          ),

          const SizedBox(height: 24),

          // ── Streak stats ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _StreakStatsRow(isSmall: isSmall),
          ),

          const SizedBox(height: 24),

          // ── Milestones ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Milestones',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                _MilestoneItem(days: 7, label: 'One Week', done: true),
                const SizedBox(height: 10),
                _MilestoneItem(days: 14, label: 'Two Weeks', done: false),
                const SizedBox(height: 10),
                _MilestoneItem(days: 30, label: 'One Month', done: false),
              ],
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _WeeklyCalendar extends StatelessWidget {
  final List<String> days = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<bool> done = const [true, true, true, true, true, true, false];

  const _WeeklyCalendar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppTheme.cardDark,
        border: Border.all(color: AppTheme.secondary.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (i) {
          return Column(
            children: [
              Text(
                days[i],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: done[i]
                      ? const LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.primaryDark,
                          ],
                        )
                      : null,
                  color: done[i] ? null : AppTheme.backgroundDark,
                  border: done[i]
                      ? null
                      : Border.all(
                          color: AppTheme.secondary.withValues(alpha: 0.2),
                        ),
                ),
                child: done[i]
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : Center(
                        child: Text(
                          '${i + 1}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _StreakStatsRow extends StatelessWidget {
  final bool isSmall;
  const _StreakStatsRow({required this.isSmall});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StreakStat(label: 'Current', value: '12', icon: '🔥'),
        const SizedBox(width: 10),
        _StreakStat(label: 'Longest', value: '21', icon: '⚡'),
        const SizedBox(width: 10),
        _StreakStat(label: 'Total Days', value: '47', icon: '🏆'),
      ],
    );
  }
}

class _StreakStat extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  const _StreakStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.cardDark,
          border:
              Border.all(color: AppTheme.secondary.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.onPrimary,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: AppTheme.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MilestoneItem extends StatelessWidget {
  final int days;
  final String label;
  final bool done;
  const _MilestoneItem({
    required this.days,
    required this.label,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppTheme.cardDark,
        border: Border.all(
          color: done
              ? AppTheme.primaryColor.withValues(alpha: 0.4)
              : AppTheme.secondary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done
                  ? AppTheme.primaryColor.withValues(alpha: 0.2)
                  : AppTheme.backgroundDark,
            ),
            child: Center(
              child: Text(
                '$days',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: done ? AppTheme.primaryColor : AppTheme.textMuted,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: done ? AppTheme.onPrimary : AppTheme.textMuted,
                  ),
                ),
                Text(
                  '$days consecutive days',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            done
                ? Icons.emoji_events_rounded
                : Icons.lock_outline_rounded,
            color: done ? const Color(0xFFFFD600) : AppTheme.textMuted,
            size: 22,
          ),
        ],
      ),
    );
  }
}
