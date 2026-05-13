import 'package:flutter/material.dart';

class CampaignListPage extends StatelessWidget {
  const CampaignListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campaign List')),
      body: const Center(
        child: Text('Campaign List Page'),
      ),
    );
  }
}
