
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const RayidApp());
}

// ================= نموذج البيانات الشامل والأساسي للمستخدم =================
class UserAppModel extends ChangeNotifier {
  bool isLoggedIn = false;

  String userName = 'لاعب_570575';
  String userEmail = 'player570@rayid.pay';
  String userPhone = '+964 770 000 0000';
  File? profileImage;

  double balanceUSD = 45.50;
  double get balanceIQD => balanceUSD * 1320;
  int points = 1240;

  // متغيرات نظام إحالة الأصدقاء
  String referralCode = 'RAYID-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  int referralCount = 3;

  // رسائل نظام الدعم الفني المباشر
  List> supportMessages = [
    {'sender': 'support', 'text': 'مرحباً بك في دعم RAYID PAY. كيف يمكننا مساعدتك اليوم؟', 'time': 'الآن'}
  ];

  // مجموعات الدردشة الجديدة (بأنواع محددة بدقة لتجنب أخطاء البناء)
  List> chatGroups = [
    {'name': 'مجموعة أرباح الإعلانات الكبرى', 'members': 1420, 'lastMsg': 'تم توزيع مكافآت الأسبوع بنجاح!'},
    {'name': 'متداولو زين كاش وماستر كارد', 'members': 850, 'lastMsg': 'شباب وصل السحب لو بعده؟'},
  ];

  void createGroup(String groupName) {
    if (groupName.trim().isEmpty) return;
    chatGroups.add({'name': groupName, 'members': 1, 'lastMsg': 'تم إنشاء المجموعة حديثاً.'});
    notifyListeners();
  }

  void sendSupportMessage(String text) {
    if (text.trim().isEmpty) return;
    supportMessages.add({'sender': 'user', 'text': text, 'time': 'الآن'});
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      supportMessages.add({'sender': 'support', 'text': 'تم استلام رسالتك بنجاح. سيقوم أحد ممثلي خدمة العملاء بالرد عليك قريباً.', 'time': 'الآن'});
      notifyListeners();
    });
  }

  String getShareMessage() {
    return 'انضم إليّ في تطبيق RAYID PAY واكسب أرباحاً حقيقية من مشاهدة الإعلانات والسحب عبر زين كاش وماستر كارد!\nاستخدم كود الإحالة الخاص بي: $referralCode\nحمل التطبيق الآن وابدأ الربح!';
  }

  Future<bool> signUpUser(String name, String email, String phone, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    userName = name;
    userEmail = email;
    userPhone = phone;
    isLoggedIn = true;
    notifyListeners();
    return true;
  }

  Future<bool> signInUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    userEmail = email;
    isLoggedIn = true;
    notifyListeners();
    return true;
  }

  void signOutUser() {
    isLoggedIn = false;
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? email, String? phone, File? image}) async {
    if (name != null) userName = name;
    if (email != null) userEmail = email;
    if (phone != null) userPhone = phone;
    if (image != null) profileImage = image;
    await Future.delayed(const Duration(milliseconds: 400));
    notifyListeners();
  }

  void processWithdrawal(String method, String details, double amountIQD) {
    double deductedUSD = amountIQD / 1320;
    balanceUSD -= deductedUSD;
    activities.insert(0, {
      'title': 'سحب أرباح عبر $method ($details)',
      'amount': '-${amountIQD.toStringAsFixed(0)} د.ع',
      'time': 'الآن',
      'isPositive': false,
    });
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

  List<dynamic> activities = [
    {'title': 'إكمال مشاهدة إعلان مكافأة مؤهل', 'amount': '+50 نقطة (0.50 دولار / 660 د.ع)', 'time': 'منذ ساعة', 'isPositive': true},
    {'title': 'سحب أرباح عبر زين كاش', 'amount': '-19,800 د.ع (15.00 دولار)', 'time': 'أمس', 'isPositive': false},
  ];
}

final userModel = UserAppModel();

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
      home: AnimatedBuilder(
        animation: userModel,
        builder: (context, child) {
          return userModel.isLoggedIn ? const MainNavigationHub() : const AuthWrapperScreen();
        },
      ),
    );
  }
}

// ================= شاشة تسجيل الدخول وإنشاء الحساب =================
class AuthWrapperScreen extends StatefulWidget {
  const AuthWrapperScreen({super.key});

  @override
  State<AuthWrapperScreen> createState() => _AuthWrapperScreenState();
}

class _AuthWrapperScreenState extends State<AuthWrapperScreen> {
  bool isSigningUp = false;

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  void _submitAuth() async {
    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى إدخال البريد الإلكتروني وكلمة المرور.'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);
    bool success = false;

    if (isSigningUp) {
      if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى إكمال جميع الحقول المطلوبة لإنشاء الحساب.'), backgroundColor: Colors.red));
        setState(() => _isLoading = false);
        return;
      }
      success = await userModel.signUpUser(_nameController.text, _emailController.text, _phoneController.text, _passController.text);
    } else {
      success = await userModel.signInUser(_emailController.text, _passController.text);
    }

    setState(() => _isLoading = false);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء المصادقة، حاول مرة أخرى.'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text('RAYID PAY', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: 3, color: Color(0xff00E676))),
                ),
                const SizedBox(height: 8),
                Center(child: Text(isSigningUp ? 'إنشاء حساب جديد في المنصة' : 'تسجيل الدخول إلى حسابك', style: const TextStyle(color: Colors.grey, fontSize: 13))),
                const SizedBox(height: 30),

                if (isSigningUp) ...[
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(labelText: 'الاسم الكامل', filled: true, fillColor: const Color(0xff1E1E1E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(labelText: 'رقم الهاتف', filled: true, fillColor: const Color(0xff1E1E1E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 16),
                ],

                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: 'البريد الإلكتروني', filled: true, fillColor: const Color(0xff1E1E1E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: 'كلمة المرور', filled: true, fillColor: const Color(0xff1E1E1E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: _isLoading ? null : _submitAuth,
                  child: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : Text(isSigningUp ? 'إنشاء الحساب' : 'تسجيل الدخول', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => setState(() => isSigningUp = !isSigningUp),
                  child: Text(isSigningUp ? 'لديك حساب بالفعل؟ تسجيل الدخول' : 'ليس لديك حساب؟ إنشاء حساب جديد', style: const TextStyle(color: Color(0xff00E676))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= مركز التنقل السفلي التفاعلي =================
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
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

// ================= 1. الصفحة الرئيسية المتكاملة =================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: userModel,
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
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xff1E1E1E),
                          backgroundImage: userModel.profileImage != null ? FileImage(userModel.profileImage!) : null,
                          child: userModel.profileImage == null ? const Icon(Icons.person, color: Color(0xff00E676)) : null,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('مرحباً بك،', style: TextStyle(color: Colors.grey, fontSize: 11)),
                            Text(userModel.userName, style: const TextStyle(color: Color(0xff00E676), fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_active_outlined, color: Color(0xff00E676)),
                      onPressed: () => _showNotificationsDialog(context),
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
                          Text('حساب نشط', style: TextStyle(color: Color(0xff00E676), fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${userModel.balanceIQD.toStringAsFixed(0)} د.ع',
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xff00E676)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '(${userModel.balanceUSD.toStringAsFixed(2)} دولار أمريكي)',
                        style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text('🟡 النقاط المتراكمة: ${userModel.points} نقطة', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xff1E1E1E), borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('نظرة عامة على أرباح الأسبوع', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 100,
                        child: CustomPaint(size: const Size(double.infinity, 100), painter: ChartPainter()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('سجل الأنشطة والمكافآت', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                ...userModel.activities.map((act) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xff1E1E1E), borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(backgroundColor: (act['isPositive'] == true ? const Color(0xff00E676) : Colors.amber).withOpacity(0.15), child: Icon(Icons.history, color: act['isPositive'] == true ? const Color(0xff00E676) : Colors.amber, size: 18)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(act['title'].toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(height: 2),
                              Text(act['time'].toString(), style: const TextStyle(color: Colors.grey, fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                      Text(act['amount'].toString(), style: TextStyle(color: act['isPositive'] == true ? const Color(0xff00E676) : Colors.amber, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
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
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()..color = const Color(0xff00E676)..strokeWidth = 3.0..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    Path path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.2, size.width * 0.6, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.9, size.width, size.height * 0.1);
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
      appBar: AppBar(title: const Text('مركز الإعلانات والمكافآت'), backgroundColor: const Color(0xff121212), automaticallyImplyLeading: false),
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
              userModel.balanceUSD += addMoneyUSD;
              userModel.points += addPoints;
              userModel.addActivity('مشاهدة إعلان تجريبي ناجح', '+$addPoints نقطة (+${(addMoneyUSD * 1320).toStringAsFixed(0)} د.ع)', true);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم التحقق من مشاهدة الإعلان وإضافة المكافأة بنجاح!'), backgroundColor: Colors.green));
            },
            child: const Text('شاهد الآن', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ================= 3. المحفظة وبوابات السحب الثلاثة + إحالة الأصدقاء =================
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: userModel,
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
                    Text('${userModel.balanceIQD.toStringAsFixed(0)} د.ع', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xff00E676))),
                    const SizedBox(height: 4),
                    Text('(${userModel.balanceUSD.toStringAsFixed(2)} دولار أمريكي)', style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text('🟡 النقاط: ${userModel.points} نقطة', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // بطاقة نظام إحالة الأصدقاء
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xff00E5FF).withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.card_giftcard, color: Color(0xff00E5FF)),
                        SizedBox(width: 8),
                        Text('نظام إحالة الأصدقاء (ادعُ واربح)', style: TextStyle(color: Color(0xff00E5FF), fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('شارك كود الإحالة الخاص بك واكسب نقاطاً إضافية عن كل صديق يسجل في التطبيق!', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: const Color(0xff121212), borderRadius: BorderRadius.circular(10)),
                          child: Text(userModel.referralCode, style: const TextStyle(color: Color(0xff00E676), fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E5FF), foregroundColor: Colors.black),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم نسخ رسالة الإحالة للحافظة بنجاح!'), backgroundColor: Colors.blue),
                            );
                          },
                          icon: const Icon(Icons.share, size: 16),
                          label: const Text('مشاركة', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text('طرق السحب المتاحة في العراق', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildWithdrawTile(context, 'AsiaCell Cash (آسياسيل)', Icons.phone_android, Colors.redAccent),
              _buildWithdrawTile(context, 'ZainCash (زين كاش)', Icons.phone_iphone, Colors.amber),
              _buildWithdrawTile(context, 'Mastercard (ماستر كارد)', Icons.credit_card, Colors.blueAccent),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWithdrawTile(BuildContext context, String title, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xff1E1E1E), borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 28),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: const Text('سحب فوري آمن وموثوق', style: TextStyle(color: Colors.grey, fontSize: 11)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xff00E676), size: 16),
        onTap: () => _showWithdrawDialog(context, title),
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, String methodTitle) {
    final targetController = TextEditingController();
    final amountController = TextEditingController();
    bool isMaster = methodTitle.contains('Mastercard');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1E1E1E),
        title: Text('السحب عبر $methodTitle', style: const TextStyle(color: Color(0xff00E676))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              maxLength: isMaster ? 16 : 11,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: isMaster ? 'رقم بطاقة الماستر (16 رقماً)' : 'رقم المحفظة (مثال: 0770xxxxxxx)',
                labelStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'المبلغ المراد سحبه (د.ع)', labelStyle: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
            onPressed: () {
              if (targetController.text.isEmpty || amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى إكمال جميع الحقول.'), backgroundColor: Colors.red));
                return;
              }
              if (isMaster && targetController.text.length != 16) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('رقم الماستر كارد يجب أن يكون 16 رقماً!'), backgroundColor: Colors.red));
                return;
              }

              double? reqAmount = double.tryParse(amountController.text);
              if (reqAmount == null || reqAmount <= 0 || reqAmount > userModel.balanceIQD) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('المبلغ المدخل غير صالح أو يتجاوز الرصيد المتاح!'), backgroundColor: Colors.red));
                return;
              }

              userModel.processWithdrawal(methodTitle, targetController.text, reqAmount);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال طلب السحب بنجاح إلى بوابتك المالية!'), backgroundColor: Colors.green));
            },
            child: const Text('تأكيد السحب', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ================= 4. الألعاب والدردشة والمجموعات =================
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

// شاشة الدردشة والمجموعات المصححة بالكامل
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  void _showCreateGroupDialog(BuildContext context) {
    final groupController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1E1E1E),
        title: const Text('إنشاء مجموعة جديدة', style: TextStyle(color: Color(0xff00E676))),
        content: TextField(
          controller: groupController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'اسم المجموعة', labelStyle: TextStyle(color: Colors.grey)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
            onPressed: () {
              userModel.createGroup(groupController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء المجموعة بنجاح وانضممت إليها!'), backgroundColor: Colors.green));
            },
            child: const Text('إنشاء', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: userModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('دردشة ومجموعات المجتمع'),
            backgroundColor: const Color(0xff121212),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.group_add, color: Color(0xff00E676)),
                onPressed: () => _showCreateGroupDialog(context),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('المجموعات النشطة', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...userModel.chatGroups.map((group) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: const Color(0xff1E1E1E), borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: Color(0xff00E676), child: Icon(Icons.groups, color: Colors.black)),
                  title: Text(group['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('${group['members']} عضو • ${group['lastMsg']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xff00E676), size: 14),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('جاري فتح غرفة دردشة: ${group['name']}')));
                  },
                ),
              )).toList(),
            ],
          ),
        );
      },
    );
  }
}

// ================= شاشة الدعم الفني المباشر =================
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدعم الفني المباشر (24/7)'),
        backgroundColor: const Color(0xff121212),
      ),
      body: AnimatedBuilder(
        animation: userModel,
        builder: (context, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: userModel.supportMessages.length,
                  itemBuilder: (context, index) {
                    final msg = userModel.supportMessages[index];
                    bool isUser = msg['sender'] == 'user';
                    return Align(
                      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isUser ? const Color(0xff00E676).withOpacity(0.2) : const Color(0xff1E1E1E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isUser ? const Color(0xff00E676) : Colors.grey.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(msg['text']!, style: const TextStyle(color: Colors.white, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text(msg['time']!, style: const TextStyle(color: Colors.grey, fontSize: 9)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                color: const Color(0xff181818),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'اكتب مشكلتك أو استفسارك هنا...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: const Color(0xff121212),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: const Color(0xff00E676),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.black, size: 18),
                        onPressed: () {
                          userModel.sendSupportMessage(_msgController.text);
                          _msgController.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ================= 5. صفحة الإعدادات مع الدعم الفني وسياسة الخصوصية =================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: userModel.userName);
    _emailController = TextEditingController(text: userModel.userEmail);
    _phoneController = TextEditingController(text: userModel.userPhone);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await userModel.updateProfile(image: File(pickedFile.path));
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث الصورة الشخصية بنجاح!'), backgroundColor: Colors.green));
      }
    }
  }

  void _saveProfile() async {
    await userModel.updateProfile(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ بيانات الحساب بنجاح!'), backgroundColor: Colors.green));
    }
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1E1E1E),
        title: const Text('سياسة الخصوصية - RAYID PAY', style: TextStyle(color: Color(0xff00E676), fontSize: 16)),
        content: const SingleChildScrollView(
          child: Text(
            'نحن نلتزم بحماية بياناتك الشخصية والمالية بأعلى معايير الأمان الرقمي في العراق.\n\n'
            '• البيانات المجمعة: نقوم بحفظ الاسم، البريد الإلكتروني، ورقم الهاتف لتوثيق الحساب وإرسال مستحقاتك بدقة.\n\n'
            '• أمان السحب المالي: جميع عمليات السحب عبر (زين كاش، آسيا سيل، وماستر كارد) مشفرة بالكامل وتتم عبر قنوات آمنة.\n\n'
            '• الخصوصية: لا يتم مشاركة بياناتك الشخصية مع أي أطراف خارجية، وتُستخدم فقط لإدارة أرباحك من الإعلانات.',
            style: TextStyle(color: Colors.grey, height: 1.4, fontSize: 13),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق', style: TextStyle(color: Color(0xff00E676))))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: userModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('الإعدادات والحساب'), backgroundColor: const Color(0xff121212), automaticallyImplyLeading: false),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xff1E1E1E),
                      backgroundImage: userModel.profileImage != null ? FileImage(userModel.profileImage!) : null,
                      child: userModel.profileImage == null ? const Icon(Icons.person, size: 40, color: Color(0xff00E676)) : null,
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: CircleAvatar(
                        radius: 14, backgroundColor: const Color(0xff00E676),
                        child: IconButton(icon: const Icon(Icons.camera_alt, size: 12, color: Colors.black), onPressed: _pickImage),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('إدارة الحساب الشخصي', style: TextStyle(color: Color(0xff00E676), fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 10),
              TextField(controller: _nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'الاسم الكامل', filled: true, fillColor: Color(0xff1E1E1E))),
              const SizedBox(height: 10),
              TextField(controller: _emailController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'البريد الإلكتروني', filled: true, fillColor: Color(0xff1E1E1E))),
              const SizedBox(height: 10),
              TextField(controller: _phoneController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'رقم الهاتف', filled: true, fillColor: Color(0xff1E1E1E))),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
                onPressed: _saveProfile,
                child: const Text('حفظ التعديلات', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),

              const Text('الدعم والقانونية', style: TextStyle(color: Color(0xff00E676), fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 8),
              
              ListTile(
                tileColor: const Color(0xff1E1E1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.support_agent, color: Color(0xff00E676)),
                title: const Text('الدعم الفني المباشر', style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen()));
                },
              ),
              const SizedBox(height: 10),

              ListTile(
                tileColor: const Color(0xff1E1E1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xff00E676)),
                title: const Text('سياسة الخصوصية', style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () => _showPrivacyPolicyDialog(context),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.2), foregroundColor: Colors.redAccent, minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  userModel.signOutUser();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل الخروج بنجاح.'), backgroundColor: Colors.orange));
                },
                child: const Text('تسجيل الخروج (Log Out)', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }
}
