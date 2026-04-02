import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_easy/core/app_theme.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

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
        children: [
          // ── Avatar & name card ─────────────────────────────────────────
          _ProfileHeader(isSmall: isSmall),

          const SizedBox(height: 20),

          // ── Stats row ──────────────────────────────────────────────────
          Row(
            children: [
              _ProfileStat(value: '12', label: 'Streak'),
              _Divider(),
              _ProfileStat(value: '87', label: 'Done'),
              _Divider(),
              _ProfileStat(value: '4.9', label: 'Score'),
            ],
          ),

          const SizedBox(height: 24),

          // ── Menu sections ──────────────────────────────────────────────
          _SectionTitle('Account'),
          const SizedBox(height: 10),
          _MenuCard(
            items: [
              _MenuItem(
                Icons.person_outline_rounded,
                'Edit Profile',
                AppTheme.primaryColor,
              ),
              _MenuItem(
                Icons.notifications_outlined,
                'Notifications',
                const Color(0xFFFF9800),
              ),
              _MenuItem(
                Icons.lock_outline_rounded,
                'Change Password',
                const Color(0xFF4CAF50),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _SectionTitle('App'),
          const SizedBox(height: 10),
          _MenuCard(
            items: [
              _MenuItem(
                Icons.palette_outlined,
                'Appearance',
                const Color(0xFFAB47BC),
              ),
              _MenuItem(
                Icons.language_rounded,
                'Language',
                const Color(0xFF29B6F6),
              ),
              _MenuItem(
                Icons.privacy_tip_outlined,
                'Privacy Policy',
                const Color(0xFF78909C),
              ),
              _MenuItem(
                Icons.info_outline_rounded,
                'About Lazy Easy',
                AppTheme.secondary,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Sign Out ───────────────────────────────────────────────────
          _SignOutButton(context: context),

          const SizedBox(height: 12),

          Text(
            'Lazy Easy v1.0.0',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppTheme.textMuted.withValues(alpha: 0.5),
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final bool isSmall;
  const _ProfileHeader({required this.isSmall});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.2),
            AppTheme.cardDark,
          ],
        ),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.secondary, AppTheme.primaryDark],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF66BB6A),
                  ),
                  child: const Icon(
                    Icons.circle,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keerthivasan',
                  style: GoogleFonts.poppins(
                    fontSize: isSmall ? 18 : 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Kee@example.com',
                  style: GoogleFonts.poppins(
                    fontSize: isSmall ? 12 : 13,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: AppTheme.buttonGradient,
                  ),
                  child: Text(
                    '⚡ Lazy Pro',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit_outlined,
              color: AppTheme.secondary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.cardDark,
          border: Border.all(color: AppTheme.secondary.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.onPrimary,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox(width: 8);
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.secondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  _MenuItem(this.icon, this.label, this.color);
}

class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppTheme.cardDark,
        border: Border.all(color: AppTheme.secondary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: items
            .asMap()
            .entries
            .map(
              (e) => Column(
                children: [
                  _MenuItemWidget(item: e.value),
                  if (e.key < items.length - 1)
                    Divider(
                      height: 1,
                      color: AppTheme.secondary.withValues(alpha: 0.08),
                      indent: 60,
                    ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MenuItemWidget extends StatelessWidget {
  final _MenuItem item;
  const _MenuItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        splashColor: AppTheme.primaryColor.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: item.color.withValues(alpha: 0.15),
                ),
                child: Icon(item.icon, color: item.color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.onPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  final BuildContext context;
  const _SignOutButton({required this.context});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showSignOutDialog(context),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Color(0xFFFF5252), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(
          Icons.logout_rounded,
          color: Color(0xFFFF5252),
          size: 20,
        ),
        label: Text(
          'Sign Out',
          style: GoogleFonts.poppins(
            color: const Color(0xFFFF5252),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Sign Out',
          style: GoogleFonts.poppins(
            color: AppTheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: GoogleFonts.poppins(color: AppTheme.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: AppTheme.textMuted,
                fontSize: 14,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.goNamed('signIn');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5252),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Sign Out',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
