import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_easy/core/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  late final AnimationController _staggerController;
  late final List<Animation<double>> _slideAnimations;
  late final List<Animation<double>> _fadeAnimations;

  // header, new pass, confirm pass, button
  static const int _itemCount = 4;

  @override
  void initState() {
    super.initState();

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimations = List.generate(_itemCount, (i) {
      final start = i * 0.12;
      final end = start + 0.4;
      return Tween<double>(begin: 50.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(
            start,
            end.clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });

    _fadeAnimations = List.generate(_itemCount, (i) {
      final start = i * 0.12;
      final end = start + 0.4;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end.clamp(0.0, 1.0), curve: Curves.easeIn),
        ),
      );
    });

    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      setState(() => _isLoading = false);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: curved,
          child: FadeTransition(
            opacity: animation,
            child: _SuccessDialog(
              onDone: () {
                Navigator.of(context).pop();
                context.goNamed('home');
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final isSmallScreen = size.height < 700;
    final horizontalPadding = size.width > 600 ? size.width * 0.15 : 24.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height - padding.top - padding.bottom,
                maxWidth: 450,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: AnimatedBuilder(
                    animation: _staggerController,
                    builder: (context, child) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: isSmallScreen ? 40 : 60),

                            // ── Back button ────────────────────────────
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () => context.pop(),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppTheme.cardDark.withValues(
                                      alpha: 0.6,
                                    ),
                                    border: Border.all(
                                      color: AppTheme.secondary.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: AppTheme.secondary,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: isSmallScreen ? 24 : 40),

                            // ── Header ─────────────────────────────────
                            _buildAnimatedItem(
                              index: 0,
                              child: Column(
                                children: [
                                  // Lock icon
                                  Container(
                                    width: 80,
                                    height: 80,
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
                                          color: AppTheme.primaryColor
                                              .withValues(alpha: 0.5),
                                          blurRadius: 28,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.lock_reset_rounded,
                                      size: 42,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Reset Password',
                                    style: GoogleFonts.poppins(
                                      fontSize: isSmallScreen ? 26 : 32,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.onPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Enter your new password below',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: isSmallScreen ? 13 : 15,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: isSmallScreen ? 32 : 48),

                            // ── New Password field ─────────────────────
                            _buildAnimatedItem(
                              index: 1,
                              child: TextFormField(
                                controller: _newPasswordController,
                                obscureText: _obscureNew,
                                style: const TextStyle(
                                  color: AppTheme.textLight,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'New Password',
                                  hintText: '••••••••',
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureNew
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppTheme.textMuted,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscureNew = !_obscureNew,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a new password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                    return 'Must contain at least one uppercase letter';
                                  }
                                  if (!RegExp(r'[0-9]').hasMatch(value)) {
                                    return 'Must contain at least one number';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 18),

                            // ── Confirm Password field ─────────────────
                            _buildAnimatedItem(
                              index: 2,
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirm,
                                style: const TextStyle(
                                  color: AppTheme.textLight,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  hintText: '••••••••',
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirm
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppTheme.textMuted,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscureConfirm = !_obscureConfirm,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _newPasswordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 12),

                            // ── Password requirements hint ─────────────
                            _buildAnimatedItem(
                              index: 2,
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppTheme.cardDark.withValues(
                                    alpha: 0.5,
                                  ),
                                  border: Border.all(
                                    color: AppTheme.secondary.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Password must contain:',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    _RequirementRow(
                                      text: 'At least 6 characters',
                                      met:
                                          _newPasswordController.text.length >=
                                          6,
                                    ),
                                    _RequirementRow(
                                      text: 'One uppercase letter',
                                      met: RegExp(
                                        r'[A-Z]',
                                      ).hasMatch(_newPasswordController.text),
                                    ),
                                    _RequirementRow(
                                      text: 'One number',
                                      met: RegExp(
                                        r'[0-9]',
                                      ).hasMatch(_newPasswordController.text),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: isSmallScreen ? 28 : 40),

                            // ── Confirm button ─────────────────────────
                            _buildAnimatedItem(
                              index: 3,
                              child: _buildConfirmButton(),
                            ),

                            SizedBox(height: isSmallScreen ? 20 : 32),

                            // ── Back to sign in ────────────────────────
                            _buildAnimatedItem(
                              index: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Remember your password? ',
                                    style: GoogleFonts.poppins(
                                      color: AppTheme.textMuted,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => context.goNamed('signIn'),
                                    child: Text(
                                      'Sign In',
                                      style: GoogleFonts.poppins(
                                        color: AppTheme.primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: isSmallScreen ? 20 : 40),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedItem({required int index, required Widget child}) {
    return Transform.translate(
      offset: Offset(0, _slideAnimations[index].value),
      child: Opacity(opacity: _fadeAnimations[index].value, child: child),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: AppTheme.buttonGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleResetPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Text(
                'Reset Password',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

// ── Password requirement row ──────────────────────────────────────────────────
class _RequirementRow extends StatelessWidget {
  final String text;
  final bool met;
  const _RequirementRow({required this.text, required this.met});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: met
                  ? const Color(0xFF66BB6A).withValues(alpha: 0.2)
                  : Colors.transparent,
              border: Border.all(
                color: met
                    ? const Color(0xFF66BB6A)
                    : AppTheme.textMuted.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: met
                ? const Icon(Icons.check, size: 10, color: Color(0xFF66BB6A))
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: met ? const Color(0xFF66BB6A) : AppTheme.textMuted,
              fontWeight: met ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Success Dialog with animated check ────────────────────────────────────────
class _SuccessDialog extends StatefulWidget {
  final VoidCallback onDone;
  const _SuccessDialog({required this.onDone});

  @override
  State<_SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<_SuccessDialog>
    with TickerProviderStateMixin {
  late final AnimationController _checkController;
  late final AnimationController _ringController;
  late final AnimationController _confettiController;
  late final AnimationController _pulseController;

  late final Animation<double> _checkScale;
  late final Animation<double> _ringScale;
  late final Animation<double> _ringOpacity;
  late final Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();

    // Check mark entrance
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _checkScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );

    // Expanding ring
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _ringScale = Tween<double>(
      begin: 0.5,
      end: 1.8,
    ).animate(CurvedAnimation(parent: _ringController, curve: Curves.easeOut));
    _ringOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _ringController, curve: Curves.easeOut));

    // Confetti particles
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Gentle pulse
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseScale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _checkController.forward();
    _ringController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _confettiController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _checkController.dispose();
    _ringController.dispose();
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 36),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.cardDark,
              AppTheme.backgroundDark.withValues(alpha: 0.95),
            ],
          ),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
              blurRadius: 40,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Animated success icon area ─────────────────────────────
            SizedBox(
              height: 140,
              width: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Expanding ring
                  AnimatedBuilder(
                    animation: _ringController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _ringScale.value,
                        child: Opacity(
                          opacity: _ringOpacity.value,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.primaryColor,
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Second ring (delayed)
                  AnimatedBuilder(
                    animation: _ringController,
                    builder: (context, child) {
                      final delayed = (_ringController.value - 0.2).clamp(
                        0.0,
                        1.0,
                      );
                      return Transform.scale(
                        scale: 0.5 + delayed * 1.3,
                        child: Opacity(
                          opacity: (1.0 - delayed).clamp(0.0, 1.0),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.secondary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Confetti particles
                  AnimatedBuilder(
                    animation: _confettiController,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: List.generate(12, (i) {
                          final random = Random(i * 42);
                          final angle = (2 * pi * i / 12);
                          final distance =
                              40.0 + _confettiController.value * 60;
                          final dx = cos(angle) * distance;
                          final dy = sin(angle) * distance;
                          final colors = [
                            AppTheme.primaryColor,
                            AppTheme.secondary,
                            const Color(0xFFFFD600),
                            const Color(0xFF66BB6A),
                            const Color(0xFFFF7043),
                          ];
                          final size =
                              (random.nextDouble() * 6 + 4) *
                              (1 - _confettiController.value * 0.5);
                          return Transform.translate(
                            offset: Offset(dx, dy),
                            child: Opacity(
                              opacity: (1 - _confettiController.value).clamp(
                                0,
                                1,
                              ),
                              child: Container(
                                width: size,
                                height: size,
                                decoration: BoxDecoration(
                                  shape: i % 3 == 0
                                      ? BoxShape.rectangle
                                      : BoxShape.circle,
                                  borderRadius: i % 3 == 0
                                      ? BorderRadius.circular(2)
                                      : null,
                                  color: colors[i % colors.length],
                                  boxShadow: [
                                    BoxShadow(
                                      color: colors[i % colors.length]
                                          .withValues(alpha: 0.6),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),

                  // Main check circle
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _checkController,
                      _pulseController,
                    ]),
                    builder: (context, child) {
                      final pulse = _pulseController.isAnimating
                          ? _pulseScale.value
                          : 1.0;
                      return Transform.scale(
                        scale: _checkScale.value * pulse,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF66BB6A,
                                ).withValues(alpha: 0.5),
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Title ──────────────────────────────────────────────────
            Text(
              'Password Changed!',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.onPrimary,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Your password has been updated\nsuccessfully. You\'re all set!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppTheme.textMuted,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 28),

            // ── Go to Home button ──────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: AppTheme.buttonGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: widget.onDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(
                    Icons.bolt_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  label: Text(
                    'Continue to Home',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
