import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_easy/core/app_theme.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 400;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 16 : 20,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Filter chips ──────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Completed', 'Skipped', 'Pending']
                  .asMap()
                  .entries
                  .map(
                    (e) => Padding(
                      padding: EdgeInsets.only(
                        right: 10,
                        left: e.key == 0 ? 0 : 0,
                      ),
                      child: _FilterChip(
                        label: e.value,
                        selected: e.key == 0,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 24),

          // ── History groups ─────────────────────────────────────────────
          ..._buildGroups(isSmall),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  List<Widget> _buildGroups(bool isSmall) {
    final groups = [
      _HistoryGroup(
        date: 'Today',
        items: [
          _HistoryItem(
            'Morning meditation',
            '10:00 AM',
            Icons.self_improvement_rounded,
            const Color(0xFFAB47BC),
            _Status.completed,
          ),
          _HistoryItem(
            'Journaling',
            '10:30 AM',
            Icons.edit_note_rounded,
            const Color(0xFF66BB6A),
            _Status.completed,
          ),
          _HistoryItem(
            'Exercise',
            '6:00 PM',
            Icons.fitness_center_rounded,
            const Color(0xFFFF7043),
            _Status.pending,
          ),
        ],
      ),
      _HistoryGroup(
        date: 'Yesterday',
        items: [
          _HistoryItem(
            'Read 20 pages',
            '8:00 PM',
            Icons.menu_book_rounded,
            const Color(0xFF42A5F5),
            _Status.completed,
          ),
          _HistoryItem(
            'Evening walk',
            '7:00 PM',
            Icons.directions_walk_rounded,
            const Color(0xFF66BB6A),
            _Status.completed,
          ),
          _HistoryItem(
            'Cold shower',
            '7:00 AM',
            Icons.water_drop_rounded,
            const Color(0xFF29B6F6),
            _Status.skipped,
          ),
        ],
      ),
      _HistoryGroup(
        date: 'Tuesday',
        items: [
          _HistoryItem(
            'Morning meditation',
            '9:00 AM',
            Icons.self_improvement_rounded,
            const Color(0xFFAB47BC),
            _Status.completed,
          ),
          _HistoryItem(
            'Read 20 pages',
            '8:30 PM',
            Icons.menu_book_rounded,
            const Color(0xFF42A5F5),
            _Status.completed,
          ),
        ],
      ),
    ];

    return groups.map((g) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: _HistoryGroupWidget(group: g, isSmall: isSmall),
      );
    }).toList();
  }
}

enum _Status { completed, skipped, pending }

class _HistoryItem {
  final String title;
  final String time;
  final IconData icon;
  final Color color;
  final _Status status;
  _HistoryItem(this.title, this.time, this.icon, this.color, this.status);
}

class _HistoryGroup {
  final String date;
  final List<_HistoryItem> items;
  _HistoryGroup({required this.date, required this.items});
}

class _HistoryGroupWidget extends StatelessWidget {
  final _HistoryGroup group;
  final bool isSmall;
  const _HistoryGroupWidget({required this.group, required this.isSmall});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.date,
          style: GoogleFonts.poppins(
            fontSize: isSmall ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.secondary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppTheme.cardDark,
            border: Border.all(
              color: AppTheme.secondary.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            children: group.items
                .asMap()
                .entries
                .map(
                  (e) => Column(
                    children: [
                      _HistoryItemWidget(item: e.value, isSmall: isSmall),
                      if (e.key < group.items.length - 1)
                        Divider(
                          height: 1,
                          color: AppTheme.secondary.withValues(alpha: 0.08),
                          indent: 70,
                        ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _HistoryItemWidget extends StatelessWidget {
  final _HistoryItem item;
  final bool isSmall;
  const _HistoryItemWidget({required this.item, required this.isSmall});

  @override
  Widget build(BuildContext context) {
    final statusColor = item.status == _Status.completed
        ? const Color(0xFF66BB6A)
        : item.status == _Status.skipped
            ? const Color(0xFFFF5252)
            : AppTheme.textMuted;

    final statusLabel = item.status == _Status.completed
        ? 'Done'
        : item.status == _Status.skipped
            ? 'Skipped'
            : 'Pending';

    final statusIcon = item.status == _Status.completed
        ? Icons.check_circle_rounded
        : item.status == _Status.skipped
            ? Icons.cancel_rounded
            : Icons.radio_button_unchecked_rounded;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: item.color.withValues(alpha: 0.15),
            ),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: isSmall ? 13 : 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.time,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(statusIcon, color: statusColor, size: 16),
              const SizedBox(width: 4),
              Text(
                statusLabel,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _FilterChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: selected ? AppTheme.buttonGradient : null,
        color: selected ? null : AppTheme.cardDark,
        border: Border.all(
          color: selected
              ? AppTheme.primaryColor
              : AppTheme.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected ? Colors.white : AppTheme.textMuted,
        ),
      ),
    );
  }
}
