import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const CashPlusApp());
}

class CashPlusApp extends StatelessWidget {
  const CashPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rayid Rewards',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080C14),
        primaryColor: const Color(0xFF00FF88),
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
        builder: (context) => CashPlusHomePage(isAdmin: isManager),
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
            colors: [Color(0xFF0D1B2A), Color(0xFF080C14)],
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
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00FF88).withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.bolt_rounded, color: Color(0xFF00FF88), size: 75),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'RAYID REWARDS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'منصة الترفيه والمكافآت المستقبلية',
                    style: TextStyle(color: Color(0xFF00E5FF), fontSize: 13, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 35),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني أو الهاتف',
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF00FF88)),
                      filled: true,
                      fillColor: const Color(0xFF111E30),
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
                      fillColor: const Color(0xFF111E30),
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
                      onPressed: _validateAndLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FF88),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 10,
                        shadowColor: const Color(0xFF00FF88).withOpacity(0.5),
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
                      label: const Text('المصادقة السريعة بالبصمة', style: TextStyle(fontSize: 14, color: Color(0xFF00E5FF), fontWeight: FontWeight.bold)),
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
                      style: TextStyle(color: Color(0xFF00FF88), fontSize: 13),
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

// ================= 2. شاشة تسجيل حساب جديد =================
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
            colors: [Color(0xFF0D1B2A), Color(0xFF080C14)],
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
                      fillColor: const Color(0xFF111E30),
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
                      fillColor: const Color(0xFF111E30),
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
                      fillColor: const Color(0xFF111E30),
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

// ================= 3. الصفحة الرئيسية الفخمة بأسلوب النيون =================
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
    double usdValue = _points / 1000;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        title: Row(
          children: [
            Icon(widget.isAdmin ? Icons.admin_panel_settings : Icons.verified_user, color: const Color(0xFF00FF88), size: 20),
            const SizedBox(width: 8),
            const Text(
              'NEON ARCADE', 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF00FF88).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.5)),
            ),
            child: const Row(
              children: [
                CircleAvatar(radius: 3, backgroundColor: Color(0xFF00FF88)),
                SizedBox(width: 6),
                Text('متصل', style: TextStyle(color: Color(0xFF00FF88), fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white70),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF080C14)],
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
                    border: Border.all(color: Colors.amber),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 8),
                      Text('أهلاً بك يا بطل! أنت تعمل بصلاحيات المدير الكاملة', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),

              // بطاقة الرصيد الفخمة
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF132B3E), Color(0xFF0D1B2A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.4), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00FF88).withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('رصيدك الحالي', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00FF88).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF00FF88), size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\$ ${usdValue.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: 1),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'واصل نشاطك واجمع المكافآت اليومية',
                      style: TextStyle(color: Color(0xFF00FF88), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'الرصيد التراكمي: $_points نقطة',
                      style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'الخدمات السريعة والأقسام',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70),
              ),
              const SizedBox(height: 14),

              // شبكة الأقسام الأربعة
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.12,
                children: [
                  _buildNeonCard(
                    'الألعاب',
                    'تحدي الركض والأركيد',
                    Icons.sports_esports_rounded,
                    const Color(0xFF00FF88),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GamesScreen()),
                      );
                    },
                  ),
                  _buildNeonCard(
                    _canWatchAd ? 'مشاهدة الإعلانات' : 'انتظر (${_countdownSeconds}ث)',
                    _canWatchAd ? 'شاهد واربح' : 'مغلق مؤقتاً',
                    Icons.play_circle_filled_rounded,
                    const Color(0xFF00E5FF),
                    _canWatchAd ? _startAdCooldown : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('يرجى الانتظار حتى ينتهي عداد الإعلان')),
                      );
                    },
                  ),
                  _buildNeonCard(
                    'المحفظة',
                    'أرباحك وسحبك',
                    Icons.account_balance_wallet_rounded,
                    Colors.amber,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RedeemScreen()),
                      );
                    },
                  ),
                  _buildNeonCard(
                    'الدردشة',
                    'تواصل مع الأصدقاء',
                    Icons.chat_bubble_outline_rounded,
                    const Color(0xFFFF007F),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GlobalChatScreen()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeonCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF111E30),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.35), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// ================= 4. شاشة الألعاب الترفيهية (مع تفعيل لعبة تفاعلية حقيقية) =================
class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قسم الألعاب والتحدي'),
        backgroundColor: const Color(0xFF0D1B2A),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF080C14)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'اختر لعبتك المفضلة واكسب النقاط:',
              style: TextStyle(fontSize: 14, color: Color(0xFF00E5FF)),
            ),
            const SizedBox(height: 16),
            _buildGameCard(
              context, 
              'Neon Cyber Runner', 
              'لعبة ركض أركيد تفاعلية (شغالة الآن!)', 
              Icons.bolt_rounded, 
              const Color(0xFF00FF88),
              const NeonRunnerGameScreen(),
            ),
            _buildGameCard(
              context, 
              'لعبة لودو النيون (Ludo Star)', 
              'تحدى الأصدقاء بأجواء مستقبلية', 
              Icons.casino_rounded, 
              Colors.amber,
              null,
            ),
            _buildGameCard(
              context, 
              'الشطرنج الاستراتيجي (Chess)', 
              'مباريات ذكاء وهدوء', 
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
      color: const Color(0xFF111E30),
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
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
          child: const Text('ابدأ اللعب', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// ================= 5. شاشة لعبة الركض التفاعلية (Neon Runner Game) =================
class NeonRunnerGameScreen extends StatefulWidget {
  const NeonRunnerGameScreen({super.key});

  @override
  State<NeonRunnerGameScreen> createState() => _NeonRunnerGameScreenState();
}

class _NeonRunnerGameScreenState extends State<NeonRunnerGameScreen> {
  int _score = 0;
  bool _isPlaying = false;
  Timer? _gameTimer;
  double _obstaclePosition = 300.0;
  int _playerLane = 1; // 0: يسار, 1: وسط, 2: يمين

  void _startGame() {
    setState(() {
      _score = 0;
      _isPlaying = true;
      _obstaclePosition = 300.0;
    });

    _gameTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        _obstaclePosition -= 7;
        if (_obstaclePosition < 0) {
          _obstaclePosition = 400.0;
          _score += 10; // زيادة النقاط عند تفادي الحجز
        }
      });
    });
  }

  void _stopGame() {
    _gameTimer?.cancel();
    setState(() {
      _isPlaying = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('انتهت اللعبة! جمعت $_score نقطة تفوق')),
    );
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neon Cyber Runner'),
        backgroundColor: const Color(0xFF0D1B2A),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF080C14)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('النقاط: $_score', style: const TextStyle(color: Color(0xFF00FF88), fontSize: 20, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: _isPlaying ? Colors.red : const Color(0xFF00FF88), foregroundColor: Colors.black),
                    onPressed: _isPlaying ? _stopGame : _startGame,
                    child: Text(_isPlaying ? 'إيقاف' : 'بدء اللعبة', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF111E30),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.5), width: 2),
                ),
                child: Stack(
                  children: [
                    // خطوط المسارات بأسلوب النيون
                    Positioned.fill(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(width: 2, color: Colors.white12),
                          Container(width: 2, color: Colors.white12),
                        ],
                      ),
                    ),
                    // حاجز النيون المتحرك
                    if (_isPlaying)
                      Positioned(
                        top: _obstaclePosition,
                        left: _playerLane == 0 ? 30 : (_playerLane == 1 ? 150 : 270),
                        child: Container(
                          width: 60,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.6), blurRadius: 10)],
                          ),
                          child: const Center(child: Text('حاجز', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                        ),
                      ),
                    // اللاعب (شخصية النيون)
                    Positioned(
                      bottom: 40,
                      left: _playerLane == 0 ? 35 : (_playerLane == 1 ? 155 : 275),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF00FF88),
                          boxShadow: [BoxShadow(color: const Color(0xFF00FF88).withOpacity(0.8), blurRadius: 15)],
                        ),
                        child: const Icon(Icons.bolt, color: Colors.black, size: 30),
                      ),
                    ),
                    if (!_isPlaying)
                      const Center(
                        child: Text(
                          'اضغط "بدء اللعبة" للبدء بالركض!',
                          style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // أزرار التحكم بالركض يمين ويسار
            if (_isPlaying)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), foregroundColor: Colors.black),
                      onPressed: () => setState(() => _playerLane = 0),
                      child: const Icon(Icons.arrow_left_rounded, size: 30),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF88), foregroundColor: Colors.black),
                      onPressed: () => setState(() => _playerLane = 1),
                      child: const Icon(Icons.arrow_upward_rounded, size: 30),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), foregroundColor: Colors.black),
                      onPressed: () => setState(() => _playerLane = 2),
                      child: const Icon(Icons.arrow_right_rounded, size: 30),
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

// ================= 6. شاشة طرق السحب والمحافظ =================
class RedeemScreen extends StatelessWidget {
  const RedeemScreen({super.key});

  void _showRedeemDialog(BuildContext context, String methodTitle, String minAmount) {
    final TextEditingController accountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF111E30),
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
                fillColor: const Color(0xFF080C14),
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
        title: const Text('طرق سحب الأرباح (\$ USD)'),
        backgroundColor: const Color(0xFF0D1B2A),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF080C14)],
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
      color: const Color(0xFF111E30),
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
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF00FF88), fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF00FF88)),
        onTap: onTap,
      ),
    );
  }
}

// ================= 7. شاشة الإعدادات =================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات والحساب'),
        backgroundColor: const Color(0xFF0D1B2A),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF080C14)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xFF00E5FF)),
              title: const Text('سياسة الخصوصية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF00FF88)),
              onTap: () {},
            ),
            const Divider(color: Colors.white12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('تسجيل الخروج'),
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

// ================= 8. الدردشة العامة =================
class GlobalChatScreen extends StatefulWidget {
  const GlobalChatScreen({super.key});

  @override
  State<GlobalChatScreen> createState() => _GlobalChatScreenState();
}

class _GlobalChatScreenState extends State<GlobalChatScreen> {
  final List<String> _messages = ['أهلاً بالجميع في Neon Arcade!', 'منو سحب أرباح اليوم؟'];
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
        title: const TestTitle('الدردشة العامة'),
        backgroundColor: const Color(0xFF0D1B2A),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF080C14)],
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
                      color: const Color(0xFF111E30),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.2)),
                    ),
                    child: Text(_messages[index], style: const TextStyle(color: Colors.white)),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: const Color(0xFF0D1B2A),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      decoration: const InputDecoration(
                        hintText: 'اكتب رسالتك هنا...',
                        hintStyle: TextStyle(color: Colors.grey),
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

class TestTitle extends StatelessWidget {
  final String title;
  const TestTitle(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Text(title);
}
