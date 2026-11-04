import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const RayidApp());
}

// نموذج البيانات السحابي المحدث مع دعم المصادقة
class AppDataModel extends ChangeNotifier {
  double balanceUSD = 45.50;
  double get balanceIQD => balanceUSD * 1320;
  int points = 1240;
  
  String userName = 'لاعب_570575';
  String userEmail = 'player570@rayid.pay';
  String userPhone = '+964 770 000 0000';
  File? profileImage;

  // حالة صلاحيات المطور
  bool isAdmin = false; 

  // بيانات حساب المطور المعتمد (سيتم ربطها لاحقاً بـ Firebase Auth)
  final String adminEmail = 'admin@rayid.pay';
  final String adminPass = 'dev12345';

  List<dynamic> activities = [
    {'title': 'إكمال مشاهدة إعلان مكافأة مؤهل', 'amount': '+50 نقطة (0.50 دولار / 660 د.ع)', 'time': 'منذ ساعة', 'isPositive': true},
    {'title': 'سحب أرباح عبر زين كاش', 'amount': '-19,800 د.ع (15.00 دولار)', 'time': 'أمس', 'isPositive': false},
  ];

  Future<void> updateCloudDatabase(double newBalanceUSD, int newPoints) async {
    await Future.delayed(const Duration(milliseconds: 500)); // محاكاة الاتصال بالسحابة
    balanceUSD = newBalanceUSD;
    points = newPoints;
    notifyListeners();
  }

  bool loginAsDeveloper(String email, String password) {
    if (email.trim() == adminEmail && password.trim() == adminPass) {
      isAdmin = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logoutDeveloper() {
    isAdmin = false;
    notifyListeners();
  }

  void updateProfile({String? name, String? email, String? phone, File? image}) {
    if (name != null) userName = name;
    if (email != null) userEmail = email;
    if (phone != null) userPhone = phone;
    if (image != null) profileImage = image;
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
      home: const MainNavigationHub(),
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

// ================= 1. الصفحة الرئيسية =================
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
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xff1E1E1E),
                          backgroundImage: appData.profileImage != null ? FileImage(appData.profileImage!) : null,
                          child: appData.profileImage == null ? const Icon(Icons.person, color: Color(0xff00E676)) : null,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('مرحباً بك،', style: TextStyle(color: Colors.grey, fontSize: 11)),
                            Text(appData.userName, style: const TextStyle(color: Color(0xff00E676), fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_active_outlined, color: Color(0xff00E676)),
                      onPressed: () {},
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
                          Text('سحابياً متصل', style: TextStyle(color: Color(0xff00E676), fontSize: 11, fontWeight: FontWeight.bold)),
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
              ],
            ),
          ),
        );
      },
    );
  }
}

// شاشات الإعلانات، المحفظة، الألعاب، والدردشة (تبسيطية لتكامل الكود)
class AdsRewardsScreen extends StatelessWidget {
  const AdsRewardsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('مركز الإعلانات'), automaticallyImplyLeading: false), body: const Center(child: Text('قسم مشاهدة الإعلانات', style: TextStyle(color: Colors.grey))));
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('المحفظة'), automaticallyImplyLeading: false), body: const Center(child: Text('بوابات السحب', style: TextStyle(color: Colors.grey))));
}

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الألعاب'), automaticallyImplyLeading: false), body: const Center(child: Text('ألعاب التسلية', style: TextStyle(color: Colors.grey))));
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الدردشة'), backgroundColor: const Color(0xff121212), automaticallyImplyLeading: false), body: const Center(child: Text('دردشة المجتمع', style: TextStyle(color: Colors.grey))));
}

// ================= 2. صفحة الإعدادات وتسجيل دخول المطور بالبريد والرمز =================
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
    _nameController = TextEditingController(text: appData.userName);
    _emailController = TextEditingController(text: appData.userEmail);
    _phoneController = TextEditingController(text: appData.userPhone);
  }

  // نافذة تسجيل دخول المطور عبر البريد الإلكتروني وكلمة المرور
  void _showDeveloperLoginDialog() {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1E1E1E),
        title: const Text('تسجيل دخول المطورين', style: TextStyle(color: Color(0xff00E676))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'البريد الإلكتروني للمطور', labelStyle: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passCtrl,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'كلمة المرور السرية', labelStyle: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
            onPressed: () {
              bool success = appData.loginAsDeveloper(emailCtrl.text, passCtrl.text);
              Navigator.pop(context);
              if (success) {
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل دخول المطور بنجاح! ظهرت لوحة التحكم.'), backgroundColor: Colors.green));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('البريد أو كلمة المرور غير صحيحة.'), backgroundColor: Colors.red));
              }
            },
            child: const Text('دخول', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appData,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('الإعدادات والحساب الآمن'), backgroundColor: const Color(0xff121212), automaticallyImplyLeading: false),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // إعدادات المستخدم العادي
              const Text('إدارة الحساب الشخصي', style: TextStyle(color: Color(0xff00E676), fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'الاسم الكامل', filled: true, fillColor: Color(0xff1E1E1E)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'البريد الإلكتروني', filled: true, fillColor: Color(0xff1E1E1E)),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
                onPressed: () {
                  appData.updateProfile(name: _nameController.text, email: _emailController.text);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ البيانات بنجاح!'), backgroundColor: Colors.green));
                },
                child: const Text('حفظ التعديلات', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 30),

              // إذا كان المطور مسجلاً للدخول، تظهر له لوحة التحكم
              if (appData.isAdmin) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xff1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      const DeveloperCloudPanelWidget(),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, side: const BorderSide(color: Colors.redAccent)),
                        onPressed: () {
                          appData.logoutDeveloper();
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجل خروج المطور وإخفاء لوحة التحكم.'), backgroundColor: Colors.orange));
                        },
                        child: const Text('تسجيل خروج وضع المطور'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // زر تسجيل دخول المطورين (يظهر في الأسفل للمطورين فقط عند الحاجة)
              if (!appData.isAdmin)
                Center(
                  child: TextButton.icon(
                    onPressed: _showDeveloperLoginDialog,
                    icon: const Icon(Icons.admin_panel_settings, color: Colors.grey, size: 18),
                    label: const Text('تسجيل دخول المطورين (Admin Login)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ================= 3. لوحة التحكم الحية للربط السحابي =================
class DeveloperCloudPanelWidget extends StatefulWidget {
  const DeveloperCloudPanelWidget({super.key});

  @override
  State<DeveloperCloudPanelWidget> createState() => _DeveloperCloudPanelWidgetState();
}

class _DeveloperCloudPanelWidgetState extends State<DeveloperCloudPanelWidget> {
  final _balanceController = TextEditingController(text: appData.balanceUSD.toString());
  final _pointsController = TextEditingController(text: appData.points.toString());
  bool _isLoading = false;

  void _saveToCloud() async {
    setState(() => _isLoading = true);
    double? newBalUSD = double.tryParse(_balanceController.text);
    int? newPts = int.tryParse(_pointsController.text);
    
    if (newBalUSD != null && newPts != null) {
      await appData.updateCloudDatabase(newBalUSD, newPts);
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث البيانات سحابياً بنجاح وانعكست للمستخدمين!'), backgroundColor: Colors.green),
        );
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('لوحة التحكم الحية (Realtime Cloud Admin)', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        TextField(
          controller: _balanceController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'تعديل رصيد المستخدم (دولار)', filled: true, fillColor: Color(0xff121212)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _pointsController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'تعديل نقاط المستخدم', filled: true, fillColor: Color(0xff121212)),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
          onPressed: _isLoading ? null : _saveToCloud,
          child: _isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
            : const Text('حفظ وتحديث النظام حياً سحابياً', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
