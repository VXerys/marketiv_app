import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/storage_service.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _data = [
    OnboardingData(
      title: 'Selamat Datang di Marketiv',
      description: 'Platform marketing berbasis performa pertama untuk UMKM dan Kreator.',
      icon: Icons.rocket_launch_rounded,
    ),
    OnboardingData(
      title: 'Bayar Sesuai Hasil',
      description: 'UMKM hanya membayar untuk tayangan nyata. Tanpa biaya iklan yang sia-sia.',
      icon: Icons.payments_rounded,
    ),
    OnboardingData(
      title: 'Cuan untuk Kreator',
      description: 'Kreator dapat cuan dari konten berkualitas. Pembayaran aman lewat escrow.',
      icon: Icons.trending_up_rounded,
    ),
  ];

  void _onFinish() {
    StorageService.setSeenOnboarding();
    Get.offAllNamed(Routes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          decoration: BoxDecoration(
                            color: AppColors.primary500.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _data[index].icon,
                            size: 100,
                            color: AppColors.primary500,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          _data[index].title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h1.copyWith(color: AppColors.secondary500),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          _data[index].description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.grey500),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicators
                  Row(
                    children: List.generate(
                      _data.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppColors.primary500 : AppColors.grey300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _data.length - 1) {
                        _onFinish();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Icon(
                      _currentPage == _data.length - 1 ? Icons.check : Icons.arrow_forward,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}
