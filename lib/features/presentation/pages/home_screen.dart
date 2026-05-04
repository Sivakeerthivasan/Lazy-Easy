import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_easy/core/app_theme.dart';
import 'package:lazy_easy/features/presentation/pages/tabs/collab_tab.dart';
import 'package:lazy_easy/features/presentation/pages/tabs/home_tab.dart';
import 'package:lazy_easy/features/presentation/pages/tabs/streaks_tab.dart';
import 'package:lazy_easy/features/presentation/pages/tabs/history_tab.dart';
import 'package:lazy_easy/features/presentation/pages/tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;

  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnim;

  static const _titles = ['Home', 'Collab', 'Streaks', 'History', 'Profile'];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1.0,
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _bounceAnim = Tween<double>(begin: 0.0, end: -12.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _onTabTapped(int index) async {
    if (index == _currentIndex) return;
    await _fadeController.reverse();
    if (mounted) setState(() => _currentIndex = index);
    _fadeController.forward();
  }

  Widget _buildTab() {
    switch (_currentIndex) {
      case 0:
        return const HomeTab();
      case 1:
        return const CollabTab();
      case 2:
        return const StreaksTab();
      case 3:
        return const HistoryTab();
      case 4:
        return const ProfileTab();
      default:
        return const HomeTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isSmall = mq.size.width < 400;

    return Scaffold(
      extendBody: true, // Important for the notch to show the background
      floatingActionButton: AnimatedBuilder(
        animation: _bounceAnim,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bounceAnim.value),
            child: GestureDetector(
              onTap: () => _onTabTapped(2),
              child: Container(
                height: 72,
                width: 72,
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
                      color: AppTheme.primaryColor.withValues(alpha: 0.5),
                      blurRadius: 25,
                      spreadRadius: 3,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        color: const Color(0xFF160028),
        elevation: 0,
        padding: EdgeInsets.zero,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Left Icons
            Row(
              children: [
                _NavButton(
                  icon: Icons.home_rounded,
                  isSelected: _currentIndex == 0,
                  onTap: () => _onTabTapped(0),
                ),
                _NavButton(
                  icon: Icons.run_circle,
                  isSelected: _currentIndex == 1,
                  onTap: () => _onTabTapped(1),
                ),
                SizedBox(width: mq.size.width * 0.05),
              ],
            ),
            // Middle Gap for FAB
            const SizedBox(width: 80),
            // Right Icons
            Row(
              children: [
                SizedBox(width: mq.size.width * 0.05),
                _NavButton(
                  icon: Icons.history_rounded,
                  isSelected: _currentIndex == 3,
                  onTap: () => _onTabTapped(3),
                ),
                _NavButton(
                  icon: Icons.person_rounded,
                  isSelected: _currentIndex == 4,
                  onTap: () => _onTabTapped(4),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── App Bar ───────────────────────────────────────────────
              _AppBar(title: _titles[_currentIndex], isSmall: isSmall),

              // ── Tab content ───────────────────────────────────────────
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: KeyedSubtree(
                    key: ValueKey(_currentIndex),
                    child: _buildTab(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 32,
        color: isSelected
            ? AppTheme.primaryColor
            : AppTheme.textMuted.withValues(alpha: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      constraints: const BoxConstraints(),
      splashRadius: 28,
    );
  }
}

// ── App bar ─────────────────────────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final String title;
  final bool isSmall;
  const _AppBar({required this.title, required this.isSmall});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 16 : 20,
        vertical: 14,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.primaryDark],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.35),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(
              Icons.bolt_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Lazy Easy',
            style: GoogleFonts.poppins(
              fontSize: isSmall ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.onPrimary,
            ),
          ),
          const Spacer(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Container(
              key: ValueKey(title),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppTheme.primaryColor.withValues(alpha: 0.15),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.pushNamed('notifications'),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppTheme.cardDark.withValues(alpha: 0.6),
                border: Border.all(
                  color: AppTheme.secondary.withValues(alpha: 0.2),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    color: AppTheme.secondary,
                    size: 20,
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFF5252),
                        border: Border.all(
                          color: AppTheme.backgroundDark,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
