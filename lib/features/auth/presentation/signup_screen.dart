import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';

/// SignupScreen — Phone OTP or social OAuth registration
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to terms and conditions')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Call auth repository to send OTP
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      if (!mounted) return;
      context.push('/auth/verify-otp', extra: _phoneController.text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your phone number to get started',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 32),
                
                // Phone number input
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '0801 234 5678',
                    prefixText: ApiConstants.nigeriaCountryCode + ' ',
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  validator: Validators.validatePhone,
                ),
                
                const SizedBox(height: 24),
                
                // Send OTP button
                AppButton(
                  text: 'Send OTP',
                  onPressed: _sendOtp,
                  isLoading: _isLoading,
                ),
                
                const SizedBox(height: 24),
                
                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Google Sign-In
                AppButton(
                  text: 'Continue with Google',
                  icon: Icons.g_mobiledata,
                  onPressed: () {
                    // TODO: Implement Google Sign-In
                  },
                  isOutlined: true,
                ),
                
                const SizedBox(height: 12),
                
                // Apple Sign-In
                AppButton(
                  text: 'Continue with Apple',
                  icon: Icons.apple,
                  onPressed: () {
                    // TODO: Implement Apple Sign-In
                  },
                  isOutlined: true,
                ),
                
                const SizedBox(height: 24),
                
                // Terms checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
                    ),
                    Expanded(
                      child: Text(
                        'I agree to the Terms & Conditions and Privacy Policy',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Login link
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/auth/login'),
                    child: const Text('Already have an account? Log In'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
