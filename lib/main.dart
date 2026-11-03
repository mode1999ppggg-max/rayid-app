import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const RayidApp());
}

class RayidApp extends StatelessWidget {
  const RayidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rayid Rewards',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF070B12),
        primaryColor: const Color(0xFF00FF88),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF88),
          secondary: Color(0xFF00E5FF),
          surface: Color(0xFF101826),
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
  final LocalAuthentication _auth = LocalAuthentication();

  final String adminSecretKey = "Mooamalfared1999%£#&@"; 

  void _proceedLogin(bool isManager) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigationHub(isAdmin: isManager),
      ),
    );
  }

  void _validateAndLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال البريد الإلكتروني وكلمة المرور')),
      );
      return;
    }

    bool isAdmin = (password == adminSecretKey);
    _proceedLogin(isAdmin);
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      bool canCheckBiometrics = await _auth.canCheckBiometrics;
      bool isSupported = await _auth.isDeviceSupported();

      if (!canCheckBiometrics || !isSupported) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('البصمة غير مدعومة في هذا الجهاز')),
        );
        return;
      }

      bool authenticated = await _auth.authenticate(
        localizedReason: 'يرجى تأكيد بصمة الوجه أو الإصبع للدخول',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        _proceedLogin(true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في المصادقة: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF070B12)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF101826),
                      border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.3), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00FF88).withOpacity(0.25),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.bolt_rounded, color: Color(0xFF00FF88), size: 70),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'RAYID REWARDS',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'منصة الترفيه والأموال الذكية',
                    style: TextStyle(color: Color(0xFF00E5FF), fontSize: 13, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني أو الهاتف',
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF00FF88)),
                      filled: true,
                      fillColor: const Color(0xFF101826),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF00FF88)),
                      filled: true,
                      fillColor: const Color(0xFF101826),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _validateAndLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FF88),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 8,
                        shadowColor: const Color(0xFF00FF88).withOpacity(0.4),
                      ),
                      child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _authenticateWithBiometrics,
                      icon: const Icon(Icons.fingerprint, color: Color(0xFF00E5FF)),
                      label: const Text('الدخول السريع بالبصمة', style: TextStyle(fontSize: 14, color: Color(0xFF00E5FF), fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF00E5FF), width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      'ليس لديك حساب؟ إنشاء حساب جديد',
                      style: TextStyle(color: Color(0xFF00FF88), fontSize: 13, fontWeight: FontWeight.w600),
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

// ================= 2. شاشة إنشاء حساب جديد =================
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _registerUser() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء ملء كافة الحقول المطلوبة')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمتا المرور غير متطابقتين')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إنشاء الحساب بنجاح! يرجى تسجيل الدخول')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
        backgroundColor: const Color(0xFF0D1B2A),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF070B12)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF00FF88), size: 70),
                  const SizedBox(height: 16),
                  const Text(
                    'انضم إلى Rayid Rewards',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'أنشئ حساباً مشفراً وابدأ بتحقيق الأرباح',
                    style: TextStyle(color: Color(0xFF00E5FF), fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 35),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF00FF88)),
                      filled: true,
                      fillColor: const Color(0xFF101826),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF00FF88)),
                      filled: true,
                      fillColor: const Color(0xFF101826),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'تأكيد كلمة المرور',
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.lock_reset, color: Color(0xFF00FF88)),
                      filled: true,
                      fillColor: const Color(0xFF101826),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FF88),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('تسجيل وحفظ الحساب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

// ================= 3. شريط التنقل السفلي والتحكم بالصفحات =================
class MainNavigationHub extends StatefulWidget {
  final bool isAdmin;
  const MainNavigationHub({super.key, required this.isAdmin});

  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      CashPlusHomePage(isAdmin: widget.isAdmin),
      const GamesScreen(),
      const RedeemScreen(),
      const GlobalChatScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF101826),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF00FF88),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_esports_rounded),
              label: 'الألعاب',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_rounded),
              label: 'المحفظة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded),
              label: 'الدردشة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }
}

// ================= 4. الصفحة الرئيسية (بدون بطاقة الرصيد التي في المنتصف) =================
class CashPlusHomePage extends StatefulWidget {
  final bool isAdmin;
  const CashPlusHomePage({super.key, required this.isAdmin});

  @override
  State<CashPlusHomePage> createState() => _CashPlusHomePageState();
}

class _CashPlusHomePageState extends State<CashPlusHomePage> {
  int _points = 30; 
  bool _canWatchAd = true;
  int _countdownSeconds = 0;
  Timer? _timer;

  void _addPoints(int amount) {
    setState(() {
      _points += amount;
    });
  }

  void _startAdCooldown() {
    setState(() {
      _canWatchAd = false;
      _countdownSeconds = 15; 
    });

    _addPoints(30);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('مبروك! تم إضافة 30 نقطة لرصيدك بنجاح')),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() {
          _countdownSeconds--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _canWatchAd = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF070B12),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF00FF88).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.isAdmin ? Icons.admin_panel_settings : Icons.verified_user, color: const Color(0xFF00FF88), size: 18),
            ),
            const SizedBox(width: 10),
            const Text(
              'RAYID PAY', 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF00FF88).withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.4)),
            ),
            child: const Row(
              children: [
                CircleAvatar(radius: 3, backgroundColor: Color(0xFF00FF88)),
                SizedBox(width: 6),
                Text('متصل', style: TextStyle(color: Color(0xFF00FF88), fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF070B12)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isAdmin)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber.withOpacity(0.5)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text('وضع المدير مفعل - صلاحيات كاملة', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),

              const Text(
                'الخدمات والأقسام الرئيسية',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white70),
              ),
              const SizedBox(height: 14),

              // شبكة الخدمات والأقسام
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.12,
                children: [
                  _buildDashboardCard(
                    'الألعاب والمسابقات',
                    'تحدي الركض والنقاط',
                    Icons.sports_esports_rounded,
                    const Color(0xFF00FF88),
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GamesScreen())),
                  ),
                  _buildDashboardCard(
                    _canWatchAd ? 'المكافآت اليومية' : 'انتظر (${_countdownSeconds}ث)',
                    _canWatchAd ? 'شاهد واربح 30 نقطة' : 'قيد الانتظار',
                    Icons.play_circle_filled_rounded,
                    const Color(0xFF00E5FF),
                    _canWatchAd ? _startAdCooldown : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('يرجى الانتظار حتى ينتهي عداد المكافأة')),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    'محفظة الأرباح',
                    'سحب وإدارة الأموال',
                    Icons.account_balance_wallet_rounded,
                    Colors.amber,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RedeemScreen())),
                  ),
                  _buildDashboardCard(
                    'الدردشة العامة',
                    'تواصل مع المجتمع',
                    Icons.chat_bubble_outline_rounded,
                    const Color(0xFFFF007F),
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GlobalChatScreen())),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // النشاطات والمعاملات الأخيرة
              const Text(
                'النشاطات والمعاملات الأخيرة',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF101826),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Column(
                  children: [
                    _buildActivityItem('مكافأة تسجيل الدخول اليومي', '+30 نقطة', const Color(0xFF00FF88), Icons.card_giftcard),
                    const Divider(color: Colors.white10, height: 20),
                    _buildActivityItem('جلسة لعب Neon Cyber Run', '+120 نقطة', const Color(0xFF00E5FF), Icons.sports_esports),
                    const Divider(color: Colors.white10, height: 20),
                    _buildActivityItem('حالة المحفظة الآمنة', 'مفعلة ومنفتحة', Colors.amber, Icons.security),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF101826),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, Color color, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
        Text(subtitle, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ================= 5. شاشة الألعاب والمسابقات =================
class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قسم الألعاب والتحدي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF070B12),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF070B12)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'اختر لعبتك المفضلّة واكسب أرباحاً فورية:',
              style: TextStyle(fontSize: 13, color: Color(0xFF00E5FF), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildGameCard(
              context, 
              'NEON CYBER RUN', 
              'لعبة الكرة المضيئة والركض المستقبلي (مفاعلة بالكامل)', 
              Icons.bolt_rounded, 
              const Color(0xFF00FF88),
              const NeonCyberRunGameScreen(),
            ),
            _buildGameCard(
              context, 
              'لعبة لودو النيون (Ludo Star)', 
              'تحدى الأصدقاء بأجواء ترفيهية مستقبلية', 
              Icons.casino_rounded, 
              Colors.amber,
              null,
            ),
            _buildGameCard(
              context, 
              'الشطرنج الاستراتيجي (Chess)', 
              'مباريات ذكاء وهدوء تنافسية', 
              Icons.sports_esports_rounded, 
              const Color(0xFF00E5FF),
              null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String title, String subtitle, IconData icon, Color color, Widget? gameScreen) {
    return Card(
      color: const Color(0xFF101826),
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: color.withOpacity(0.3), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color.withOpacity(0.2),
            foregroundColor: color,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            if (gameScreen != null) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => gameScreen));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('هذه اللعبة قيد التحديث وسيتم إطلاقها قريباً!')),
              );
            }
          },
          child: const Text('العب الآن', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// ================= 6. شاشة لعبة Neon Cyber Run =================
class NeonCyberRunGameScreen extends StatefulWidget {
  const NeonCyberRunGameScreen({super.key});

  @override
  State<NeonCyberRunGameScreen> createState() => _NeonCyberRunGameScreenState();
}

class _NeonCyberRunGameScreenState extends State<NeonCyberRunGameScreen> with SingleTickerProviderStateMixin {
  int _score = 120;
  int _coins = 12;
  int _distance = 45;
  int _level = 1;
  bool _isPlaying = false;
  Timer? _timer;
  int _playerLane = 1;

  late AnimationController _colorController;
  final List<Color> _neonColors = [
    const Color(0xFF00FF88),
    const Color(0xFF00E5FF),
    const Color(0xFFFF007F),
    const Color(0xFFFFB703),
  ];
  int _colorIndex = 0;

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _colorController.addListener(() {
      if (_isPlaying) {
        setState(() {
          _colorIndex = (_colorController.value * _neonColors.length).floor() % _neonColors.length;
        });
      }
    });
  }

  void _startGame() {
    setState(() {
      _isPlaying = true;
      _score = 120;
      _distance = 45;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        _distance += 5; 
        _score += 15;
        if (_distance % 100 == 0) {
          _coins += 1;
          _level = (_distance / 200).floor() + 1;
        }
      });
    });
  }

  void _stopGame() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('نهاية الجولة! جمعت $_score نقطة و $_coins عملة')),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color currentColor = _neonColors[_colorIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF050811),
      appBar: AppBar(
        title: const Text('NEON CYBER RUN', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
        backgroundColor: const Color(0xFF0D1B2A),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: NeonRoadPainter(isMoving: _isPlaying),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('SCORE', style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1)),
                        Text('$_score', style: const TextStyle(color: Color(0xFFFFB703), fontSize: 22, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        const Text('COINS', style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1)),
                        Row(
                          children: [
                            const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text('$_coins', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('LEVEL', style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1)),
                        Text('$_level', style: const TextStyle(color: Color(0xFF00FF88), fontSize: 22, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        const Text('DISTANCE', style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1)),
                        Text('${_distance}m', style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 16, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('BOOST 95%', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('ACTIVE BALL', style: TextStyle(color: currentColor, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (!_isPlaying)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00FF88),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: _startGame,
                          child: const Text('اضغط هنا لبدء لعبة الكرة المضيئة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), foregroundColor: Colors.black),
                            onPressed: () => setState(() => _playerLane = 0),
                            child: const Icon(Icons.arrow_left_rounded, size: 30),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                            onPressed: _stopGame,
                            child: const Text('إيقاف', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF88), foregroundColor: Colors.black),
                            onPressed: () => setState(() => _playerLane = 2),
                            child: const Icon(Icons.arrow_right_rounded, size: 30),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            bottom: 120,
            left: _playerLane == 0 
                ? MediaQuery.of(context).size.width * 0.28 
                : (_playerLane == 1 ? MediaQuery.of(context).size.width * 0.44 : MediaQuery.of(context).size.width * 0.60),
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentColor,
                boxShadow: [
                  BoxShadow(color: currentColor.withOpacity(0.9), blurRadius: 25, spreadRadius: 5),
                  const BoxShadow(color: Colors.white, blurRadius: 5, spreadRadius: 1),
                ],
              ),
              child: const Center(
                child: Icon(Icons.bolt, color: Colors.black, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NeonRoadPainter extends CustomPainter {
  final bool isMoving;
  NeonRoadPainter({required this.isMoving});

  @override
  void paint(Canvas canvas, Size size) {
    final paintRoad = Paint()
      ..color = const Color(0xFF0B132B)
      ..style = PaintingStyle.fill;

    final paintLines = Paint()
      ..color = const Color(0xFF00E5FF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final paintGlow = Paint()
      ..color = const Color(0xFF00FF88).withOpacity(0.4)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    Path roadPath = Path();
    roadPath.moveTo(size.width * 0.15, size.height);
    roadPath.lineTo(size.width * 0.85, size.height);
    roadPath.lineTo(size.width * 0.58, size.height * 0.35);
    roadPath.lineTo(size.width * 0.42, size.height * 0.35);
    roadPath.close();

    canvas.drawPath(roadPath, paintRoad);

    canvas.drawLine(ui.Offset(size.width * 0.15, size.height), ui.Offset(size.width * 0.42, size.height * 0.35), paintGlow);
    canvas.drawLine(ui.Offset(size.width * 0.85, size.height), ui.Offset(size.width * 0.58, size.height * 0.35), paintGlow);

    canvas.drawLine(ui.Offset(size.width * 0.15, size.height), ui.Offset(size.width * 0.42, size.height * 0.35), paintLines);
    canvas.drawLine(ui.Offset(size.width * 0.85, size.height), ui.Offset(size.width * 0.58, size.height * 0.35), paintLines);
  }

  @override
  bool shouldRepaint(covariant NeonRoadPainter oldDelegate) => oldDelegate.isMoving != isMoving;
}

// ================= 7. شاشة المحفظة وطرق السحب =================
class RedeemScreen extends StatelessWidget {
  const RedeemScreen({super.key});

  void _showRedeemDialog(BuildContext context, String methodTitle, String minAmount) {
    final TextEditingController accountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF101826),
        title: Text('سحب الأرباح عبر $methodTitle', style: const TextStyle(color: Color(0xFF00FF88), fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الحد الأدنى للسحب: $minAmount', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),
            TextField(
              controller: accountController,
              decoration: InputDecoration(
                labelText: 'أدخل رقم الحساب أو المحفظة',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF070B12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF88), foregroundColor: Colors.black),
            onPressed: () {
              if (accountController.text.trim().isEmpty) return;
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم تقديم طلب السحب عبر $methodTitle بنجاح!')),
              );
            },
            child: const Text('تأكيد الطلب', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محفظة سحب الأرباح (\$ USD)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF070B12),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF070B12)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildRedeemOption(context, 'AsiaCell Cash (آسياسيل)', '\$5 USD الحد الأدنى', Icons.sim_card, Colors.red, () => _showRedeemDialog(context, 'آسياسيل', '\$5 USD')),
            _buildRedeemOption(context, 'ZainCash (زين كاش)', '\$5 USD الحد الأدنى', Icons.phone_android, Colors.orange, () => _showRedeemDialog(context, 'زين كاش', '\$5 USD')),
            _buildRedeemOption(context, 'MasterCard (ماستر كارد)', '\$10 USD الحد الأدنى', Icons.credit_card, Colors.blue, () => _showRedeemDialog(context, 'ماستر كارد', '\$10 USD')),
            _buildRedeemOption(context, 'PayPal (بايبال)', '\$10 USD الحد الأدنى', Icons.account_balance_wallet, Colors.indigo, () => _showRedeemDialog(context, 'بايبال', '\$10 USD')),
          ],
        ),
      ),
    );
  }

  Widget _buildRedeemOption(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      color: const Color(0xFF101826),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF00FF88), fontSize: 11)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF00FF88)),
        onTap: onTap,
      ),
    );
  }
}

// ================= 8. شاشة الدردشة العامة =================
class GlobalChatScreen extends StatefulWidget {
  const GlobalChatScreen({super.key});

  @override
  State<GlobalChatScreen> createState() => _GlobalChatScreenState();
}

class _GlobalChatScreenState extends State<GlobalChatScreen> {
  final List<String> _messages = ['أهلاً بالجميع في مجتمع Rayid Pay!', 'منو سحب أرباحه اليوم؟'];
  final _msgController = TextEditingController();

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    setState(() {
      _messages.add(_msgController.text.trim());
      _msgController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدردشة العامة للمجتمع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF070B12),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF070B12)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF101826),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.2)),
                    ),
                    child: Text(_messages[index], style: const TextStyle(color: Colors.white, fontSize: 13)),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              color: const Color(0xFF070B12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      decoration: const InputDecoration(
                        hintText: 'اكتب رسالتك هنا...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: Color(0xFF00FF88)),
                    onPressed: _sendMessage,
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

// ================= 9. شاشة الإعدادات =================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات والحساب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF070B12),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF070B12)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xFF00E5FF)),
              title: const Text('سياسة الخصوصية والشروط', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF00FF88)),
              onTap: () {},
            ),
            const Divider(color: Colors.white12),
            ListTile(
              leading: const Icon(Icons.security, color: Color(0xFF00FF88)),
              title: const Text('أمان الحساب والمصادقة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF00FF88)),
              onTap: () {},
            ),
            const Divider(color: Colors.white12),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
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
      ),
    );
  }
}
