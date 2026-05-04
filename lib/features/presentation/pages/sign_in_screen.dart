import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_easy/core/app_theme.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  late final AnimationController _staggerController;
  late final List<Animation<double>> _slideAnimations;
  late final List<Animation<double>> _fadeAnimations;

  // Number of animated elements: header, email, password, button, footer
  static const int _itemCount = 5;

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
          curve: Interval(start, end.clamp(0.0, 1.0), curve: Curves.easeOutCubic),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      setState(() => _isLoading = false);
      context.goNamed('home');
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
                            SizedBox(height: isSmallScreen ? 40 : 60),

                            // ── Header ─────────────────────────────────
                            _buildAnimatedItem(
                              index: 0,
                              child: Column(
                                children: [
                                  // Logo circle
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppTheme.primaryColor,
                                          AppTheme.primaryDark,
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
                                      Icons.bolt_rounded,
                                      size: 42,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Welcome Back',
                                    style: GoogleFonts.poppins(
                                      fontSize: isSmallScreen ? 26 : 32,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.onPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Sign in to continue to Lazy Easy',
                                    style: GoogleFonts.poppins(
                                      fontSize: isSmallScreen ? 13 : 15,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: isSmallScreen ? 32 : 48),

                            // ── Email field ────────────────────────────
                            _buildAnimatedItem(
                              index: 1,
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: AppTheme.textLight),
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'your@email.com',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 18),

                            // ── Password field ─────────────────────────
                            _buildAnimatedItem(
                              index: 2,
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(color: AppTheme.textLight),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: '••••••••',
                                  prefixIcon:
                                      const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppTheme.textMuted,
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Forgot password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => context.pushNamed('forgotPassword'),
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.poppins(
                                    color: AppTheme.secondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // ── Sign In button ─────────────────────────
                            _buildAnimatedItem(
                              index: 3,
                              child: _buildSignInButton(),
                            ),

                            SizedBox(height: isSmallScreen ? 20 : 32),

                            // ── Divider ────────────────────────────────
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color:
                                        AppTheme.secondary.withValues(alpha: 0.3),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    'OR',
                                    style: GoogleFonts.poppins(
                                      color: AppTheme.textMuted,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color:
                                        AppTheme.secondary.withValues(alpha: 0.3),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: isSmallScreen ? 20 : 32),

                            // ── Social buttons ─────────────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildSocialButton(Icons.g_mobiledata_rounded,
                                    'Google', Colors.white),
                                const SizedBox(width: 16),
                                _buildSocialButton(
                                    Icons.apple, 'Apple', Colors.white),
                              ],
                            ),

                            SizedBox(height: isSmallScreen ? 20 : 32),

                            // ── Footer ─────────────────────────────────
                            _buildAnimatedItem(
                              index: 4,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: GoogleFonts.poppins(
                                      color: AppTheme.textMuted,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => context.goNamed('signUp'),
                                    child: Text(
                                      'Sign Up',
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

  Widget _buildSignInButton() {
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
        onPressed: _isLoading ? null : _handleSignIn,
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
                'Sign In',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label, Color iconColor) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppTheme.secondary.withValues(alpha: 0.3),
          ),
          color: AppTheme.cardDark.withValues(alpha: 0.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {},
            splashColor: AppTheme.primaryColor.withValues(alpha: 0.2),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: iconColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: AppTheme.textLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
