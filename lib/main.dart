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
        scaffoldBackgroundColor: const Color(0xff121212), // Premium Dark Mode
        primaryColor: const Color(0xff00E676), // Neon Green
        colorScheme: const ColorScheme.dark(
          primary: Color(0xff00E676),
          secondary: Color(0xff00E5FF),
          surface: Color(0xff1E1E1E),
        ),
      ),
      home: const MainNavigationHub(),
    );
  }
}

// ================= مركز التنقل السفلي الاحترافي =================
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

// ================= 1. الصفحة الرئيسية (المالية الاستثمارية المحدثة) =================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // الشريط العلوي للمستخدم
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
                        Text('مرحباً بك،', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        Text('لاعب_570575', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white70),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // بطاقة الرصيد والأرباح الرئيسية (Financial Card)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff1E1E1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('إجمالي الأرباح المتاحة', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Text('+12.4% هذا الأسبوع', style: TextStyle(color: Color(0xff00E676), fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '\$45.50',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xff00E676)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('🟡 النقاط المكتسبة: ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const Text('1,240 نقطة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // مخطط الأرباح (Earnings Graph Simulation)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff1E1E1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('نظرة عامة على الأرباح اليومية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('آخر 7 أيام', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // محاكاة بصرية لمخطط بياني خطي ناعم
                  SizedBox(
                    height: 110,
                    child: CustomPaint(
                      size: const Size(double.infinity, 110),
                      painter: ChartPainter(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('السبت', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('الأحد', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('الإثنين', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('الثلاثاء', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('الأربعاء', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('الخميس', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('الجمعة', style: TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // سجل الأنشطة والمكافآت (مباشرة تحت المخطط وبدون تكرار)
            const Text('سجل الأنشطة والمكافآت', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            _activityTile('إكمال مشاهدة إعلان مكافأة مؤهل', '+50 نقطة (\$0.50)', 'منذ ساعة', const Color(0xff00E676)),
            _activityTile('استبدال نقاط برصيد محفظة', '-\$5.00', 'أمس', Colors.amber),
            _activityTile('مكافأة مشاهدة إعلان ترويجي', '+30 نقطة (\$0.30)', 'منذ يومين', const Color(0xff00E676)),
          ],
        ),
      ),
    );
  }

  Widget _activityTile(String title, String amount, String time, Color color) {
    return Container(
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
          Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

// رسام المخطط البياني الخطي الناعم (Line Chart Painter)
class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = const Color(0xff00E676)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xff00E676).withOpacity(0.3), const Color(0xff00E676).withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.3, size.width * 0.4, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.8, size.width, size.height * 0.2);

    Path fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ================= 2. مركز الإعلانات والمكافآت =================
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
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xff1E1E1E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xff00E676), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('الإعلانات المتاحة اليوم', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(height: 6),
                    Text('8 إعلانات مؤهلة', style: TextStyle(color: Color(0xff00E676), fontSize: 20, fontWeight: FontWeight.w900)),
                  ],
                ),
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xff00E676),
                  child: Icon(Icons.play_arrow, color: Colors.black, size: 30),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('الإعلانات الجاهزة للمشاهدة', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildAdTile(context, 'إعلان مكافأة رقم #1', '+50 نقطة (\$0.50)', '30 ثانية'),
          _buildAdTile(context, 'إعلان مكافأة رقم #2', '+30 نقطة (\$0.30)', '20 ثانية'),
        ],
      ),
    );
  }

  Widget _buildAdTile(BuildContext context, String title, String reward, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text('المدة: $duration | المكافأة: $reward', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff00E676),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري تحميل الإعلان والتحقق من المشاهدة...')),
              );
            },
            child: const Text('شاهد الآن', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ================= 3. المحفظة =================
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحفظة وأرباح الإعلانات'),
        backgroundColor: const Color(0xff121212),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xff1E1E1E),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xff00E676), width: 1.5),
            ),
            child: Column(
              children: [
                const Text('إجمالي أرباح الإعلانات المتاحة', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 8),
                const Text(
                  'USD \$45.50',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xff00E676)),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('🟡 النقاط المتراكمة: 1,240 نقطة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('طرق استبدال وسحب الأرباح', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildWithdrawTile(context, 'AsiaCell Cash (آسياسيل)', 'سحب أرباح الإعلانات فورياً', Icons.phone_android, Colors.redAccent),
          _buildWithdrawTile(context, 'ZainCash (زين كاش)', 'سحب أرباح الإعلانات فورياً', Icons.phone_iphone, Colors.amber),
        ],
      ),
    );
  }

  Widget _buildWithdrawTile(BuildContext context, String title, String subtitle, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 28),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xff00E676), size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فتح بوابة سحب أرباح الإعلانات عبر $title')),
          );
        },
      ),
    );
  }
}

// ================= 4. الألعاب والترفيه =================
class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قسم الألعاب والتسلية (ترفيهي فقط)'),
        backgroundColor: const Color(0xff121212),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: const Text(
              'ملاحظة: هذه الألعاب مخصصة للترفيه والتحديات الشخصية فقط ولا تمنح أي أرباح مالية.',
              style: TextStyle(color: Colors.amber, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          _buildGameCard(context, 'تحديات الأركيد السريعة', 'استمتع باللعب وحقق أفضل رقم قياسي', Icons.sports_esports, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('بدء اللعبة للترفيه: $title')),
              );
            },
            child: const Text('العب الآن', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ================= 5. الدردشة =================
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دردشة المجتمع (ترفيه وتواصل فقط)'),
        backgroundColor: const Color(0xff121212),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.blueAccent.withOpacity(0.1),
            child: const Text(
              'الدردشة للتواصل الاجتماعي فقط ولا تمنح أي نقاط أو مكافآت مالية.',
              style: TextStyle(color: Colors.blueAccent, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ChatBubble(sender: 'أحمد', message: 'مرحباً بالجميع، كيف الحال في المجتمع؟', time: '08:00 ص', isMe: false),
                ChatBubble(sender: 'أنت', message: 'أهلاً بك، نسجّل مشاهدات الإعلانات ونستمتع بالدردشة!', time: '08:02 ص', isMe: true),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xff121212),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك الاجتماعية...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xff1E1E1E),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xff00E676),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.black, size: 18),
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
  final String message;
  final String time;
  final bool isMe;

  const ChatBubble({super.key, required this.sender, required this.message, required this.time, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xff00E676).withOpacity(0.15) : const Color(0xff1E1E1E),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sender, style: TextStyle(color: isMe ? const Color(0xff00E676) : Colors.grey[400], fontSize: 11, fontWeight: FontWeight.bold)),
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

// ================= 6. الإعدادات =================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  File? _profileImage;
  String _selectedLanguage = 'العربية';

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث الصورة الشخصية بنجاح!'), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات والحساب'),
        backgroundColor: const Color(0xff121212),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xff00E676), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: const Color(0xff1E1E1E),
                          backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                          child: _profileImage == null ? const Icon(Icons.person, size: 44, color: Color(0xff00E676)) : null,
                        ),
                      ),
                      const Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Color(0xff00E676),
                          child: Icon(Icons.camera_alt, size: 14, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text('لاعب_570575', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                const Text('ID: #RAYID-9924', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSettingTile(context, Icons.security, 'الأمان وحماية الحساب'),
          _buildSettingTile(context, Icons.notifications_none, 'إعدادات الإشعارات'),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xff1E1E1E),
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: const Icon(Icons.language, color: Color(0xff00E676)),
              title: Text('لغة التطبيق ($_selectedLanguage)', style: const TextStyle(color: Colors.white, fontSize: 14)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              onTap: () {
                _showLanguageDialog(context);
              },
            ),
          ),
          _buildSettingTile(context, Icons.help_outline, 'الدعم الفني والمساعدة'),
        ],
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xff00E676)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فتح إعدادات: $title')),
          );
        },
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff1E1E1E),
          title: const Text('اختر لغة التطبيق', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('العربية', style: TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() => _selectedLanguage = 'العربية');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('English', style: TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() => _selectedLanguage = 'English');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
