import 'package:flutter/material.dart';
import 'package:point_sale/core/widgets/base_text_field.dart';
import 'package:point_sale/core/widgets/base_button.dart';
import 'package:point_sale/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:point_sale/core/constants/app_color.dart';
import 'package:point_sale/app/app_routes.dart';
import 'package:point_sale/features/auth/data/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_isLoading) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter your email and password.');
      return;
    }

    if (!_isValidEmail(email)) {
      _showMessage('Please enter a valid email address.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _authService.login(email: email, password: password);
    

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    _showMessage(result.message, isError: !result.success);

    if (result.success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColor.error : const Color(0xFF00D492),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteWithOpacity(0.95),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Section
                Column(
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                        color: AppColor.textSecondary,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 16,
                          color: AppColor.textSecondary,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(text: 'Sign in to your '),
                          TextSpan(
                            text: 'PointSale ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'account'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 64),

                // Form Section
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email Field
                      BaseTextField(
                        label: 'Email',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          _passwordFocusNode.requestFocus();
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      BaseTextField(
                        label: 'Password',
                        hintText: 'Enter your password',
                        controller: _passwordController,
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          _handleSignIn();
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 19.989,
                            color: AppColor.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Sign In Button
                      AbsorbPointer(
                        absorbing: _isLoading,
                        child: Opacity(
                          opacity: _isLoading ? 0.75 : 1,
                          child: BaseButton(
                            text: _isLoading ? 'Signing In...' : 'Sign In',
                            onPressed: _handleSignIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Forgot Password
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 14,
                      color: AppColor.primary,
                      height: 1.43,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Divider with text
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColor.whiteWithOpacity(0.8),
                          thickness: 1.15,
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Text(
                          'Or continue with',
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 14,
                            color: AppColor.textSecondary,
                            height: 1.43,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColor.whiteWithOpacity(0.8),
                          thickness: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Google Sign In Button
                BaseButton(
                  text: 'Sign in with Google',
                  onPressed: (){
                    // Handle Google sign in
                  },
                  isPrimary: false,
                  icon: Image.asset(
                    'assets/images/icons/google_favicon.png',
                    width: 20,
                    height: 20,
                  ),
                ),
                const SizedBox(height: 24),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 16,
                        color: Color(0xFF4A5565),
                        height: 1.5,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.signup,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(left: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Sign up',
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
