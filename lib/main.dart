import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const RayidApp());
}

class RayidApp extends StatelessWidget {
  const RayidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RAYID PAY',
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xff080c10),
        primaryColor: const Color(0xff00ff88),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xff00ff88),
          secondary: Color(0xff00ff88),
          surface: Color(0xff121b26),
        ),
      ),
      home: const MainNavigationHub(),
    );
  }
}

// ================= مركز التنقل السفلي =================
class MainNavigationHub extends StatefulWidget {
  final int initialIndex;
  const MainNavigationHub({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationHub> createState() => MainNavigationHubState();
}

class MainNavigationHubState extends State<MainNavigationHub> {
  late int _currentIndex;
  final List<Widget> _pages = [
    const HomeScreen(),
    const GamesScreen(),
    const WalletScreen(),
    const ChatScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: changeTab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff0b1017),
        selectedItemColor: const Color(0xff00ff88),
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports_outlined), label: 'الألعاب'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'المحفظة'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'الدردشة'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'الإعدادات'),
        ],
      ),
    );
  }
}

// ================= 1. الشاشة الرئيسية =================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xff121b26),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xff00ff88).withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircleAvatar(radius: 4, backgroundColor: Color(0xff00ff88)),
                      SizedBox(width: 8),
                      Text('متصل بالسحابة', style: TextStyle(color: Color(0xff00ff88), fontSize: 11)),
                    ],
                  ),
                ),
                const Text(
                  'RAYID PAY',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff121b26),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مرحباً لاعب_570575 !',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'بوابتك الاحترافية للأموال والألعاب',
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xff080c10),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('الأرباح', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  Text('💵', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '\$45.50',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff00ff88)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xff080c10),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('النقاط', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  Text('🟡', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '1,240',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

// ================= 2. شاشة الألعاب =================
class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('الألعاب', style: TextStyle(color: Colors.white, fontSize: 20))),
    );
  }
}

// ================= 3. شاشة المحفظة (مع طرق السحب الأصلية) =================
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرصيد والنقاط'),
        backgroundColor: const Color(0xff0b1017),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xff121b26),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xff00ff88), width: 1.5),
            ),
            child: Column(
              children: [
                const Text('الرصيد الكلي المتاح', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 8),
                const Text(
                  'USD \$45.50',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xff00ff88)),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('🟡', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 6),
                    Text('النقاط: 1,240', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(width: 16),
                    Icon(Icons.flash_on, color: Color(0xff00ff88), size: 16),
                    SizedBox(width: 4),
                    Text('التفاعل: نشط', style: TextStyle(color: Color(0xff00ff88), fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'طرق السحب المتاحة (اضغط للدخول)',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildWithdrawTile(context, 'AsiaCell Cash (آسياسيل)', 'انقر لإتمام عملية السحب', Icons.phone_android, Colors.redAccent),
          _buildWithdrawTile(context, 'ZainCash (زين كاش)', 'انقر لإتمام عملية السحب', Icons.phone_iphone, Colors.amber),
          _buildWithdrawTile(context, 'MasterCard (ماستر كارد)', 'انقر لإتمام عملية السحب', Icons.credit_card, Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _buildWithdrawTile(BuildContext context, String title, String subtitle, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xff121b26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 28),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xff00ff88), size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('جاري فتح نافذة سحب الأرباح عبر $title')),
          );
        },
      ),
    );
  }
}

// ================= 4. شاشة الدردشة =================
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('الدردشة', style: TextStyle(color: Colors.white, fontSize: 20))),
    );
  }
}

// ================= 5. شاشة الإعدادات =================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات'), backgroundColor: const Color(0xff0b1017)),
      body: const Center(child: Text('صفحة الإعدادات', style: TextStyle(color: Colors.white))),
    );
  }
}
