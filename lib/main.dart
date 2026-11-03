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
      title: 'Cash Plus',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF121816),
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security, color: Colors.green, size: 70),
                const SizedBox(height: 16),
                const Text(
                  'Cash Plus - تسجيل الدخول',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  'ادخل بيانات حسابك للوصول إلى أرباحك',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني أو الهاتف',
                    prefixIcon: const Icon(Icons.person, color: Colors.green),
                    filled: true,
                    fillColor: const Color(0xFF1E2A27),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
                    prefixIcon: const Icon(Icons.lock, color: Colors.green),
                    filled: true,
                    fillColor: const Color(0xFF1E2A27),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _validateAndLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _authenticateWithBiometrics,
                    icon: const Icon(Icons.fingerprint, color: Colors.greenAccent),
                    label: const Text('تسجيل الدخول بالبصمة', style: TextStyle(fontSize: 15, color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.greenAccent, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    style: TextStyle(color: Colors.greenAccent, fontSize: 14),
                  ),
                ),
              ],
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
        backgroundColor: const Color(0xFF1A2321),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_add, color: Colors.green, size: 70),
                const SizedBox(height: 16),
                const Text(
                  'انضم إلى Cash Plus',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  'أنشئ حساباً آمناً وابدأ بجمع الأرباح بالدولار',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: const Icon(Icons.email, color: Colors.green),
                    filled: true,
                    fillColor: const Color(0xFF1E2A27),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
                    prefixIcon: const Icon(Icons.lock, color: Colors.green),
                    filled: true,
                    fillColor: const Color(0xFF1E2A27),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
                    filled: true,
                    fillColor: const Color(0xFF1E2A27),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('تسجيل وحفظ الحساب', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= 3. الصفحة الرئيسية =================
class CashPlusHomePage extends StatefulWidget {
  final bool isAdmin;
  const CashPlusHomePage({super.key, required this.isAdmin});

  @override
  State<CashPlusHomePage> createState() => _CashPlusHomePageState();
}

class _CashPlusHomePageState extends State<CashPlusHomePage> {
  int _points = 0; 
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
      const SnackBar(content: Text('مبروك! تم إضافة 30 نقطة برصيدك')),
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
        backgroundColor: const Color(0xFF1A2321),
        title: Row(
          children: [
            Icon(widget.isAdmin ? Icons.admin_panel_settings : Icons.monetization_on, color: widget.isAdmin ? Colors.amber : Colors.green, size: 24),
            const SizedBox(width: 8),
            Text(
              widget.isAdmin ? 'Cash Plus (Admin)' : 'Cash Plus', 
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat, color: Colors.greenAccent),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const GlobalChatScreen()));
            },
            tooltip: 'الدردشة العامة',
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events, color: Colors.amber),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AchievementsScreen()));
            },
            tooltip: 'الإنجازات',
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
            tooltip: 'الإعدادات',
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('أهلاً بك يا بطل! أنت الآن بصلاحيات (مدير التطبيق الكاملة)', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2A27),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text('Available Points', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    '$_points Pts',
                    style: const TextStyle(color: Colors.amber, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Balance: \$${usdValue.toStringAsFixed(2)} USD',
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RedeemScreen()),
                      );
                    },
                    icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
                    label: const Text('Redeem Now (\$ USD)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'Earn More Points',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildTaskCard(
                  _canWatchAd ? 'Watch Ad Video' : 'انتظر (${_countdownSeconds}ث)',
                  _canWatchAd ? '+30 Pts' : 'مغلق مؤقتاً',
                  Icons.play_circle_fill,
                  _canWatchAd ? Colors.blue : Colors.grey,
                  _canWatchAd ? _startAdCooldown : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('يرجى الانتظار حتى ينتهي عداد الإعلان')),
                    );
                  },
                ),
                _buildTaskCard('Refer a Friend', '+2500 Pts', Icons.card_giftcard, Colors.purple, () {
                  _addPoints(2500);
                }),
                _buildTaskCard('Daily Bonus', '+100 Pts', Icons.star, Colors.amber, () {
                  _addPoints(100);
                }),
                _buildTaskCard('Complete Profile', '+500 Pts', Icons.person_add, Colors.teal, () {
                  _addPoints(500);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(String title, String reward, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2A27),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
            const SizedBox(height: 4),
            Text(reward, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ================= 4. شاشة طرق السحب بالدولار والمحافظ =================
class RedeemScreen extends StatefulWidget {
  const RedeemScreen({super.key});

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  
  void _showRedeemDialog(BuildContext context, String methodTitle, String minAmount) {
    final TextEditingController accountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E2A27),
        title: Text('سحب الأرباح عبر $methodTitle', style: const TextStyle(color: Colors.greenAccent, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الحد الأدنى للسحب: $minAmount', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: accountController,
              decoration: InputDecoration(
                labelText: methodTitle.contains('PayPal') || methodTitle.contains('MasterCard') 
                    ? 'أدخل البريد أو رقم البطاقة' 
                    : 'أدخل رقم الهاتف / المحفظة',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF121816),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
            onPressed: () {
              if (accountController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الرجاء إدخال رقم الحساب أو المحفظة')),
                );
                return;
              }
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم تقديم طلب السحب عبر $methodTitle بنجاح!')),
              );
            },
            child: const Text('تأكيد الطلب'),
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
        backgroundColor: const Color(0xFF1A2321),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'اختر طريقة السحب المناسبة (العملة بالدولار الأمريكي):',
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          _buildRedeemOption(context, 'AsiaCell Cash (آسياسيل)', '\$5 USD الحد الأدنى', Icons.sim_card, Colors.red, () {
            _showRedeemDialog(context, 'آسياسيل', '\$5 USD');
          }),
          _buildRedeemOption(context, 'ZainCash (زين كاش)', '\$5 USD الحد الأدنى', Icons.phone_android, Colors.orange, () {
            _showRedeemDialog(context, 'زين كاش', '\$5 USD');
          }),
          _buildRedeemOption(context, 'MasterCard (ماستر كارد)', '\$10 USD الحد الأدنى', Icons.credit_card, Colors.blue, () {
            _showRedeemDialog(context, 'ماستر كارد', '\$10 USD');
          }),
          _buildRedeemOption(context, 'PayPal (بايبال)', '\$10 USD الحد الأدنى', Icons.account_balance_wallet, Colors.indigo, () {
            _showRedeemDialog(context, 'بايبال', '\$10 USD');
          }),
        ],
      ),
    );
  }

  Widget _buildRedeemOption(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      color: const Color(0xFF1E2A27),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green),
        onTap: onTap,
      ),
    );
  }
}

// ================= 5. شاشة الإعدادات =================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات والحساب'),
        backgroundColor: const Color(0xFF1A2321),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.blueAccent),
            title: const Text('سياسة الخصوصية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('اطّلع على شروط وسياسة أمان البيانات', style: TextStyle(color: Colors.grey, fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()));
            },
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('حذف الحساب', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            subtitle: const Text('حذف كافة بياناتك وحسابك بشكل نهائي', style: TextStyle(color: Colors.grey, fontSize: 12)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF1E2A27),
                  title: const Text('تحذير حذف الحساب', style: TextStyle(color: Colors.red)),
                  content: const Text('هل أنت متأكد من رغبتك في حذف حسابك نهائياً؟ لا يمكن التراجع عن هذا الإجراء.', style: TextStyle(color: Colors.white)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text('حذف نهائي', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 30),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= 6. الدردشة العامة =================
class GlobalChatScreen extends StatefulWidget {
  const GlobalChatScreen({super.key});

  @override
  State<GlobalChatScreen> createState() => _GlobalChatScreenState();
}

class _GlobalChatScreenState extends State<GlobalChatScreen> {
  final List<String> _messages = [
    'أهلاً بالجميع في تطبيق Cash Plus!',
    'منو سحب أرباح اليوم؟ بالتوفيق للجميع'
  ];
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
        title: const Text('الدردشة العامة'),
        backgroundColor: const Color(0xFF1A2321),
      ),
      body: Column(
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
                    color: const Color(0xFF1E2A27),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(_messages[index], style: const TextStyle(color: Colors.white)),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFF1A2321),
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
                  icon: const Icon(Icons.send, color: Colors.greenAccent),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= 7. الإنجازات =================
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنجازاتي'),
        backgroundColor: const Color(0xFF1A2321),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          AchievementTile(title: 'مستخدم نشط', description: 'سجل دخولك لأول مرة', progress: 'مكتمل ✅', color: Colors.green),
          AchievementTile(title: 'مشاهد الإعلانات المحترف', description: 'شاهد 10 إعلانات ترويجية', progress: '3 / 10', color: Colors.blue),
          AchievementTile(title: 'دوق الأصدقاء', description: 'ادعُ 5 أصدقاء للتطبيق', progress: '0 / 5', color: Colors.purple),
          AchievementTile(title: 'المستثمر الذهبي', description: 'صل إلى رصيد 10 دولار', progress: 'قيد التقدم', color: Colors.amber),
        ],
      ),
    );
  }
}

class AchievementTile extends StatelessWidget {
  final String title;
  final String description;
  final String progress;
  final Color color;

  const AchievementTile({super.key, required this.title, required this.description, required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E2A27),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.star, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: Text(progress, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }
}

// ================= 8. سياسة الخصوصية =================
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سياسة الخصوصية'),
        backgroundColor: const Color(0xFF1A2321),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'سياسة الخصوصية لتطبيق Cash Plus',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.greenAccent),
            ),
            SizedBox(height: 12),
            Text(
              'نحن نلتزم بحماية خصوصية بياناتك الشخصية وأمانها. توضح هذه السياسة كيف يتم جمع واستخدام وحماية المعلومات الخاصة بك عند استخدام تطبيقنا.',
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
