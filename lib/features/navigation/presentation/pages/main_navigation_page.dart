import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/storage_service.dart';
import '../../../campaign/presentation/pages/campaign_list_page.dart';
import '../controllers/main_navigation_controller.dart';

class MainNavigationPage extends GetView<MainNavigationController> {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? role = StorageService.getRole();

    final List<Widget> umkmPages = <Widget>[
      Scaffold(
        appBar: AppBar(title: const Text('Beranda')),
        body: const Center(child: Text('Beranda UMKM')),
      ),
      const CampaignListPage(),
      Scaffold(
        appBar: AppBar(title: const Text('Direktori Kreator')),
        body: const Center(child: Text('Segera Hadir')),
      ),
      Scaffold(
        appBar: AppBar(title: const Text('Keuangan')),
        body: const Center(child: Text('Segera Hadir')),
      ),
      Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: const Center(child: Text('Segera Hadir')),
      ),
    ];

    final List<Widget> kreatorPages = <Widget>[
      Scaffold(
        appBar: AppBar(title: const Text('Beranda')),
        body: const Center(child: Text('Beranda Kreator')),
      ),
      Scaffold(
        appBar: AppBar(title: const Text('Job Pool')),
        body: const Center(child: Text('Segera Hadir')),
      ),
      Scaffold(
        appBar: AppBar(title: const Text('Pekerjaan Aktif')),
        body: const Center(child: Text('Segera Hadir')),
      ),
      Scaffold(
        appBar: AppBar(title: const Text('Dompet')),
        body: const Center(child: Text('Segera Hadir')),
      ),
      Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: const Center(child: Text('Segera Hadir')),
      ),
    ];

    final List<Widget> adminPages = <Widget>[
      Scaffold(
        appBar: AppBar(title: const Text('Dashboard Admin')),
        body: const Center(child: Text('Dashboard')),
      ),
      Scaffold(
        appBar: AppBar(title: const Text('Sengketa')),
        body: const Center(child: Text('Segera Hadir')),
      ),
      Scaffold(
        appBar: AppBar(title: const Text('Submisi')),
        body: const Center(child: Text('Segera Hadir')),
      ),
    ];

    const List<BottomNavigationBarItem> umkmItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Beranda',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.campaign_outlined),
        activeIcon: Icon(Icons.campaign),
        label: 'Kampanye',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people_outline),
        activeIcon: Icon(Icons.people),
        label: 'Kreator',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_balance_wallet_outlined),
        activeIcon: Icon(Icons.account_balance_wallet),
        label: 'Keuangan',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profil',
      ),
    ];

    const List<BottomNavigationBarItem> kreatorItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Beranda',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.work_outline),
        activeIcon: Icon(Icons.work),
        label: 'Job Pool',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.task_alt_outlined),
        activeIcon: Icon(Icons.task_alt),
        label: 'Pekerjaan',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_balance_wallet_outlined),
        activeIcon: Icon(Icons.account_balance_wallet),
        label: 'Dompet',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profil',
      ),
    ];

    const List<BottomNavigationBarItem> adminItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined),
        activeIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.gavel_outlined),
        activeIcon: Icon(Icons.gavel),
        label: 'Sengketa',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.fact_check_outlined),
        activeIcon: Icon(Icons.fact_check),
        label: 'Submisi',
      ),
    ];

    late final List<Widget> pages;
    late final List<BottomNavigationBarItem> items;

    if (role == 'UMKM') {
      pages = umkmPages;
      items = umkmItems;
    } else if (role == 'KREATOR') {
      pages = kreatorPages;
      items = kreatorItems;
    } else if (role == 'ADMIN') {
      pages = adminPages;
      items = adminItems;
    } else {
      pages = umkmPages;
      items = umkmItems;
    }

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary500,
          unselectedItemColor: AppColors.grey500,
          backgroundColor: AppColors.surface,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
          ),
          elevation: 8,
          items: items,
          currentIndex: controller.selectedIndex.value,
          onTap: (int index) => controller.changePage(index),
        ),
      ),
    );
  }
}
