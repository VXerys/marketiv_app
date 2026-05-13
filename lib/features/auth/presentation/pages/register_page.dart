import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field.dart';

class RegisterPage extends GetView<AuthController> {
  RegisterPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _obscurePassword = true.obs;
  final _obscureConfirmPassword = true.obs;
  final _isAgreed = false.obs;

  @override
  Widget build(BuildContext context) {
    // Role bisa diambil dari Get.arguments atau parameter route
    final String role = Get.arguments as String? ?? 'UMKM';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.secondary500),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Buat Akun',
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        role == 'UMKM' 
                            ? Icons.store_outlined 
                            : Icons.videocam_outlined,
                        size: 16,
                        color: AppColors.primary500,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        role == 'UMKM'
                            ? 'Mendaftar sebagai Pemilik UMKM'
                            : 'Mendaftar sebagai Kreator Konten',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // FORM CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 1. Nama
                    AuthTextField(
                      label: role == 'UMKM' ? 'Nama Usaha' : 'Nama Lengkap',
                      controller: _namaController,
                      prefixIcon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap isi nama';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // 2. Email
                    AuthTextField(
                      label: 'Email',
                      controller: _emailController,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap isi email';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // 3. Nomor WhatsApp
                    AuthTextField(
                      label: 'Nomor WhatsApp',
                      controller: _whatsappController,
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      hint: 'cth: 08123456789',
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap isi nomor WhatsApp';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // 4. Kata Sandi
                    Obx(() => AuthTextField(
                          label: 'Kata Sandi',
                          controller: _passwordController,
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword.value,
                          hint: 'Minimal 8 karakter',
                          textInputAction: TextInputAction.next,
                          onToggleObscure: () => _obscurePassword.toggle(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harap isi kata sandi';
                            }
                            if (value.length < 8) {
                              return 'Minimal 8 karakter';
                            }
                            return null;
                          },
                        )),
                    const SizedBox(height: AppSpacing.md),

                    // 5. Konfirmasi Kata Sandi
                    Obx(() => AuthTextField(
                          label: 'Konfirmasi Kata Sandi',
                          controller: _confirmPasswordController,
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscureConfirmPassword.value,
                          textInputAction: TextInputAction.done,
                          onToggleObscure: () => _obscureConfirmPassword.toggle(),
                          onFieldSubmitted: (_) => _handleRegister(role),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harap isi konfirmasi kata sandi';
                            }
                            if (value != _passwordController.text) {
                              return 'Kata sandi tidak cocok';
                            }
                            return null;
                          },
                        )),
                    
                    const SizedBox(height: AppSpacing.sm),

                    // Syarat & Ketentuan
                    Obx(() => CheckboxListTile(
                      value: _isAgreed.value,
                      onChanged: (val) => _isAgreed.value = val ?? false,
                      title: const Text(
                        'Saya setuju dengan Syarat & Ketentuan Marketiv',
                        style: AppTextStyles.bodySmall,
                      ),
                      activeColor: AppColors.primary500,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    )),

                    const SizedBox(height: AppSpacing.md),

                    // Submit Button
                    Obx(() => PrimaryButton(
                          label: 'Daftar Sekarang',
                          isLoading: controller.isLoading,
                          onPressed: _isAgreed.value ? () => _handleRegister(role) : null,
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Footer navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sudah punya akun? ',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
                ),
                TextButton(
                  onPressed: () => Get.offNamed(Routes.login),
                  child: Text(
                    'Masuk',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  void _handleRegister(String role) {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        Get.snackbar(
          'Perhatian',
          'Kata sandi tidak cocok',
          backgroundColor: AppColors.danger,
          colorText: Colors.white,
        );
        return;
      }

      controller.register(
        _namaController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
        _whatsappController.text.trim(),
        role,
      );
    }
  }
}
