import 'package:flutter/material.dart';
import 'package:lazy_easy/core/app_theme.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with TickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final AnimationController _glowController;
  late final AnimationController _tapController;

  late final Animation<double> _bounceAnim;
  late final Animation<double> _glowAnim;
  late final Animation<double> _tapScaleAnim;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..repeat(reverse: true);

    _bounceAnim = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(begin: 0.25, end: 0.65).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _tapScaleAnim = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _glowController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  Future<void> _onCenterTap() async {
    await _tapController.forward();
    await _tapController.reverse();
    widget.onTap(1);
  }

  @override
  Widget build(BuildContext context) {
    // Returns just the nav bar itself — Positioned wrapper is in HomeScreen
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // ── Main bar ──────────────────────────────────────────────────
        Container(
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: const Color(0xFF160028),
            border: Border.all(
              color: AppTheme.secondary.withValues(alpha: 0.18),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.30),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Home
              _NavIcon(
                icon: Icons.home_rounded,
                isSelected: widget.currentIndex == 0,
                onTap: () => widget.onTap(0),
              ),

              // Left gap for center button
              const SizedBox(width: 56),

              // History
              _NavIcon(
                icon: Icons.history_rounded,
                isSelected: widget.currentIndex == 2,
                onTap: () => widget.onTap(2),
              ),

              // Profile
              _NavIcon(
                icon: Icons.person_rounded,
                isSelected: widget.currentIndex == 3,
                onTap: () => widget.onTap(3),
              ),
            ],
          ),
        ),

        // ── Center Streaks button ─────────────────────────────────────
        Positioned(
          top: -24,
          child: AnimatedBuilder(
            animation: Listenable.merge([_bounceController, _glowController]),
            builder: (context, child) {
              final isStreaks = widget.currentIndex == 1;
              final bounce = isStreaks ? _bounceAnim.value * 0.6 : _bounceAnim.value;
              return Transform.translate(
                offset: Offset(0, bounce),
                child: GestureDetector(
                  onTap: _onCenterTap,
                  child: AnimatedBuilder(
                    animation: _tapController,
                    builder: (_, child) => Transform.scale(
                      scale: _tapScaleAnim.value,
                      child: child,
                    ),
                    child: Container(
                      width: 64,
                      height: 64,
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
                              alpha: isStreaks ? 0.85 : _glowAnim.value,
                            ),
                            blurRadius: isStreaks ? 32 : 22,
                            spreadRadius: isStreaks ? 5 : 2,
                          ),
                          BoxShadow(
                            color: AppTheme.secondary.withValues(
                              alpha: isStreaks ? 0.45 : 0.2,
                            ),
                            blurRadius: isStreaks ? 48 : 32,
                            spreadRadius: isStreaks ? 8 : 2,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            icon,
            size: 30,
            color: isSelected ? AppTheme.primaryColor : AppTheme.textMuted,
          ),
        ),
      ),
    );
  }
}
