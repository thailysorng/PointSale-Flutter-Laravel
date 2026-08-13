import 'package:flutter/material.dart';
import 'package:point_sale/core/widgets/base_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement reset password logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset link sent to your email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 413,
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.flip(
                          flipX: true,
                          child: const Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: Color(0xFF4A5565),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Back',
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 16,
                            color: Color(0xFF4A5565),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 69),

                  // Heading
                  const Center(
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 30,
                        color: Color(0xFF4A5565),
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  const Center(
                    child: SizedBox(
                      width: 313,
                      child: Text(
                        "Enter your email and we'll send you a link to reset your password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 16,
                          color: Color(0xFF4A5565),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email Input
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     const Text(
                  //       'Email',
                  //       style: TextStyle(
                  //         fontFamily: 'Arimo',
                  //         fontSize: 14,
                  //         color: Color(0xFF364153),
                  //         height: 1.43,
                  //       ),
                  //     ),
                  //     const SizedBox(height: 8),
                  //     Email Field
                  //     Container(
                  //       decoration: BoxDecoration(
                  //         border: Border.all(
                  //           color: const Color(0xFFD1D5DC),
                  //           width: 1.15,
                  //         ),
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       child: TextFormField(
                  //         controller: _emailController,
                  //         keyboardType: TextInputType.emailAddress,
                  //         style: const TextStyle(
                  //           fontFamily: 'Arimo',
                  //           fontSize: 16,
                  //           color: Color(0xFF0A0A0A),
                  //         ),
                  //         decoration: const InputDecoration(
                  //           hintText: 'Enter your email',
                  //           hintStyle: TextStyle(
                  //             fontFamily: 'Arimo',
                  //             fontSize: 16,
                  //             color: Color(0x800A0A0A),
                  //           ),
                  //           prefixIcon: Icon(
                  //             Icons.email_outlined,
                  //             size: 20,
                  //             color: Color(0xFF4A5565),
                  //           ),
                  //           border: InputBorder.none,
                  //           contentPadding: EdgeInsets.symmetric(
                  //             horizontal: 16,
                  //             vertical: 12,
                  //           ),
                  //         ),
                  //         validator: (value) {
                  //           if (value == null || value.isEmpty) {
                  //             return 'Please enter your email';
                  //           }
                  //           if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  //               .hasMatch(value)) {
                  //             return 'Please enter a valid email';
                  //           }
                  //           return null;
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  BaseTextField(
                    label: 'Email',
                    hintText: 'Enter your email',
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Reset Password Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _handleResetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B8DB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
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
