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
        scaffoldBackgroundColor: const Color(0xff06090f),
        primaryColor: const Color(0xff00ff88),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xff00ff88),
          secondary: Color(0xff00f0ff),
          surface: Color(0xff0f1722),
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
        backgroundColor: const Color(0xff06090f),
        selectedItemColor: const Color(0xff00ff88),
        unselectedItemColor: Colors.grey[700],
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

// ================= 1. الصفحة الرئيسية الغنية بالتفاصيل والأدوات =================
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
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Color(0xff0f1722),
                      child: Icon(Icons.person, color: Color(0xff00ff88)),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xff0f1722),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xff00ff88).withOpacity(0.4)),
                  ),
                  child: Row(
                    children: const [
                      CircleAvatar(radius: 4, backgroundColor: Color(0xff00ff88)),
                      SizedBox(width: 6),
                      Text('متصل بالمنظومة', style: TextStyle(color: Color(0xff00ff88), fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // بطاقة الرصيد والأرباح الرئيسية الفاخرة
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff0f1722), Color(0xff162231)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xff00ff88).withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(color: const Color(0xff00ff88).withOpacity(0.08), blurRadius: 15, spreadRadius: 2)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('إجمالي أرباح الإعلانات', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Text('USD', style: TextStyle(color: Color(0xff00ff88), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '\$45.50',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xff00ff88)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xff06090f),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: const [
                              Text('🟡', style: TextStyle(fontSize: 18)),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('النقاط', style: TextStyle(color: Colors.grey, fontSize: 10)),
                                  Text('1,240', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
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
                          decoration: BoxDecoration(
                            color: const Color(0xff06090f),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.bolt, color: Color(0xff00f0ff), size: 20),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('مستوى التفاعل', style: TextStyle(color: Colors.grey, fontSize: 10)),
                                  Text('نشط جداً', style: TextStyle(color: Color(0xff00f0ff), fontWeight: FontWeight.bold, fontSize: 14)),
                                ],
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
            const SizedBox(height: 24),
            const Text('الإعلانات والخدمات السريعة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _quickActionCard(context, Icons.play_circle_fill, 'الإعلانات', const AdsRewardsScreen(), Colors.greenAccent),
                _quickActionCard(context, Icons.account_balance_wallet, 'المحفظة', const WalletScreen(), Colors.amber),
                _quickActionCard(context, Icons.sports_esports, 'الألعاب', const GamesScreen(), Colors.purpleAccent),
                _quickActionCard(context, Icons.chat, 'الدردشة', const ChatScreen(), Colors.blueAccent),
              ],
            ),
            const SizedBox(height: 24),
            const Text('أحدث النشاطات والمكافآت', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            _activityTile('إكمال مشاهدة إعلان مؤهل', '+50 نقطة (\$0.50)', 'منذ ساعة', Colors.greenAccent),
            _activityTile('سحب أرباح عبر زين كاش', '-\$15.00', 'أمس', Colors.amber),
          ],
        ),
      ),
    );
  }

  Widget _quickActionCard(BuildContext context, IconData icon, String label, Widget destination, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xff0f1722),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _activityTile(String title, String amount, String time, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xff0f1722),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(Icons.history, color: color, size: 18)),
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

// ================= 2. مركز الإعلانات والمكافآت (النشاط الأساسي) =================
class AdsRewardsScreen extends StatelessWidget {
  const AdsRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز الإعلانات والمكافآت'),
        backgroundColor: const Color(0xff06090f),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xff0f1722),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xff00ff88), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('الإعلانات المتاحة اليوم', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(height: 6),
                    Text('8 إعلانات مؤهلة', style: TextStyle(color: Color(0xff00ff88), fontSize: 20, fontWeight: FontWeight.w900)),
                  ],
                ),
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xff00ff88),
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
          _buildAdTile(context, 'إعلان ترويجي مميز', '+100 نقطة (\$1.00)', '45 ثانية'),
          const SizedBox(height: 24),
          const Text('سجل المشاهدات والمكافآت الأخيرة', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _historyTile('إكمال مشاهدة إعلان مؤهل', '+40 نقطة', 'منذ ساعة', Colors.greenAccent),
          _historyTile('استبدال نقاط برصيد محفظة', '-\$5.00', 'أمس', Colors.amber),
        ],
      ),
    );
  }

  Widget _buildAdTile(BuildContext context, String title, String reward, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xff0f1722),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
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
              backgroundColor: const Color(0xff00ff88),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري تحميل الإعلان وتحقق المشاهدة...')),
              );
            },
            child: const Text('شاهد الآن', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _historyTile(String title, String value, String time, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff0f1722),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline, color: color, size: 20),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(time, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
            ],
          ),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

// ================= 3. المحفظة (أرباح الإعلانات) =================
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحفظة وأرباح الإعلانات'),
        backgroundColor: const Color(0xff06090f),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xff0f1722),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xff00ff88), width: 1.5),
            ),
            child: Column(
              children: [
                const Text('إجمالي أرباح الإعلانات المتاحة', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 8),
                const Text(
                  'USD \$45.50',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xff00ff88)),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('🟡', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 6),
                    Text('النقاط المتراكمة: 1,240', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          _buildWithdrawTile(context, 'MasterCard (ماستر كارد)', 'تحويل بنكي آمن', Icons.credit_card, Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _buildWithdrawTile(BuildContext context, String title, String subtitle, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xff0f1722),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 28),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xff00ff88), size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فتح بوابة سحب أرباح الإعلانات عبر $title')),
          );
        },
      ),
    );
  }
}

// ================= 4. الألعاب والترفيه (ترفيهي فقط) =================
class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قسم الألعاب والتسلية (ترفيهي فقط)'),
        backgroundColor: const Color(0xff06090f),
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
          _buildGameCard(context, 'ألعاب الألغاز والذكاء', 'نشّط عقلك وتحدى أصدقاءك بلا حدود', Icons.extension, Colors.amber),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff0f1722),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
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

// ================= 5. الدردشة (تواصل واجتماعي فقط) =================
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دردشة المجتمع (ترفيه وتواصل فقط)'),
        backgroundColor: const Color(0xff06090f),
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
            color: const Color(0xff06090f),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك الاجتماعية...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xff0f1722),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xff00ff88),
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
          color: isMe ? const Color(0xff00ff88).withOpacity(0.15) : const Color(0xff0f1722),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isMe ? const Color(0xff00ff88).withOpacity(0.3) : Colors.transparent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sender, style: TextStyle(color: isMe ? const Color(0xff00ff88) : Colors.grey[400], fontSize: 11, fontWeight: FontWeight.bold)),
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

// ================= 6. الإعدادات والملف الشخصي =================
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
        backgroundColor: const Color(0xff06090f),
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
                          border: Border.all(color: const Color(0xff00ff88), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: const Color(0xff0f1722),
                          backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                          child: _profileImage == null ? const Icon(Icons.person, size: 44, color: Color(0xff00ff88)) : null,
                        ),
                      ),
                      const Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Color(0xff00ff88),
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
          _buildSettingTile(context, Icons.security, 'الأمان وحماية الحساب', const SecurityScreen()),
          _buildSettingTile(context, Icons.notifications_none, 'إعدادات الإشعارات', const NotificationsSettingsScreen()),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xff0f1722),
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: const Icon(Icons.language, color: Color(0xff00ff88)),
              title: Text('لغة التطبيق ($_selectedLanguage)', style: const TextStyle(color: Colors.white, fontSize: 14)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              onTap: () {
                _showLanguageDialog(context);
              },
            ),
          ),
          _buildSettingTile(context, Icons.help_outline, 'الدعم الفني والمساعدة', const SupportScreen()),
        ],
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, IconData icon, String title, Widget destination) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xff0f1722),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xff00ff88)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
        },
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff0f1722),
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

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأمان وحماية الحساب'), backgroundColor: const Color(0xff06090f)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SwitchListTile(
            title: Text('التحقق بخطوتين (PIN)', style: TextStyle(color: Colors.white)),
            value: true,
            activeColor: Color(0xff00ff88),
            onChanged: null,
          ),
        ],
      ),
    );
  }
}

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات الإشعارات'), backgroundColor: const Color(0xff06090f)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SwitchListTile(
            title: Text('تفعيل الإشعارات والتنبيهات', style: TextStyle(color: Colors.white)),
            value: true,
            activeColor: Color(0xff00ff88),
            onChanged: null,
          ),
        ],
      ),
    );
  }
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدعم الفني'), backgroundColor: const Color(0xff06090f)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff00ff88),
              foregroundColor: Colors.black,
              minimumSize: const Size(200, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري فتح محادثة الدعم المباشر...')),
              );
            },
            child: const Text('مراسلة الدعم المباشر', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
