import 'package:flutter/material.dart';
import 'package:point_sale/app/app_routes.dart';
import 'package:point_sale/features/auth/data/auth_service.dart';
import 'package:point_sale/core/widgets/base_text_field.dart';
import 'package:point_sale/core/constants/app_color.dart';
import 'package:point_sale/core/widgets/base_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_isLoading) {
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Please fill in all fields.');
      return;
    }

    if (!_isValidEmail(email)) {
      _showMessage('Please enter a valid email address.');
      return;
    }

    if (password.length < 8) {
      _showMessage('Password must be at least 8 characters.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Password confirmation does not match.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _authService.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: confirmPassword,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    _showMessage(result.message, isError: !result.success);

    if (result.success) {
      Navigator.pushReplacementNamed(context, AppRoutes.signin);
    }
  }

  void _handleGoogleSignUp() {
    // TODO: Implement Google sign up
  }

  void _navigateToSignIn() {
    Navigator.pop(context);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFE7000B) : const Color(0xFF00D492),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 413.217),
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Section
                Column(
                  children: [
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF4A5565),
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign up to get started',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 16,
                        color: Color(0xFF4A5565),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Form Section
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name Field
                      BaseTextField(
                        label: 'Full Name',
                        hintText: 'Enter your name',
                        controller: _nameController,
                        prefixIcon: Icons.person_outline,
                        focusNode: _nameFocusNode,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          _emailFocusNode.requestFocus();
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email Field
                      BaseTextField(
                        label: 'Email',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          _passwordFocusNode.requestFocus();
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      BaseTextField(
                        label: 'Password',
                        hintText: 'Create a password',
                        controller: _passwordController,
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          _confirmPasswordFocusNode.requestFocus();
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF6A7282),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password Field
                      BaseTextField(
                        label: 'Confirm Password',
                        hintText: 'Confirm your password',
                        controller: _confirmPasswordController,
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscureConfirmPassword,
                        focusNode: _confirmPasswordFocusNode,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          _handleSignUp();
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF6A7282),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Sign Up Button
                      AbsorbPointer(
                        absorbing: _isLoading,
                        child: Opacity(
                          opacity: _isLoading ? 0.75 : 1,
                          child: BaseButton(
                            text: _isLoading ? 'Signing Up...' : 'Sign Up',
                            onPressed: _handleSignUp,
                            isPrimary: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Divider with text
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Color(0xFFD1D5DC),
                        thickness: 1.15,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 14,
                          color: Color(0xFF6A7282),
                          height: 1.43,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Color(0xFFD1D5DC),
                        thickness: 1.15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Google Sign Up Button
                BaseButton(
                  text: 'Sign up with Google',
                  onPressed: _handleGoogleSignUp,
                  isPrimary: false,
                  icon: Image.asset(
                    'assets/images/icons/google_favicon.png',
                    width: 20,
                    height: 20,
                  ),
                ),
                const SizedBox(height: 24),

                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 16,
                        color: Color(0xFF4A5565),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _navigateToSignIn,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(left: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 16,
                          color: AppColor.primary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
