import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_easy/core/app_theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _agreeToTerms = false;

  late final AnimationController _staggerController;
  late final List<Animation<double>> _slideAnimations;
  late final List<Animation<double>> _fadeAnimations;

  // Number of animated elements: header, name, email, password, confirm, checkbox, button, footer
  static const int _itemCount = 8;

  @override
  void initState() {
    super.initState();

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _slideAnimations = List.generate(_itemCount, (i) {
      final start = i * 0.08;
      final end = start + 0.3;
      return Tween<double>(begin: 50.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end.clamp(0.0, 1.0), curve: Curves.easeOutCubic),
        ),
      );
    });

    _fadeAnimations = List.generate(_itemCount, (i) {
      final start = i * 0.08;
      final end = start + 0.3;
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please agree to the Terms & Conditions',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      setState(() => _isLoading = false);
      context.goNamed('signIn');
    }
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
                            SizedBox(height: isSmallScreen ? 24 : 40),

                            // ── Header ─────────────────────────────────
                            _buildAnimatedItem(
                              index: 0,
                              child: Column(
                                children: [
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppTheme.secondary,
                                          AppTheme.primaryColor,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primaryColor
                                              .withValues(alpha: 0.4),
                                          blurRadius: 24,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.person_add_rounded,
                                      size: 36,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Create Account',
                                    style: GoogleFonts.poppins(
                                      fontSize: isSmallScreen ? 24 : 30,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.onPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Join Lazy Easy today',
                                    style: GoogleFonts.poppins(
                                      fontSize: isSmallScreen ? 13 : 15,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: isSmallScreen ? 24 : 36),

                            // ── Name field ─────────────────────────────
                            _buildAnimatedItem(
                              index: 1,
                              child: TextFormField(
                                controller: _nameController,
                                textCapitalization:
                                    TextCapitalization.words,
                                style: const TextStyle(
                                    color: AppTheme.textLight),
                                decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                  hintText: 'John Doe',
                                  prefixIcon:
                                      Icon(Icons.person_outline_rounded),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  if (value.length < 2) {
                                    return 'Name must be at least 2 characters';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Email field ────────────────────────────
                            _buildAnimatedItem(
                              index: 2,
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(
                                    color: AppTheme.textLight),
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'your@email.com',
                                  prefixIcon:
                                      Icon(Icons.email_outlined),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Password field ─────────────────────────
                            _buildAnimatedItem(
                              index: 3,
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(
                                    color: AppTheme.textLight),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: '••••••••',
                                  prefixIcon: const Icon(
                                      Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppTheme.textMuted,
                                    ),
                                    onPressed: () => setState(() =>
                                        _obscurePassword =
                                            !_obscurePassword),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Confirm Password field ─────────────────
                            _buildAnimatedItem(
                              index: 4,
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                style: const TextStyle(
                                    color: AppTheme.textLight),
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  hintText: '••••••••',
                                  prefixIcon: const Icon(
                                      Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppTheme.textMuted,
                                    ),
                                    onPressed: () => setState(() =>
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Terms checkbox ─────────────────────────
                            _buildAnimatedItem(
                              index: 5,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Checkbox(
                                      value: _agreeToTerms,
                                      onChanged: (v) => setState(
                                          () => _agreeToTerms = v ?? false),
                                      activeColor: AppTheme.primaryColor,
                                      checkColor: Colors.white,
                                      side: BorderSide(
                                        color: AppTheme.secondary
                                            .withValues(alpha: 0.5),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: AppTheme.textMuted,
                                        ),
                                        children: [
                                          const TextSpan(
                                              text: 'I agree to the '),
                                          TextSpan(
                                            text: 'Terms & Conditions',
                                            style: GoogleFonts.poppins(
                                              color: AppTheme.primaryColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ── Sign Up button ─────────────────────────
                            _buildAnimatedItem(
                              index: 6,
                              child: _buildSignUpButton(),
                            ),

                            SizedBox(height: isSmallScreen ? 20 : 32),

                            // ── Footer ─────────────────────────────────
                            _buildAnimatedItem(
                              index: 7,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
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
      child: Opacity(
        opacity: _fadeAnimations[index].value,
        child: child,
      ),
    );
  }

  Widget _buildSignUpButton() {
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
        onPressed: _isLoading ? null : _handleSignUp,
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
                'Create Account',
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
