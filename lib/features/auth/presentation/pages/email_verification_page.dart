import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final AuthController authController = Get.find<AuthController>();
  late Timer _timer;
  final RxInt _countdown = 60.obs;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdown.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown.value == 0) {
        t.cancel();
      } else {
        _countdown.value--;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil email dari user yang sudah tersimpan saat register
    final String userEmail = authController.user?.email ?? 'email kamu';

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false, // Menghilangkan tombol back
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Icon ✉️
              const Icon(
                Icons.email_outlined,
                size: 80,
                color: AppColors.primary500,
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Cek Email Kamu',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                'Link verifikasi sudah dikirim ke\n$userEmail\n\nKlik link di email tersebut untuk mengaktifkan akun Marketiv kamu.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Primary Action: Check Verification
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: authController.isLoading 
                          ? null 
                          : () => authController.checkVerificationAndProceed(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      child: authController.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Saya Sudah Verifikasi — Lanjut',
                              style: AppTextStyles.buttonText,
                            ),
                    ),
                  )),
              const SizedBox(height: 16),

              // Secondary Action: Resend with Countdown
              Obx(() => TextButton(
                    onPressed: _countdown.value > 0
                        ? null
                        : () async {
                            await authController.resendEmailVerification();
                            _startCountdown();
                          },
                    child: Text(
                      _countdown.value > 0
                          ? 'Kirim ulang dalam ${_countdown.value} detik'
                          : 'Kirim Ulang Email Verifikasi',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: _countdown.value > 0 
                            ? AppColors.grey300 
                            : AppColors.primary500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              const SizedBox(height: 24),

              // Footer: Back to Welcome (if wrong email)
              TextButton(
                onPressed: () => Get.offAllNamed(Routes.welcome),
                child: Text(
                  'Salah email? Kembali ke Awal',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
