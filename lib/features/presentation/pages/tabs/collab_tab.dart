import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_easy/core/app_theme.dart';

class CollabTab extends StatefulWidget {
  const CollabTab({super.key});

  @override
  State<CollabTab> createState() => _CollabTabState();
}

class _CollabTabState extends State<CollabTab> with TickerProviderStateMixin {
  late final AnimationController _podiumController;
  late final AnimationController _shimmerController;
  late final AnimationController _crownController;
  late final AnimationController _glowController;
  late final AnimationController _listController;

  late final Animation<double> _podiumSlide;
  late final Animation<double> _podiumFade;
  late final Animation<double> _crownBounce;
  late final Animation<double> _crownScale;
  late final Animation<double> _glowPulse;

  final List<_LeaderUser> _users = [
    _LeaderUser('Alex Johnson', 24, false, const Color(0xFF42A5F5)),
    _LeaderUser('You', 12, true, AppTheme.primaryColor),
    _LeaderUser('Sarah Smith', 18, false, const Color(0xFFE91E63)),
    _LeaderUser('Mike Chen', 9, false, const Color(0xFF66BB6A)),
    _LeaderUser('Emma Davis', 7, false, const Color(0xFFFF9800)),
    _LeaderUser('Jake Wilson', 5, false, const Color(0xFFAB47BC)),
    _LeaderUser('Lily Brown', 3, false, const Color(0xFF26C6DA)),
  ];

  @override
  void initState() {
    super.initState();

    // Sort descending by streak
    _users.sort((a, b) => b.streak.compareTo(a.streak));

    // Podium entrance
    _podiumController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _podiumSlide = Tween<double>(begin: 80.0, end: 0.0).animate(
      CurvedAnimation(parent: _podiumController, curve: Curves.easeOutCubic),
    );
    _podiumFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _podiumController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Crown bounce
    _crownController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _crownBounce = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(parent: _crownController, curve: Curves.easeInOut),
    );
    _crownScale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _crownController, curve: Curves.easeInOut),
    );

    // Shimmer
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Glow pulse
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _glowPulse = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // List stagger
    _listController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + _users.length * 100),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    _podiumController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _crownController.repeat(reverse: true);
    _shimmerController.repeat();
    _glowController.repeat(reverse: true);
    await Future.delayed(const Duration(milliseconds: 200));
    _listController.forward();
  }

  @override
  void dispose() {
    _podiumController.dispose();
    _shimmerController.dispose();
    _crownController.dispose();
    _glowController.dispose();
    _listController.dispose();
    super.dispose();
  }

  Animation<double> _listItemFade(int index) {
    final start = (index * 0.1).clamp(0.0, 0.7);
    final end = (start + 0.3).clamp(0.0, 1.0);
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _listController,
        curve: Interval(start, end, curve: Curves.easeIn),
      ),
    );
  }

  Animation<double> _listItemSlide(int index) {
    final start = (index * 0.1).clamp(0.0, 0.7);
    final end = (start + 0.3).clamp(0.0, 1.0);
    return Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _listController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;

    // Top 3 for podium
    final top3 = _users.take(3).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 16 : 20,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Shimmer header ──────────────────────────────────────────
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
                      _shimmerController.value,
                      (_shimmerController.value + 0.2).clamp(0.0, 1.0),
                      1.0,
                    ],
                  ).createShader(bounds);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.emoji_events_rounded,
                      color: Colors.white,
                      size: isSmall ? 24 : 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Leaderboard',
                      style: GoogleFonts.poppins(
                        fontSize: isSmall ? 22 : 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            'Compete with friends & climb the ranks!',
            style: GoogleFonts.poppins(
              fontSize: isSmall ? 13 : 14,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 28),

          // ── Podium section ──────────────────────────────────────────
          AnimatedBuilder(
            animation: Listenable.merge([
              _podiumController,
              _crownController,
              _glowController,
            ]),
            builder: (context, _) {
              return Opacity(
                opacity: _podiumFade.value,
                child: Transform.translate(
                  offset: Offset(0, _podiumSlide.value),
                  child: _buildPodium(top3, isSmall),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // ── Your position card ──────────────────────────────────────
          AnimatedBuilder(
            animation: _listController,
            builder: (context, child) {
              final fade = _listItemFade(0);
              final slide = _listItemSlide(0);
              return Transform.translate(
                offset: Offset(0, slide.value),
                child: Opacity(
                  opacity: fade.value,
                  child: child,
                ),
              );
            },
            child: _buildYourPositionCard(isSmall),
          ),

          const SizedBox(height: 24),

          // ── Rankings header ─────────────────────────────────────────
          AnimatedBuilder(
            animation: _listController,
            builder: (context, child) {
              final fade = _listItemFade(1);
              return Opacity(opacity: fade.value, child: child);
            },
            child: Row(
              children: [
                Text(
                  'All Rankings',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppTheme.primaryColor.withValues(alpha: 0.15),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${_users.length} friends',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Ranking list ────────────────────────────────────────────
          AnimatedBuilder(
            animation: _listController,
            builder: (context, _) {
              return Column(
                children: List.generate(_users.length, (index) {
                  final user = _users[index];
                  final rank = index + 1;
                  final fade = _listItemFade(index + 2);
                  final slide = _listItemSlide(index + 2);

                  return Transform.translate(
                    offset: Offset(0, slide.value),
                    child: Opacity(
                      opacity: fade.value,
                      child: _RankCard(
                        user: user,
                        rank: rank,
                        maxStreak: _users.first.streak,
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildPodium(List<_LeaderUser> top3, bool isSmall) {
    if (top3.length < 3) return const SizedBox.shrink();

    return SizedBox(
      height: 320,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── 2nd place (Silver) ─────────────────────────────────────
          Expanded(
            child: _PodiumColumn(
              user: top3[1],
              rank: 2,
              pillarHeight: 100,
              medalColor: const Color(0xFFC0C0C0),
              medalIconData: Icons.workspace_premium_rounded,
              crownBounce: 0,
              crownScale: 1.0,
              glowAlpha: _glowPulse.value * 0.5,
            ),
          ),

          const SizedBox(width: 8),

          // ── 1st place (Gold) — tallest ─────────────────────────────
          Expanded(
            flex: 2,
            child: _PodiumColumn(
              user: top3[0],
              rank: 1,
              pillarHeight: 130,
              medalColor: const Color(0xFFFFD700),
              medalIconData: Icons.auto_awesome_rounded,
              crownBounce: _crownBounce.value,
              crownScale: _crownScale.value,
              glowAlpha: _glowPulse.value,
            ),
          ),

          const SizedBox(width: 8),

          // ── 3rd place (Bronze) ─────────────────────────────────────
          Expanded(
            child: _PodiumColumn(
              user: top3[2],
              rank: 3,
              pillarHeight: 80,
              medalColor: const Color(0xFFCD7F32),
              medalIconData: Icons.military_tech_rounded,
              crownBounce: 0,
              crownScale: 1.0,
              glowAlpha: _glowPulse.value * 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourPositionCard(bool isSmall) {
    final myIndex = _users.indexWhere((u) => u.isMe);
    if (myIndex == -1) return const SizedBox.shrink();
    final me = _users[myIndex];
    final rank = myIndex + 1;

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryColor.withValues(alpha: 0.2),
                AppTheme.primaryDark.withValues(alpha: 0.1),
                AppTheme.cardDark,
              ],
            ),
            border: Border.all(
              color: AppTheme.primaryColor.withValues(
                alpha: _glowPulse.value,
              ),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withValues(
                  alpha: _glowPulse.value * 0.3,
                ),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              // Rank badge
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.buttonGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.5),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '#$rank',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Position',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.secondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '${me.streak} day streak ',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.onPrimary,
                          ),
                        ),
                        const Icon(
                          Icons.local_fire_department_rounded,
                          color: Color(0xFFFF6D00),
                          size: 22,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Gap to next
              if (myIndex > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFFF6D00).withValues(alpha: 0.15),
                    border: Border.all(
                      color: const Color(0xFFFF6D00).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${_users[myIndex - 1].streak - me.streak}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFF6D00),
                        ),
                      ),
                      Text(
                        'to next',
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          color: const Color(0xFFFF6D00),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ── Leaderboard user model ────────────────────────────────────────────────────
class _LeaderUser {
  final String name;
  final int streak;
  final bool isMe;
  final Color color;
  _LeaderUser(this.name, this.streak, this.isMe, this.color);
}

// ── Podium column widget ──────────────────────────────────────────────────────
class _PodiumColumn extends StatelessWidget {
  final _LeaderUser user;
  final int rank;
  final double pillarHeight;
  final Color medalColor;
  final IconData medalIconData;
  final double crownBounce;
  final double crownScale;
  final double glowAlpha;

  const _PodiumColumn({
    required this.user,
    required this.rank,
    required this.pillarHeight,
    required this.medalColor,
    required this.medalIconData,
    required this.crownBounce,
    required this.crownScale,
    required this.glowAlpha,
  });

  @override
  Widget build(BuildContext context) {
    final isFirst = rank == 1;
    final avatarSize = isFirst ? 64.0 : 48.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Crown/medal icon
        Transform.translate(
          offset: Offset(0, crownBounce),
          child: Transform.scale(
            scale: crownScale,
            child: Icon(
              medalIconData,
              color: medalColor,
              size: isFirst ? 36 : 28,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Avatar
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                user.color,
                user.color.withValues(alpha: 0.6),
              ],
            ),
            border: Border.all(
              color: medalColor.withValues(alpha: 0.8),
              width: isFirst ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: user.color.withValues(alpha: glowAlpha),
                blurRadius: isFirst ? 20 : 12,
                spreadRadius: isFirst ? 3 : 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              user.name.substring(0, 1).toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: isFirst ? 26 : 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Name
        Text(
          user.isMe ? 'You' : user.name.split(' ')[0],
          style: GoogleFonts.poppins(
            fontSize: isFirst ? 14 : 12,
            fontWeight: user.isMe ? FontWeight.w700 : FontWeight.w600,
            color: user.isMe ? AppTheme.primaryColor : AppTheme.textLight,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),

        // Pillar
        Container(
          width: double.infinity,
          height: pillarHeight,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                medalColor.withValues(alpha: 0.7),
                medalColor.withValues(alpha: 0.2),
              ],
            ),
            border: Border.all(
              color: medalColor.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: medalColor.withValues(alpha: glowAlpha * 0.4),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '#$rank',
                style: GoogleFonts.poppins(
                  fontSize: isFirst ? 28 : 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${user.streak}',
                    style: GoogleFonts.poppins(
                      fontSize: isFirst ? 18 : 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.local_fire_department_rounded,
                    color: const Color(0xFFFF6D00),
                    size: isFirst ? 18 : 14,
                  ),
                ],
              ),
              if (isFirst) ...[
                const SizedBox(height: 4),
                Text(
                  'days',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ── Rank card widget ──────────────────────────────────────────────────────────
class _RankCard extends StatelessWidget {
  final _LeaderUser user;
  final int rank;
  final int maxStreak;

  const _RankCard({
    required this.user,
    required this.rank,
    required this.maxStreak,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = user.isMe;
    final progress = maxStreak > 0 ? user.streak / maxStreak : 0.0;

    final rankColors = {
      1: const Color(0xFFFFD700),
      2: const Color(0xFFC0C0C0),
      3: const Color(0xFFCD7F32),
    };
    final rankColor = rankColors[rank] ?? AppTheme.textMuted;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: isMe
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor.withValues(alpha: 0.15),
                  AppTheme.cardDark,
                ],
              )
            : null,
        color: isMe ? null : AppTheme.cardDark,
        border: Border.all(
          color: isMe
              ? AppTheme.primaryColor.withValues(alpha: 0.4)
              : AppTheme.secondary.withValues(alpha: 0.08),
          width: isMe ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Rank number
              SizedBox(
                width: 32,
                child: rank <= 3
                    ? Text(
                        '',  // replaced by icon below
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        '#$rank',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
              const SizedBox(width: 12),

              // Avatar
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      user.color,
                      user.color.withValues(alpha: 0.6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: user.color.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    user.name.substring(0, 1).toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name & subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: isMe ? FontWeight.w700 : FontWeight.w600,
                        color: isMe
                            ? AppTheme.primaryColor
                            : AppTheme.onPrimary,
                      ),
                    ),
                    Text(
                      isMe ? 'Keep pushing! 💪' : '${user.streak} day streak',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // Streak count
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: rank <= 3
                      ? rankColor.withValues(alpha: 0.15)
                      : AppTheme.cardDark,
                  border: Border.all(
                    color: rank <= 3
                        ? rankColor.withValues(alpha: 0.3)
                        : AppTheme.secondary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${user.streak}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: rank <= 3 ? rankColor : AppTheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: Color(0xFFFF6D00),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                // Background
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundDark.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                // Fill
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: LinearGradient(
                        colors: rank <= 3
                            ? [
                                rankColor.withValues(alpha: 0.8),
                                rankColor,
                              ]
                            : [
                                user.color.withValues(alpha: 0.6),
                                user.color,
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (rank <= 3 ? rankColor : user.color)
                              .withValues(alpha: 0.4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
