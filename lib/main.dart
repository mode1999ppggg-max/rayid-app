import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const RayidApp());
}

class AppDataModel extends ChangeNotifier {
  double balanceUSD = 45.50;
  double get balanceIQD => balanceUSD * 1320;
  int points = 1240;
  List<dynamic> activities = [
    {'title': 'إكمال مشاهدة إعلان مكافأة مؤهل', 'amount': '+50 نقطة (0.50 دولار / 660 د.ع)', 'time': 'منذ ساعة', 'isPositive': true},
    {'title': 'سحب أرباح عبر زين كاش', 'amount': '-19,800 د.ع (15.00 دولار)', 'time': 'أمس', 'isPositive': false},
  ];

  void updateBalance(double newBalanceUSD, int newPoints) {
    balanceUSD = newBalanceUSD;
    points = newPoints;
    notifyListeners();
  }

  void addActivity(String title, String amount, bool isPositive) {
    activities.insert(0, {
      'title': title,
      'amount': amount,
      'time': 'الآن',
      'isPositive': isPositive,
    });
    notifyListeners();
  }
}

final appData = AppDataModel();

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
        scaffoldBackgroundColor: const Color(0xff121212),
        primaryColor: const Color(0xff00E676),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xff00E676),
          secondary: Color(0xff00E5FF),
          surface: Color(0xff1E1E1E),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'admin@rayid.pay');
  final _passController = TextEditingController(text: 'dev12345');

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  'RAYID PAY',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    color: Color(0xff00E676),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text('منظومة الإدارة والمطورين المركزية', style: TextStyle(color: Colors.grey, fontSize: 13)),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'بريد المطور (Admin Email)',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xff1E1E1E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xff1E1E1E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00E676),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _login,
                child: const Text('دخول لوحة تحكم المطور', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    const AdsRewardsScreen(),
    const WalletScreen(),
    const GamesScreen(),
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
        backgroundColor: const Color(0xff181818),
        selectedItemColor: const Color(0xff00E676),
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_filled_outlined), label: 'الإعلانات'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'المحفظة'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports_outlined), label: 'الألعاب'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'الدردشة'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'الإعدادات'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appData,
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xff1E1E1E),
                          child: Icon(Icons.person, color: Color(0xff00E676)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('مرحباً بك (المطور)،', style: TextStyle(color: Colors.grey, fontSize: 11)),
                            Text('لاعب_570575 [Admin]', style: TextStyle(color: Color(0xff00E676), fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_active_outlined, color: Color(0xff00E676)),
                      onPressed: () {
                        _showNotificationsDialog(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xff1E1E1E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xff00E676).withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('إجمالي أرباح الإعلانات المتاحة', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          Text('IQD / USD', style: TextStyle(color: Color(0xff00E676), fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${appData.balanceIQD.toStringAsFixed(0)} د.ع',
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xff00E676)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '(${appData.balanceUSD.toStringAsFixed(2)} دولار أمريكي)',
                        style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text('🟡 النقاط المتراكمة: ${appData.points} نقطة', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xff1E1E1E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('نظرة عامة على أرباح الأسبوع', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 100,
                        child: CustomPaint(
                          size: const Size(double.infinity, 100),
                          painter: ChartPainter(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('سجل الأنشطة والمكافآت (قابل للنقر)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                ...appData.activities.map((act) => _activityTile(
                  context,
                  act['title'].toString(),
                  act['amount'].toString(),
                  act['time'].toString(),
                  act['isPositive'] == true,
                )).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1E1E1E),
        title: const Text('الإشعارات والتنبيهات', style: TextStyle(color: Colors.white)),
        content: const Text('• تم تحديث نظام تتبع الإعلانات وإظهار العملة بالدينار والدولار.\n• تم إضافة 8 إعلانات مؤهلة جديدة للمستخدمين اليوم.', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق', style: TextStyle(color: Color(0xff00E676))))
        ],
      ),
    );
  }

  Widget _activityTile(BuildContext context, String title, String amount, String time, bool isPositive) {
    final color = isPositive ? const Color(0xff00E676) : Colors.amber;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xff1E1E1E),
            title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
            content: Text('تفاصيل العملية:\n• القيمة: $amount\n• التوقيت: $time\n• الحالة: مكتمل ومتحقق منه سحابياً.', style: const TextStyle(color: Colors.grey)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً', style: TextStyle(color: Color(0xff00E676))))
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xff1E1E1E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(Icons.history, color: color, size: 18)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ],
            ),
            Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = const Color(0xff00E676)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.2, size.width * 0.6, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.9, size.width, size.height * 0.1);

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AdsRewardsScreen extends StatelessWidget {
  const AdsRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز الإعلانات والمكافآت'),
        backgroundColor: const Color(0xff121212),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAdTile(context, 'إعلان مكافأة رقم #1', '+50 نقطة (660 د.ع / 0.50 دولار)', 50, 0.50),
          _buildAdTile(context, 'إعلان ترويجي مميز', '+100 نقطة (1,320 د.ع / 1.00 دولار)', 100, 1.00),
        ],
      ),
    );
  }

  Widget _buildAdTile(BuildContext context, String title, String rewardText, int addPoints, double addMoneyUSD) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xff1E1E1E), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text('المكافأة: $rewardText', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
            onPressed: () {
              appData.updateBalance(appData.balanceUSD + addMoneyUSD, appData.points + addPoints);
              appData.addActivity('مشاهدة إعلان تجريبي ناجح', '+$addPoints نقطة (+${(addMoneyUSD * 1320).toStringAsFixed(0)} د.ع)', true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم التحقق من مشاهدة الإعلان وإضافة المكافأة بنجاح!'), backgroundColor: Colors.green),
              );
            },
            child: const Text('شاهد الآن', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appData,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('المحفظة وأرباح الإعلانات'), backgroundColor: const Color(0xff121212), automaticallyImplyLeading: false),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: const Color(0xff1E1E1E), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xff00E676))),
                child: Column(
                  children: [
                    const Text('الرصيد المتاح للسحب', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text('${appData.balanceIQD.toStringAsFixed(0)} د.ع', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xff00E676))),
                    const SizedBox(height: 4),
                    Text('(${appData.balanceUSD.toStringAsFixed(2)} دولار أمريكي)', style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text('🟡 النقاط: ${appData.points} نقطة', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('طرق السحب المتاحة في العراق', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildWithdrawTile(context, 'AsiaCell Cash (آسياسيل)'),
              _buildWithdrawTile(context, 'ZainCash (زين كاش)'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWithdrawTile(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xff1E1E1E), borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: const Icon(Icons.payment, color: Color(0xff00E676)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xff00E676), size: 16),
        onTap: () {
          if (appData.balanceUSD > 0) {
            appData.addActivity('طلب سحب أرباح عبر $title', '-${appData.balanceIQD.toStringAsFixed(0)} د.ع', false);
            appData.updateBalance(0.0, appData.points);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال طلب السحب بنجاح إلى محفظتك العراقية!'), backgroundColor: Colors.green));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('عذراً، الرصيد غير كافٍ.'), backgroundColor: Colors.red));
          }
        },
      ),
    );
  }
}

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('منصة الألعاب السيبرانية (ترفيهي)'), backgroundColor: const Color(0xff121212), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _gameCard(context, 'لـودو سايبربانك (Cyber Ludo)', Icons.casino, Colors.greenAccent),
          _gameCard(context, 'شطرنج النيون (Neon Chess)', Icons.extension, Colors.blueAccent),
          _gameCard(context, 'كرة قدم السيبربانك (Cyber Football)', Icons.sports_soccer, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _gameCard(BuildContext context, String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xff1E1E1E), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.black),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('جاري تشغيل $title للتسلية...'))),
            child: const Text('العب'),
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دردشة المجتمع'), backgroundColor: const Color(0xff121212), automaticallyImplyLeading: false),
      body: Column(
        children: [
          const Expanded(child: Center(child: Text('مجتمع الدردشة والترفيه الاجتماعي', style: TextStyle(color: Colors.grey)))),
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xff121212),
            child: Row(
              children: [
                Expanded(child: TextField(decoration: InputDecoration(hintText: 'اكتب رسالتك...', filled: true, fillColor: const Color(0xff1E1E1E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)))),
                const SizedBox(width: 8),
                CircleAvatar(backgroundColor: const Color(0xff00E676), child: IconButton(icon: const Icon(Icons.send, color: Colors.black, size: 18), onPressed: () {}))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _balanceController = TextEditingController(text: appData.balanceUSD.toString());
  final _pointsController = TextEditingController(text: appData.points.toString());

  void _saveDeveloperData() {
    double? newBalUSD = double.tryParse(_balanceController.text);
    int? newPts = int.tryParse(_pointsController.text);
    if (newBalUSD != null && newPts != null) {
      appData.updateBalance(newBalUSD, newPts);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث لوحة تحكم المطور بنجاح!'), backgroundColor: Colors.green));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات ولوحة تحكم المطور'), backgroundColor: const Color(0xff121212), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('لوحة تحكم المدير (Developer Admin Panel)', style: TextStyle(color: Color(0xff00E676), fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          TextField(
            controller: _balanceController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'تعديل الرصيد بالدولار الامريكي', filled: true, fillColor: Color(0xff1E1E1E)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pointsController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'تعديل النقاط', filled: true, fillColor: Color(0xff1E1E1E)),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
            onPressed: _saveDeveloperData,
            child: const Text('حفظ وتحديث النظام حياً', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.2), foregroundColor: Colors.redAccent),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
            child: const Text('تسجيل خروج المطور'),
          ),
        ],
      ),
    );
  }
}
