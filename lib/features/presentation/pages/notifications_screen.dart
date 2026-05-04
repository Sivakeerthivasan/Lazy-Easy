import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_easy/core/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _staggerController;
  late final AnimationController _headerController;
  late final Animation<double> _headerFade;
  late final Animation<double> _headerSlide;

  final List<_NotificationData> _notifications = [
    _NotificationData(
      name: 'Alex Johnson',
      message: 'Just completed a 24-day streak! 🔥 Can you beat that?',
      time: '2m ago',
      avatarColor: const Color(0xFF7C4DFF),
      avatarIcon: Icons.person_rounded,
      type: _NotifType.streak,
      isUnread: true,
    ),
    _NotificationData(
      name: 'Lazy Easy',
      message: 'You\'re on a 12-day streak! Keep the momentum going 💪',
      time: '15m ago',
      avatarColor: const Color(0xFFFF9800),
      avatarIcon: Icons.bolt_rounded,
      type: _NotifType.achievement,
      isUnread: true,
    ),
    _NotificationData(
      name: 'Sarah Smith',
      message: 'Started following you. Say hi! 👋',
      time: '1h ago',
      avatarColor: const Color(0xFFE91E63),
      avatarIcon: Icons.person_rounded,
      type: _NotifType.social,
      isUnread: true,
    ),
    _NotificationData(
      name: 'Daily Reminder',
      message: 'You have 3 tasks pending for today. Don\'t forget!',
      time: '2h ago',
      avatarColor: const Color(0xFF42A5F5),
      avatarIcon: Icons.notifications_active_rounded,
      type: _NotifType.reminder,
      isUnread: false,
    ),
    _NotificationData(
      name: 'Mike Chen',
      message: 'Challenged you to a 7-day meditation streak ⚡',
      time: '3h ago',
      avatarColor: const Color(0xFF66BB6A),
      avatarIcon: Icons.person_rounded,
      type: _NotifType.challenge,
      isUnread: false,
    ),
    _NotificationData(
      name: 'Lazy Easy',
      message: 'Milestone unlocked: One Week Warrior! 🏆',
      time: '5h ago',
      avatarColor: const Color(0xFFFFD600),
      avatarIcon: Icons.emoji_events_rounded,
      type: _NotifType.achievement,
      isUnread: false,
    ),
    _NotificationData(
      name: 'Weekly Report',
      message: 'Your weekly summary is ready. You completed 87% of tasks!',
      time: '1d ago',
      avatarColor: const Color(0xFFAB47BC),
      avatarIcon: Icons.bar_chart_rounded,
      type: _NotifType.report,
      isUnread: false,
    ),
    _NotificationData(
      name: 'Alex Johnson',
      message: 'Liked your streak progress 👍',
      time: '1d ago',
      avatarColor: const Color(0xFF7C4DFF),
      avatarIcon: Icons.person_rounded,
      type: _NotifType.social,
      isUnread: false,
    ),
    _NotificationData(
      name: 'Lazy Easy',
      message: 'New feature: Collab Leaderboard is now live! Check it out 🎉',
      time: '2d ago',
      avatarColor: const Color(0xFFFF7043),
      avatarIcon: Icons.campaign_rounded,
      type: _NotifType.update,
      isUnread: false,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeIn),
    );
    _headerSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
    );

    _staggerController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + _notifications.length * 80),
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  Animation<double> _itemFade(int index) {
    final start = (index * 0.08).clamp(0.0, 0.8);
    final end = (start + 0.3).clamp(0.0, 1.0);
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: Interval(start, end, curve: Curves.easeIn),
      ),
    );
  }

  Animation<double> _itemSlide(int index) {
    final start = (index * 0.08).clamp(0.0, 0.8);
    final end = (start + 0.3).clamp(0.0, 1.0);
    return Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    final unreadCount = _notifications.where((n) => n.isUnread).length;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────
              AnimatedBuilder(
                animation: _headerController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _headerSlide.value),
                    child: Opacity(
                      opacity: _headerFade.value,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmall ? 16 : 20,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      // Back button
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

                      // Title
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notifications',
                              style: GoogleFonts.poppins(
                                fontSize: isSmall ? 20 : 22,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.onPrimary,
                              ),
                            ),
                            if (unreadCount > 0)
                              Text(
                                '$unreadCount new notifications',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppTheme.secondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Mark all read
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            for (var n in _notifications) {
                              n.isUnread = false;
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.primaryColor.withValues(alpha: 0.15),
                            border: Border.all(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Text(
                            'Read all',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.secondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Notification list ───────────────────────────────────
              Expanded(
                child: AnimatedBuilder(
                  animation: _staggerController,
                  builder: (context, child) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmall ? 16 : 20,
                        vertical: 8,
                      ),
                      itemCount: _notifications.length + 1, // +1 for bottom spacer
                      itemBuilder: (context, index) {
                        if (index == _notifications.length) {
                          return const SizedBox(height: 40);
                        }

                        final notif = _notifications[index];
                        final fade = _itemFade(index);
                        final slide = _itemSlide(index);

                        return Transform.translate(
                          offset: Offset(0, slide.value),
                          child: Opacity(
                            opacity: fade.value,
                            child: _NotificationCard(
                              data: notif,
                              onTap: () {
                                setState(() => notif.isUnread = false);
                              },
                              onDismiss: () {
                                setState(() {
                                  _notifications.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
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
}

// ── Notification types ────────────────────────────────────────────────────────
enum _NotifType { streak, achievement, social, reminder, challenge, report, update }

// ── Notification data model ───────────────────────────────────────────────────
class _NotificationData {
  final String name;
  final String message;
  final String time;
  final Color avatarColor;
  final IconData avatarIcon;
  final _NotifType type;
  bool isUnread;

  _NotificationData({
    required this.name,
    required this.message,
    required this.time,
    required this.avatarColor,
    required this.avatarIcon,
    required this.type,
    required this.isUnread,
  });
}

// ── Notification card widget ──────────────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  final _NotificationData data;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.data,
    required this.onTap,
    required this.onDismiss,
  });

  IconData _typeIcon() {
    switch (data.type) {
      case _NotifType.streak:
        return Icons.local_fire_department_rounded;
      case _NotifType.achievement:
        return Icons.emoji_events_rounded;
      case _NotifType.social:
        return Icons.favorite_rounded;
      case _NotifType.reminder:
        return Icons.alarm_rounded;
      case _NotifType.challenge:
        return Icons.sports_martial_arts_rounded;
      case _NotifType.report:
        return Icons.bar_chart_rounded;
      case _NotifType.update:
        return Icons.campaign_rounded;
    }
  }

  Color _typeColor() {
    switch (data.type) {
      case _NotifType.streak:
        return const Color(0xFFFF6D00);
      case _NotifType.achievement:
        return const Color(0xFFFFD600);
      case _NotifType.social:
        return const Color(0xFFE91E63);
      case _NotifType.reminder:
        return const Color(0xFF42A5F5);
      case _NotifType.challenge:
        return const Color(0xFF66BB6A);
      case _NotifType.report:
        return const Color(0xFFAB47BC);
      case _NotifType.update:
        return const Color(0xFFFF7043);
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor();

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF5252), Color(0xFFD32F2F)],
          ),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: data.isUnread
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.12),
                      AppTheme.cardDark,
                    ],
                  )
                : null,
            color: data.isUnread ? null : AppTheme.cardDark,
            border: Border.all(
              color: data.isUnread
                  ? AppTheme.primaryColor.withValues(alpha: 0.3)
                  : AppTheme.secondary.withValues(alpha: 0.08),
              width: data.isUnread ? 1.5 : 1,
            ),
            boxShadow: data.isUnread
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar ──────────────────────────────────────────
              Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          data.avatarColor,
                          data.avatarColor.withValues(alpha: 0.6),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: data.avatarColor.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      data.avatarIcon,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  // Type badge
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.backgroundDark,
                        border: Border.all(
                          color: AppTheme.backgroundDark,
                          width: 2,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: typeColor.withValues(alpha: 0.2),
                        ),
                        child: Icon(
                          _typeIcon(),
                          size: 11,
                          color: typeColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 14),

              // ── Content ─────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data.name,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: data.isUnread
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: AppTheme.onPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (data.isUnread)
                          Container(
                            width: 9,
                            height: 9,
                            margin: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.6,
                                  ),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Message
                    Text(
                      data.message,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: data.isUnread
                            ? AppTheme.textLight.withValues(alpha: 0.85)
                            : AppTheme.textMuted,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Time
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: data.isUnread
                              ? AppTheme.secondary
                              : AppTheme.textMuted.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data.time,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: data.isUnread
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: data.isUnread
                                ? AppTheme.secondary
                                : AppTheme.textMuted.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
