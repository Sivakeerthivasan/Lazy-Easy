import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_easy/core/app_theme.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 16 : 20,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Greeting card ─────────────────────────────────────────────
          _GlassCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning! 👋',
                        style: GoogleFonts.poppins(
                          fontSize: isSmall ? 13 : 14,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Let\'s stay lazy\n& productive!',
                        style: GoogleFonts.poppins(
                          fontSize: isSmall ? 18 : 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onPrimary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.primaryDark],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Stats row ──────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: const Color(0xFFFF6D00),
                  value: '12',
                  label: 'Day Streak',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle_rounded,
                  iconColor: const Color(0xFF00E676),
                  value: '87',
                  label: 'Tasks Done',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.star_rounded,
                  iconColor: const Color(0xFFFFD600),
                  value: '4.9',
                  label: 'Score',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Section title ──────────────────────────────────────────────
          Text(
            'Today\'s Tasks',
            style: GoogleFonts.poppins(
              fontSize: isSmall ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.onPrimary,
            ),
          ),

          const SizedBox(height: 12),

          // ── Task cards ─────────────────────────────────────────────────
          ..._buildTaskList(isSmall),

          const SizedBox(height: 100), // bottom nav clearance
        ],
      ),
    );
  }

  List<Widget> _buildTaskList(bool isSmall) {
    final tasks = [
      _TaskData('Morning meditation', '10 min', Icons.self_improvement_rounded,
          const Color(0xFFAB47BC), true),
      _TaskData('Read 20 pages', '20 min', Icons.menu_book_rounded,
          const Color(0xFF42A5F5), false),
      _TaskData('Exercise', '30 min', Icons.fitness_center_rounded,
          const Color(0xFFFF7043), false),
      _TaskData('Journal entry', '15 min', Icons.edit_note_rounded,
          const Color(0xFF66BB6A), false),
    ];

    return tasks
        .map(
          (t) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TaskCard(task: t, isSmall: isSmall),
          ),
        )
        .toList();
  }
}

class _TaskData {
  final String title;
  final String duration;
  final IconData icon;
  final Color color;
  final bool done;
  _TaskData(this.title, this.duration, this.icon, this.color, this.done);
}

class _TaskCard extends StatelessWidget {
  final _TaskData task;
  final bool isSmall;
  const _TaskCard({required this.task, required this.isSmall});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.cardDark,
        border: Border.all(
          color: task.done
              ? task.color.withValues(alpha: 0.4)
              : AppTheme.secondary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: task.color.withValues(alpha: 0.15),
            ),
            child: Icon(task.icon, color: task.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.poppins(
                    fontSize: isSmall ? 13 : 14,
                    fontWeight: FontWeight.w500,
                    color: task.done
                        ? AppTheme.textMuted
                        : AppTheme.onPrimary,
                    decoration: task.done
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  task.duration,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: task.done
                  ? task.color.withValues(alpha: 0.2)
                  : Colors.transparent,
              border: Border.all(
                color: task.done
                    ? task.color
                    : AppTheme.secondary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: task.done
                ? Icon(Icons.check, size: 14, color: task.color)
                : null,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.cardDark,
        border: Border.all(
          color: AppTheme.secondary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 26),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
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
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.15),
            AppTheme.cardDark.withValues(alpha: 0.6),
          ],
        ),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.25),
        ),
      ),
      child: child,
    );
  }
}
