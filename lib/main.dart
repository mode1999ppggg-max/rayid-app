import 'package:flutter/material.dart';

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
        scaffoldBackgroundColor: const Color(0xff0d131a),
        primaryColor: const Color(0xff00ff88),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xff00ff88),
          secondary: const Color(0xff00ff88),
          surface: const Color(0xff161f2c),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ================= 1. شاشة تسجيل الدخول =================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationHub()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xff161f2c),
                      border: Border.all(color: const Color(0xff00ff88).withOpacity(0.3), width: 2),
                    ),
                    child: const Icon(Icons.bolt_rounded, color: Color(0xff00ff88), size: 60),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'RAYID PAY',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2),
                  ),
                  const SizedBox(height: 8),
                  Text('منصة الترفيه والأموال الذكية', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني أو الهاتف',
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xff161f2c),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xff161f2c),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00ff88),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

// ================= 2. مركز التنقل السفلي =================
class MainNavigationHub extends StatefulWidget {
  const MainNavigationHub({super.key});

  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const GamesScreen(),
    const WalletScreen(),
    const ChatScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff111823),
        selectedItemColor: const Color(0xff00ff88),
        unselectedItemColor: Colors.grey[500],
        selectedFontSize: 12,
        unselectedFontSize: 12,
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

// ================= 3. الشاشة الرئيسية الغنية والمتكاملة =================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('RAYID PAY', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: Row(
                      children: const [
                        CircleAvatar(radius: 4, backgroundColor: Colors.green),
                        SizedBox(width: 6),
                        Text('متصل بالسحابة', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff161f2c),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('مرحباً لاعب_570575 !', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('أهلاً بك في منصة الأموال والترفيه الذكية', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: const Color(0xff222e3f), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: const [
                                Text('🪙', style: TextStyle(fontSize: 20)),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('النقاط', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    Text('1,240', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: const Color(0xff222e3f), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: const [
                                Text('💵', style: TextStyle(fontSize: 20)),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('الأرباح', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    Text('\$45.50', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [const Color(0xff161f2c), const Color(0xff111823)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  border: Border.all(color: const Color(0xff00ff88).withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('تحدي الركض والنقاط', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        Icon(Icons.sports_esports, color: Color(0xff00ff88), size: 28),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text('Neon Cyber Run - اربح نقاط إضافية الآن', style: TextStyle(fontSize: 13, color: Color(0xff00ff88))),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00ff88),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {},
                      child: const Text('ابدأ التحدي الآن', style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('النشاطات والمعاملات الأخيرة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 12),
              _buildActivityTile('🎁', 'مكافأة تسجيل الدخول اليومي', '+30 نقطة', Colors.greenAccent),
              _buildActivityTile('🎮', 'جلسة لعب Neon Cyber Run', '+120 نقطة', Colors.greenAccent),
              _buildActivityTile('🛡️', 'حالة المحفظة الآمنة', 'نشطة ومؤمنة', const Color(0xff00ff88)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityTile(String emoji, String title, String trailingText, Color trailingColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xff161f2c), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
            ],
          ),
          Text(trailingText, style: TextStyle(fontSize: 14, color: trailingColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ================= 4. شاشة الألعاب المتكاملة =================
class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قسم الألعاب والتحدي الرقمي'), backgroundColor: const Color(0xff111823)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildGameCard('NEON CYBER RUN', 'تحدي الركض والنقاط السريعة', const Color(0xff00ff88), Icons.bolt),
          _buildGameCard('لودو النيون التنافسية', 'تحدى أصدقائك واكسب نقاط', Colors.amber, Icons.casino),
          _buildGameCard('الشطرنج الاستراتيجي الذكي', 'مباريات هادئة ومكافآت مضاعفة', const Color(0xff00e5ff), Icons.extension),
        ],
      ),
    );
  }

  Widget _buildGameCard(String title, String subtitle, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff161f2c),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {},
            child: const Text('العب', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ================= 5. شاشة المحفظة المتكاملة =================
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('محفظة الأرباح وسحب الأموال'), backgroundColor: const Color(0xff111823)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xff161f2c),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('الرصيد المتاح للسحب', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 8),
                const Text('\$45.50 USD', style: TextStyle(color: Colors.greenAccent, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00ff88), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 45)),
                  onPressed: () {},
                  icon: const Icon(Icons.account_balance_wallet),
                  label: const Text('طلب سحب الأرباح', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('طرق السحب المتاحة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          _buildWalletTile('AsiaCell Cash (آسياسيل)', 'الحد الأدنى: \$5 USD', Colors.red, Icons.phone_android),
          _buildWalletTile('ZainCash (زين كاش)', 'الحد الأدنى: \$5 USD', Colors.orange, Icons.phone_iphone),
          _buildWalletTile('MasterCard (ماستر كارد)', 'الحد الأدنى: \$10 USD', Colors.blue, Icons.credit_card),
        ],
      ),
    );
  }

  Widget _buildWalletTile(String title, String subtitle, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xff161f2c),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xff00ff88), fontSize: 11)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}

// ================= 6. شاشة الدردشة المتكاملة =================
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدردشة العامة للمجتمع'), backgroundColor: const Color(0xff111823)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ChatBubble(sender: 'محمد', text: 'أهلاً بالجميع في مجتمع Rayid Pay!'),
                ChatBubble(sender: 'سارة', text: 'منو سحب أرباحه اليوم عبر زين كاش؟'),
                ChatBubble(sender: 'أحمد', text: 'تم سحب الأرباح بنجاح وصلتي الرسالة فوري 🔥'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xff111823),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك للمجتمع...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: Color(0xff00ff88)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String sender;
  final String text;
  const ChatBubble({super.key, required this.sender, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xff161f2c),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sender, style: const TextStyle(color: Color(0xff00ff88), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}

// ================= 7. شاشة الإعدادات المتكاملة =================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات والحساب'), backgroundColor: const Color(0xff111823)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline, color: Color(0xff00ff88)),
            title: const Text('تعديل الملف الشخصي', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () {},
          ),
          const Divider(color: Colors.white12),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xff00e5ff)),
            title: const Text('سياسة الخصوصية والشروط', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () {},
          ),
          const Divider(color: Colors.white12),
          ListTile(
            leading: const Icon(Icons.security, color: Color(0xff00ff88)),
            title: const Text('أمان الحساب والمصادقة', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () {},
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('تسجيل الخروج', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[800],
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }
}
