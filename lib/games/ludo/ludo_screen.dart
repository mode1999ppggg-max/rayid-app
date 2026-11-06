import 'package:flutter/material.dart';

class LudoLobbyScreen extends StatelessWidget {
  const LudoLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.sports_esports,
                size: 80,
                color: Color(0xFF06B6D4),
              ),
              const SizedBox(height: 16),
              const Text(
                'CYBERPUNK LUDO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'تحدَ الخصوم واكسب نقاط في رايد باي',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 48),
              _buildMenuButton(
                context,
                title: 'لعب ضد البوت (AI)',
                icon: Icons.smart_toy,
                color: const Color(0xFF3B82F6),
                onTap: () {
                  // TODO: ربطها بشاشة اللعب لاحقاً
                },
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                title: 'لعب ثنائي (مع صديق)',
                icon: Icons.people,
                color: const Color(0xFF10B981),
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                title: 'قوانين والجوائز',
                icon: Icons.card_giftcard,
                color: const Color(0xFFF59E0B),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.2),
        foregroundColor: Colors.white,
        side: BorderSide(color: color, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(icon, color: color),
      label: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: onTap,
    );
  }
}
