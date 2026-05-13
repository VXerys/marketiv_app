import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _obscurePassword = true.obs;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _authController.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Dapatkan argument role
    final dynamic args = Get.arguments;
    String role = 'UMKM';
    if (args is Map && args.containsKey('role')) {
      role = args['role'];
    } else if (args is String) {
      role = args;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.secondary500),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              
              // HEADING DENGAN BADGE
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary500.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      role == 'UMKM' ? Icons.storefront_rounded : Icons.movie_creation_outlined,
                      color: AppColors.primary500,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    role == 'UMKM' ? 'Masuk sebagai UMKM' : 'Masuk sebagai Kreator',
                    style: AppTextStyles.h2.copyWith(color: AppColors.secondary700),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(left: 48.0),
                child: Text(
                  'Selamat datang kembali di platform Marketiv',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
                ),
              ),
              
              const SizedBox(height: AppSpacing.xxl),

              // FORM
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AuthTextField(
                      label: 'Alamat Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      hint: 'cth: nama@email.com',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong ya';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Format email sepertinya salah';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Obx(() => AuthTextField(
                      label: 'Kata Sandi',
                      controller: _passwordController,
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword.value,
                      onToggleObscure: () => _obscurePassword.toggle(),
                      hint: 'Masukkan kata sandi kamu',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kata sandi jangan dikosongkan ya';
                        }
                        if (value.length < 8) {
                          return 'Kata sandi minimal 8 karakter';
                        }
                        return null;
                      },
                    )),
                    
                    // Lupa Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.forgotPassword);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary500,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(48, 48),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Lupa Password?',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.xl),

                    // Tombol Masuk
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _authController.isLoading 
                            ? null 
                            : () => _handleLogin(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.grey300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          elevation: 0,
                        ),
                        child: _authController.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Masuk',
                                style: AppTextStyles.buttonText,
                              ),
                      ),
                    )),
                  ],
                ),
              ),
              
              const SizedBox(height: AppSpacing.xl),

              // FOOTER
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.grey500),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(
                        Routes.register,
                        arguments: {'role': role},
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(48, 48),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Daftar',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.primary500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
