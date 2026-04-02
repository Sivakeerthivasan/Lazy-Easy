import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_easy/core/app_theme.dart';

class CollabTab extends StatefulWidget {
  const CollabTab({super.key});

  @override
  State<CollabTab> createState() => _CollabTabState();
}

class _CollabTabState extends State<CollabTab> {
  // Mock data for friends
  final List<Map<String, dynamic>> friends = [
    {'name': 'Alex Johnson', 'streak': 24, 'isMe': false},
    {'name': 'You', 'streak': 12, 'isMe': true},
    {'name': 'Sarah Smith', 'streak': 8, 'isMe': false},
    {'name': 'Mike Chen', 'streak': 3, 'isMe': false},
  ];

  @override
  Widget build(BuildContext context) {
    // Sort by descending streak
    friends.sort((a, b) => b['streak'].compareTo(a['streak']));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Leaderboard',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppTheme.onPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Compare your streak with friends!',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 32),

            // Top 3 Podium
            _buildPodium(),

            const SizedBox(height: 40),

            // List of all friends
            Text(
              'All Friends',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.onPrimary,
              ),
            ),
            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return _buildFriendCard(friend, index + 1);
              },
            ),
            const SizedBox(height: 100), // space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildPodium() {
    if (friends.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          final rank = index + 1;

          double height = 90;
          if (rank == 1)
            height = 160;
          else if (rank == 2)
            height = 130;
          else if (rank == 3)
            height = 110;

          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildPodiumItem(friend, rank, height),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPodiumItem(
    Map<String, dynamic> friend,
    int rank,
    double height,
  ) {
    final isMe = friend['isMe'];
    final color = rank == 1
        ? const Color(0xFFFFD700)
        : rank == 2
        ? const Color(0xFFC0C0C0)
        : rank == 3
        ? const Color(0xFFCD7F32)
        : AppTheme.primaryColor;

    return Column(
      children: [
        Text(
          friend['name'].split(' ')[0],
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isMe ? FontWeight.w700 : FontWeight.w500,
            color: isMe ? AppTheme.primaryColor : AppTheme.textLight,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withValues(alpha: 0.8),
                color.withValues(alpha: 0.2),
              ],
            ),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                '#$rank',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${friend['streak']} 🔥',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFriendCard(Map<String, dynamic> friend, int rank) {
    final isMe = friend['isMe'];
    final streak = friend['streak'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isMe
            ? AppTheme.primaryColor.withValues(alpha: 0.15)
            : AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMe
              ? AppTheme.primaryColor.withValues(alpha: 0.5)
              : AppTheme.secondary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Text(
            '#$rank',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: isMe ? FontWeight.w700 : FontWeight.w600,
                    color: AppTheme.onPrimary,
                  ),
                ),
                Text(
                  isMe ? 'Keep going!' : 'Catch up to them!',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                '$streak',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onPrimary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFFF9800),
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
