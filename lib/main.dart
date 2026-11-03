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
        scaffoldBackgroundColor: const Color(0xff080c10), // خلفية داكنة عميقة بطابع سايبر
        primaryColor: const Color(0xff00ff88),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xff00ff88),
          secondary: Color(0xff00ff88),
          surface: Color(0xff121b26),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ================= 1. شاشة تسجيل الدخول بتصميم سايبر =================
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
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xff121b26),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff00ff88).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                      border: Border.all(color: const Color(0xff00ff88), width: 2),
                    ),
                    child: const Icon(Icons.bolt_rounded, color: Color(0xff00ff88), size: 60),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'RAYID PAY',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 3,
                      shadows: [Shadow(color: Color(0xff00ff88), blurRadius: 10)],
                    ),
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
                      fillColor: const Color(0xff121b26),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xff00ff88), width: 1.5),
                      ),
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
                      fillColor: const Color(0xff121b26),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xff00ff88), width: 1.5),
                      ),
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
                        elevation: 8,
                        shadowColor: const Color(0xff00ff88).withOpacity(0.5),
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
  final int initialIndex;
  const MainNavigationHub({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationHub> createState() => MainNavigationHubState();
}

class MainNavigationHubState extends State<MainNavigationHub> {
  late int _currentIndex;

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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xff0b1017),
          selectedItemColor: const Color(0xff00ff88),
          unselectedItemColor: Colors.grey[600],
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
      ),
    );
  }
}

// ================= 3. الشاشة الرئيسية بتصميم 3D Cyber =================
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
                  const Text(
                    'RAYID PAY',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green, width: 1),
                      boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.2), blurRadius: 8)],
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
              // بطاقة الملف الشخصي بتأثير 3D بارز
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff162231), Color(0xff0e151f)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.5),
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
                          child: GestureDetector(
                            onTap: () {
                              final hub = context.findAncestorStateOfType<MainNavigationHubState>();
                              hub?.changeTab(2);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xff1b2635),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.amber.withOpacity(0.3)),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, offset: const Offset(0, 4))],
                              ),
                              child: Row(
                                children: const [
                                  Text('🪙', style: TextStyle(fontSize: 22)),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('النقاط', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                      Text('1,240', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final hub = context.findAncestorStateOfType<MainNavigationHubState>();
                              hub?.changeTab(2);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xff1b2635),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, offset: const Offset(0, 4))],
                              ),
                              child: Row(
                                children: const [
                                  Text('💵', style: TextStyle(fontSize: 22)),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('الأرباح', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                      Text('\$45.50', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // بطاقة التحدي البارزة بتأثير نيون 3D
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xff122623), Color(0xff0b161f)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff00ff88).withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: const Color(0xff00ff88).withOpacity(0.6), width: 1.5),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        elevation: 6,
                        shadowColor: const Color(0xff00ff88).withOpacity(0.5),
                      ),
                      onPressed: () {
                        final hub = context.findAncestorStateOfType<MainNavigationHubState>();
                        hub?.changeTab(1);
                      },
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xff121b26),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
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

// ================= 4. شاشة الألعاب بتصميم 3D =================
class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قسم الألعاب والتحدي الرقمي'), backgroundColor: const Color(0xff0b1017), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildGameCard(context, 'NEON CYBER RUN', 'تحدي الركض والنقاط السريعة', const Color(0xff00ff88), Icons.bolt),
          _buildGameCard(context, 'لودو النيون التنافسية', 'تحدى أصدقائك واكسب نقاط', Colors.amber, Icons.casino),
          _buildGameCard(context, 'الشطرنج الاستراتيجي الذكي', 'مباريات هادئة ومكافآت مضاعفة', const Color(0xff00e5ff), Icons.extension),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String title, String subtitle, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff121b26),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.4), width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8)],
                ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              shadowColor: color.withOpacity(0.5),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('جاري بدء لعبة $title...'), backgroundColor: Colors.grey[900]),
              );
            },
            child: const Text('العب', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ================= 5. شاشة المحفظة بتصميم 3D =================
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('محفظة الأرباح وسحب الأموال'), backgroundColor: const Color(0xff0b1017), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff122b20), Color(0xff0e171f)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: Colors.greenAccent.withOpacity(0.5), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('الرصيد المتاح للسحب', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 8),
                const Text('\$45.50 USD', style: TextStyle(color: Colors.greenAccent, fontSize: 30, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.greenAccent, blurRadius: 10)])),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00ff88),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 6,
                    shadowColor: const Color(0xff00ff88).withOpacity(0.5),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم استلام طلب السحب بنجاح، سيتم المعالجة قريباً'), backgroundColor: Colors.green),
                    );
                  },
                  icon: const Icon(Icons.account_balance_wallet),
                  label: const Text('طلب سحب الأرباح', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('طرق السحب المتاحة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          _buildWalletTile(context, 'AsiaCell Cash (آسياسيل)', 'الحد الأدنى: \$5 USD', Colors.red, Icons.phone_android),
          _buildWalletTile(context, 'ZainCash (زين كاش)', 'الحد الأدنى: \$5 USD', Colors.orange, Icons.phone_iphone),
          _buildWalletTile(context, 'MasterCard (ماستر كارد)', 'الحد الأدنى: \$10 USD', Colors.blue, Icons.credit_card),
        ],
      ),
    );
  }

  Widget _buildWalletTile(BuildContext context, String title, String subtitle, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xff121b26),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xff00ff88), fontSize: 11)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم اختيار طريقة الدفع: $title'), backgroundColor: Colors.grey[850]),
          );
        },
      ),
    );
  }
}

// ================= 6. شاشة الدردشة بتصميم 3D =================
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدردشة العامة للمجتمع'), backgroundColor: const Color(0xff0b1017), automaticallyImplyLeading: false),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xff0b1017),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xff121b26),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: const TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالتك للمجتمع...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: const Color(0xff00ff88),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.black, size: 20),
                    onPressed: () {},
                  ),
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
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff121b26),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xff00ff88).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sender, style: const TextStyle(color: Color(0xff00ff88), fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}

// ================= 7. شاشة الإعدادات بتصميم 3D =================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات والحساب'), backgroundColor: const Color(0xff0b1017), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xff121b26),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
              border: Border.all(color: Colors.white.withOpacity(0.04)),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline, color: Color(0xff00ff88)),
                  title: const Text('تعديل الملف الشخصي', style: TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('شاشة الملف الشخصي قيد التحديث')),
                    );
                  },
                ),
                const Divider(color: Colors.white12, height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xff00e5ff)),
                  title: const Text('سياسة الخصوصية والشروط', style: TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xff121b26),
                        title: const Text('سياسة الخصوصية', style: TextStyle(color: Colors.white)),
                        content: const Text(
                          'تطبيق RAYID PAY يلتزم بحماية بياناتك الشخصية ومعاملاتك المالية وفق أعلى معايير الأمان الرقمي والتشفير السحابي.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('حسناً', style: TextStyle(color: Color(0xff00ff88))),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(color: Colors.white12, height: 1),
                ListTile(
                  leading: const Icon(Icons.security, color: Color(0xff00ff88)),
                  title: const Text('أمان الحساب والمصادقة', style: TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('الحساب محمي ومؤمن بالكامل')),
                    );
                  },
                ),
              ],
            ),
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
            label: const Text('تسجيل الخروج', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[800],
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              shadowColor: Colors.red.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
