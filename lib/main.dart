Import 'package:flutter/material.dart';

Void main() {
  RunApp(const RayidApp());
}

class RayidApp extends StatelessWidget {
  Const RayidApp({super.key});

  @override
  Widget build(BuildContext context) {
    Return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RAYID PAY',
      builder: (context, child) {
        Return Directionality(
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
      home: const LoginScreen(),
    );
  }
}

// ================= 1. شاشة تسجيل الدخول =================
class LoginScreen extends StatefulWidget {
  Const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Final _emailController = TextEditingController();
  Final _passwordController = TextEditingController();

  Void _login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationHub()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Return Scaffold(
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
                      boxShadow: [BoxShadow(color: const Color(0xff00ff88).withOpacity(0.3), blurRadius: 20, spreadRadius: 2)],
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
                  Text('نظام الألعاب والأموال الرقمية اللامركزي', style: TextStyle(color: Colors.grey[400], fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 36),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني أو المعرف',
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xff121b26),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xff00ff88), width: 1.5)),
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
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xff00ff88), width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                      },
                      child: const Text('هل نسيت كلمة المرور؟', style: TextStyle(color: Color(0xff00ff88), fontSize: 13)),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('ليس لديك حساب؟', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                        },
                        child: const Text('أنشئ حساباً الآن', style: TextStyle(color: Color(0xff00ff88), fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
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

// ================= شاشة إنشاء حساب =================
class RegisterScreen extends StatelessWidget {
  Const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب جديد'), backgroundColor: const Color(0xff0b1017)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: 'اسم اللاعب', labelStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xff121b26), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: 'البريد الإلكتروني', labelStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xff121b26), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: 'كلمة المرور', labelStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xff121b26), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00ff88), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء الحساب بنجاح!'), backgroundColor: Colors.green));
              },
              child: const Text('تسجيل الحساب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= شاشة استعادة كلمة المرور =================
class ForgotPasswordScreen extends StatelessWidget {
  Const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Return Scaffold(
      appBar: AppBar(title: const Text('استعادة كلمة المرور'), backgroundColor: const Color(0xff0b1017)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('أدخل بريدك الإلكتروني لاستعادة كلمة المرور:', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: 'البريد الإلكتروني', labelStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xff121b26), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00ff88), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال تعليمات الاستعادة'), backgroundColor: Colors.green));
              },
              child: const Text('إرسال', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= 2. مركز التنقل السفلي =================
class MainNavigationHub extends StatefulWidget {
  Final int initialIndex;
  Const MainNavigationHub({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationHub> createState() => MainNavigationHubState();
}

class MainNavigationHubState extends State<MainNavigationHub> {
  Late int _currentIndex;

  @override
  void initState() {
    Super.initState();
    _currentIndex = widget.initialIndex;
  }

  Void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Final List<Widget> _pages = [
    Const HomeScreen(),
    Const GamesScreen(),
    Const WalletScreen(),
    Const ChatScreen(),
    Const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    Return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, -5))]),
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

// ================= 3. الشاشة الرئيسية =================
class HomeScreen extends StatelessWidget {
  Const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('RAYID PAY', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
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
                        Text('متصل', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xff162231), Color(0xff0e151f)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 15, offset: const Offset(0, 8))],
                  border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('مرحباً لاعب_570575 !', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('بوابتك الاحترافية للأموال والألعاب', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: const Color(0xff1b2635), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.amber.withOpacity(0.3))),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: const Color(0xff1b2635), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.greenAccent.withOpacity(0.3))),
                            child: Row(
                              children: const [
                                Text('💵', style: TextStyle(fontSize: 22)),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('الرصيد', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    Text('\$45.50', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
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
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(colors: [Color(0xff122623), Color(0xff0b161f)], begin: Alignment.topRight, end: Alignment.bottomLeft),
                  border: Border.all(color: const Color(0xff00ff88).withOpacity(0.6), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('اربح نقاط مجانية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        Icon(Icons.video_collection, color: Color(0xff00ff88), size: 28),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text('شاهد إعلانات قصيرة واكسب نقاط فورية لرصيدك', style: TextStyle(fontSize: 13, color: Color(0xff00ff88))),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00ff88),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري عرض الإعلان... تم إضافة +50 نقطة!'), backgroundColor: Colors.green));
                      },
                      child: const Text('شاهد واربح الآن', style: TextStyle(fontWeight: FontWeight.bold)),
                    )
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

// ================= 4. شاشة الألعاب =================
class GamesScreen extends StatelessWidget {
  Const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Return Scaffold(
      appBar: AppBar(title: const Text('قسم الألعاب والترفيه'), backgroundColor: const Color(0xff0b1017), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildGameCard(context, 'NEON CYBER RUN', 'تحدي الركض الترفيهي الفخم', const Color(0xff00ff88), Icons.bolt),
          _buildGameCard(context, 'لودو النيون التنافسية', 'العب للتسلية مع الأصدقاء', Colors.amber, Icons.casino),
          _buildGameCard(context, 'الشطرنج الاستراتيجي الذكي', 'مباريات هادئة وممتعة', const Color(0xff00e5ff), Icons.extension),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String title, String subtitle, Color color, IconData icon) {
    Return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff121b26),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.4), width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
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
            style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('قريباً سيتم إطلاق لعبة $title!'), backgroundColor: Colors.grey[900]),
              );
            },
            child: const Text('قريباً', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ================= 5. شاشة الرصيد وطرق السحب =================
class WalletScreen extends StatelessWidget {
  Const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Return Scaffold(
      appBar: AppBar(title: const Text('الرصيد والنقاط'), backgroundColor: const Color(0xff0b1017), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xff122b20), Color(0xff0e171f)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.5), width: 1.5),
              ),
              child: Column(
                children: [
                  const Text('الرصيد الكلي المتاح', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 8),
                  const Text('\$45.50 USD', style: TextStyle(color: Colors.greenAccent, fontSize: 32, fontWeight: FontWeight.bold)),
                  const Divider(color: Colors.white12, height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text('🪙 النقاط: 1,240', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                      Text('⚡ التفاعل: نشط', style: TextStyle(color: Color(0xff00ff88), fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerRight,
              child: Text('طرق السحب المتاحة (اضغط للدخول)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 12),
            _buildQuickTile(context, 'AsiaCell Cash (آسياسيل)', Colors.red, Icons.phone_android),
            _buildQuickTile(context, 'ZainCash (زين كاش)', Colors.orange, Icons.phone_iphone),
            _buildQuickTile(context, 'MasterCard (ماستر كارد)', Colors.blue, Icons.credit_card),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTile(BuildContext context, String title, Color color, IconData icon) {
    Return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xff121b26), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.3))),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: const Text('انقر لإتمام عملية السحب', style: TextStyle(color: Colors.grey, fontSize: 11)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xff00ff88), size: 16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => WithdrawalDetailScreen(methodName: title)));
        },
      ),
    );
  }
}

// شاشة تفاصيل السحب
class WithdrawalDetailScreen extends StatelessWidget {
  Final String methodName;
  Const WithdrawalDetailScreen({super.key, required this.methodName});

  @override
  Widget build(BuildContext context) {
    Return Scaffold(
      appBar: AppBar(title: Text('سحب عبر $methodName'), backgroundColor: const Color(0xff0b1017)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('أنت تقوم الآن بسحب أرباحك عبر $methodName', style: const TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: 'رقم الحساب / المحفظة', labelStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xff121b26), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)),
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: 'المبلغ المراد سحبه (\$ USD)', labelStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xff121b26), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00ff88), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال طلب السحب بنجاح!'), backgroundColor: Colors.green));
              },
              child: const Text('تأكيد وإرسال الطلب', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= 6. شاشة الدردشة =================
class ChatScreen extends StatelessWidget {
  Const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Return Scaffold(
      appBar: AppBar(title: const Text('الدردشة العامة للمجتمع'), backgroundColor: const Color(0xff0b1017), automaticallyImplyLeading: false),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildChatBubble('أحمد الكرخي', 'مرحباً شباب، هل تم إطلاق لعبة النيون اليوم؟', '4:10 م', false),
                _buildChatBubble('محمد (المطور)', 'أهلاً بك! نعم التطبيق قيد التحديث المستمر.', '4:12 م', true),
                _buildChatBubble('ساره الأحمد', 'رائع جداً، التطبيق فخم ومرتب عاشت ايدكم.', '4:15 م', false),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xff0b1017),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك للمجتمع...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xff121b26),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xff00ff88),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.black, size: 18),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال الرسالة بنجاح!')));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String sender, String message, String time, bool isMe) {
    Return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xff00ff88).withOpacity(0.15) : const Color(0xff121b26),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isMe ? const Color(0xff00ff88).withOpacity(0.4) : Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sender, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isMe ? const Color(0xff00ff88) : Colors.amber)),
            const SizedBox(height: 4),
            Text(message, style: const TextStyle(color: Colors.white, fontSize: 13)),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(time, style: const TextStyle(color: Colors.grey, fontSize: 9)),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= 7. شاشة الإعدادات =================
class SettingsScreen extends StatelessWidget {
  Const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Return Scaffold(
      appBar: AppBar(title: const Text('إعدادات الحساب'), backgroundColor: const Color(0xff0b1017), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xff00ff88), width: 2)),
                  child: const CircleAvatar(radius: 40, backgroundColor: Color(0xff121b26), child: Icon(Icons.person, size: 40, color: Color(0xff00ff88))),
                ),
                const SizedBox(height: 12),
                const Text('لاعب_570575', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                const Text('ID: #RAYID-9924', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSettingTile(context, Icons.person_outline, 'تعديل الملف الشخصي', () {}),
          _buildSettingTile(context, Icons.security, 'الأمان وحماية الحساب', () {}),
          _buildSettingTile(context, Icons.notifications_none, 'إعدادات الإشعارات', () {}),
          _buildSettingTile(context, Icons.language, 'لغة التطبيق (العربية)', () {}),
          _buildSettingTile(context, Icons.help_outline, 'الدعم الفني والمساعدة', () {}),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.15),
              foregroundColor: Colors.redAccent,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.redAccent, width: 1)),
            ),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل الخروج بنجاح')));
            },
            child: const Text('تسجيل الخروج', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    Return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xff121b26), borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xff00ff88)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: onTap,
      ),
    );
  }
}
