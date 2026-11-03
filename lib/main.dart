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

// ================= 1. شاشة تسجيل الدخول مع البصمة والمطور السري =================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _inputController = TextEditingController();
  final LocalAuthentication _auth = LocalAuthentication();

  // رقم هاتفك السري الخاص كمدير للتطبيق
  final String adminPhoneNumber = "07713258169"; 

  void _proceedLogin(String identifier) {
    bool isAdmin = (identifier == adminPhoneNumber);
    String identifierName = isAdmin ? 'مدير التطبيق (Admin)' : identifier;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CashPlusHomePage(
          userIdentifier: identifierName,
          isAdmin: isAdmin,
        ),
      ),
    );
  }

  void _validateAndLogin() {
    String input = _inputController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال رقم الهاتف أو البريد الإلكتروني')),
      );
      return;
    }
    _proceedLogin(input);
  }

  // دالة تسجيل الدخول عبر بصمة الوجه أو الإصبع
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
        localizedAuthenticate: 'يرجى تأكيد بصمة الوجه أو الإصبع للدخول',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        // إذا نجحت البصمة، ندخلك مباشرة بصلاحيات المدير لأن الرقم مسجل لك
        _proceedLogin(adminPhoneNumber);
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
                  'Cash Plus Secure',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  'سجل دخولك أو استخدم بصمة الحماية',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _inputController,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف أو البريد الإلكتروني',
                    prefixIcon: const Icon(Icons.person, color: Colors.green),
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
                    child: const Text('دخول آمن', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                // زر تسجيل الدخول السريع باستخدام البصمة
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _authenticateWithBiometrics,
                    icon: const Icon(Icons.fingerprint, color: Colors.greenAccent),
                    label: const Text('تسجيل الدخول بـ بصمة الوجه / الإصبع', style: TextStyle(fontSize: 15, color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.greenAccent, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
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

// ================= 2. الصفحة الرئيسية وصلاحيات المدير =================
class CashPlusHomePage extends StatefulWidget {
  final String userIdentifier;
  final bool isAdmin;
  const CashPlusHomePage({super.key, required this.userIdentifier, required this.isAdmin});

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
            Icon(widget.isAdmin ? Icons.admin_panel_settings : Icons.monetization_on, color: widget.isAdmin ? Colors.amber : Colors.green, size: 28),
            const SizedBox(width: 8),
            Text('Cash Plus (${widget.userIdentifier})', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
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
                    'USD Value: ' + usdValue.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 14),
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
                    label: const Text('Redeem Now'),
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
              'Earn More Points (Protected)',
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

// ================= 3. شاشة طرق السحب =================
class RedeemScreen extends StatelessWidget {
  const RedeemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طرق سحب الأرباح'),
        backgroundColor: const Color(0xFF1A2321),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'اختر الطريقة المناسبة لسحب أرباحك:',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          _buildRedeemOption(context, 'زين كاش (ZainCash)', 'الحد الأدنى: 5,000 نقطة', Icons.phone_android, Colors.orange),
          _buildRedeemOption(context, 'رصيد آسياسيل (AsiaCell)', 'كارت رصيد فئة 5 أو 10 دولار', Icons.sim_card, Colors.red),
          _buildRedeemOption(context, 'تحويل فودافون كاش / سحب دولي', 'عبر محفظتك الإلكترونية', Icons.account_balance, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildRedeemOption(BuildContext context, String title, String subtitle, IconData icon, Color color) {
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
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم اختيار طريقة السحب: $title')),
          );
        },
      ),
    );
  }
}
