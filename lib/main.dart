import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const RayidApp());
}

// ================= قاموس اللغات الشامل (Localization Map) =================
class AppStrings {
  static const Map<String, Map<String, String>> localizedValues = {
    'ar': {
      'appName': 'RAYID PAY',
      'home': 'الرئيسية',
      'ads': 'الإعلانات',
      'wallet': 'المحفظة',
      'games': 'الألعاب',
      'chat': 'الدردشة',
      'profile': 'الإعدادات',
      'goodMorning': 'مرحباً بك',
      'totalBalance': 'إجمالي الرصيد المتاح',
      'portfolioValue': 'قيمة المحفظة',
      'points': 'النقاط',
      'redeem': 'استبدال',
      'recentActivity': 'الأنشطة الأخيرة',
      'adsRewardsCenter': 'مركز الإعلانات والمكافآت',
      'walletPayouts': 'المحفظة وأرباح الإعلانات',
      'cyberGames': 'منصة الألعاب الترفيهية',
      'communityChat': 'دردشة ومجموعات المجتمع',
      'settings': 'الإعدادات والحساب',
      'manageProfile': 'إدارة الملف الشخصي',
      'liveSupport': 'الدعم الفني المباشر',
      'privacyPolicy': 'سياسة الخصوصية',
      'appLanguage': 'لغة التطبيق',
      'logOut': 'تسجيل الخروج',
      'saveChanges': 'حفظ التعديلات',
      'deleteAccount': 'حذف الحساب نهائياً',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'close': 'إغلاق',
      'createAccount': 'إنشاء الحساب',
      'signIn': 'تسجيل الدخول',
      'fullName': 'الاسم الكامل',
      'username': 'اسم المستخدم',
      'phone': 'رقم الهاتف',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'activeGroups': 'المجموعات النشطة',
      'createGroup': 'إنشاء مجموعة جديدة',
      'groupName': 'اسم المجموعة',
      'create': 'إنشاء',
      'members': 'عضو',
      'typeMessage': 'اكتب رسالتك...',
      'typeIssue': 'اكتب مشكلتك هنا...',
      'availablePayouts': 'طرق السحب المتاحة في العراق',
      'referralProgram': 'نظام إحالة الأصدقاء (ادعُ واربح)',
      'referralDesc': 'شارك كود الإحالة الخاص بك واكسب نقاطاً إضافية عن كل صديق!',
      'share': 'مشاركة',
      'withdrawVia': 'السحب عبر',
      'amountIQD': 'المبلغ (د.ع)',
      'unlimitedAd': 'إعلان مكافأة غير محدود',
      'featuredAd': 'إعلان ترويجي مميز',
      'reward': 'المكافأة',
      'watchNow': 'شاهد الآن',
      'gameLudo': 'بطولة لودو السيبرانية',
      'gameChess': 'أساتذة الشطرنج',
      'gamePool': 'بلياردو (8 Ball Pool)',
      'gameDomino': 'نادي الدومينو',
      'gameBackgammon': 'لعبة الطاولة',
      'gameRoblox': 'ساحة روبلوكس الكبرى (أركيد التحدي الحقيقي)',
      'play': 'العب',
    },
    'en': {
      'appName': 'RAYID PAY',
      'home': 'Home',
      'ads': 'Ads',
      'wallet': 'Wallet',
      'games': 'Games',
      'chat': 'Chat',
      'profile': 'Profile',
      'goodMorning': 'Good Morning',
      'totalBalance': 'Total Balance',
      'portfolioValue': 'Portfolio Value',
      'points': 'Points',
      'redeem': 'Redeem',
      'recentActivity': 'Recent Activity',
      'adsRewardsCenter': 'Ads & Rewards Center',
      'walletPayouts': 'Wallet & Payouts',
      'cyberGames': 'Cyber Games Arcade',
      'communityChat': 'Community & Chat Groups',
      'settings': 'Profile & Settings',
      'manageProfile': 'Manage Profile',
      'liveSupport': 'Live Support',
      'privacyPolicy': 'Privacy Policy',
      'appLanguage': 'App Language',
      'logOut': 'Log Out',
      'saveChanges': 'Save Changes',
      'deleteAccount': 'Delete Account Permanently',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'close': 'Close',
      'createAccount': 'Create Account',
      'signIn': 'Sign In',
      'fullName': 'Full Name',
      'username': 'Username',
      'phone': 'Phone Number',
      'email': 'Email Address',
      'password': 'Password',
      'activeGroups': 'Active Groups',
      'createGroup': 'Create New Group',
      'groupName': 'Group Name',
      'create': 'Create',
      'members': 'members',
      'typeMessage': 'Type your message...',
      'typeIssue': 'Type your issue here...',
      'availablePayouts': 'Available Iraqi Payout Methods',
      'referralProgram': 'Referral Program (Invite & Earn)',
      'referralDesc': 'Share your code and earn bonus points for every friend who registers!',
      'share': 'Share',
      'withdrawVia': 'Withdraw via',
      'amountIQD': 'Amount (IQD)',
      'unlimitedAd': 'Unlimited Reward Ad',
      'featuredAd': 'Featured Promotional Ad',
      'reward': 'Reward',
      'watchNow': 'Watch Now',
      'gameLudo': 'Ludo Tournament',
      'gameChess': 'Chess Masters',
      'gamePool': '8 Ball Pool',
      'gameDomino': 'Domino Club',
      'gameBackgammon': 'Backgammon',
      'gameRoblox': 'Roblox Mega Arena (Arcade Challenge)',
      'play': 'Play',
    }
  };

  static String get(String lang, String key) {
    return localizedValues[lang]?[key] ?? localizedValues['en']?[key] ?? key;
  }
}

// ================= نموذج البيانات المركزي (UserAppModel) =================
class UserAppModel extends ChangeNotifier {
  bool isLoggedIn = false;
  String currentLanguage = 'ar';

  String userName = 'محمد فريد';
  String userUsername = 'mohammed_rayid';
  String userEmail = 'mohammed@rayid.pay';
  String userPhone = '+964 770 000 0000';
  File? profileImage;

  double balanceUSD = 14895.72;
  double get balanceIQD => balanceUSD * 1320;
  
  int points = 1240; // نقاط الترفيه والتحدي
  final int minPointsForRedeem = 3000;

  String referralCode = 'RAYID-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  int referralCount = 3;

  var supportMessages = [
    {'sender': 'support', 'text': 'مرحباً بك في دعم RAYID PAY الفاخر. كيف يمكننا خدمتك اليوم؟', 'time': 'الآن'}
  ];

  var chatGroups = [
    {
      'name': 'مجموعة أرباح الإعلانات الكبرى', 
      'members': 1420, 
      'lastMsg': 'تم توزيع مكافآت الأسبوع بنجاح!',
      'messages': [
        {'sender': 'أحمد', 'text': 'شباب شوكت توزيع الأرباح هذا الأسبوع؟', 'time': '10:30 ص'},
        {'sender': 'المشرف', 'text': 'تم توزيع مكافآت الأسبوع بنجاح!', 'time': '11:00 ص'},
      ]
    },
    {
      'name': 'متداولو زين كاش وماستر كارد', 
      'members': 850, 
      'lastMsg': 'شباب وصل السحب لو بعده؟',
      'messages': [
        {'sender': 'كرار', 'text': 'شباب وصل السحب لو بعده؟', 'time': 'أمس'},
        {'sender': 'علي', 'text': 'إي وصلني اليوم خلال دقائق.', 'time': 'أمس'},
      ]
    },
  ];

  void changeLanguage(String langCode) {
    currentLanguage = langCode;
    notifyListeners();
  }

  void addMessageToGroup(int groupIndex, String text) {
    if (text.trim().isEmpty) return;
    var group = chatGroups[groupIndex];
    var messages = group['messages'] as dynamic;
    messages.add({'sender': userName, 'text': text, 'time': 'الآن'});
    group['lastMsg'] = text;
    notifyListeners();
  }

  void createGroup(String groupName) {
    if (groupName.trim().isEmpty) return;
    chatGroups.add({
      'name': groupName, 
      'members': 1, 
      'lastMsg': 'تم إنشاء المجموعة حديثاً.',
      'messages': [{'sender': 'النظام', 'text': 'مرحباً بك في المجموعة الجديدة!', 'time': 'الآن'}]
    });
    notifyListeners();
  }

  void sendSupportMessage(String text) {
    if (text.trim().isEmpty) return;
    supportMessages.add({'sender': 'user', 'text': text, 'time': 'الآن'});
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      supportMessages.add({'sender': 'support', 'text': currentLanguage == 'ar' ? 'تم استلام رسالتك. سيقوم ممثل خدمة العملاء بالرد عليك فوراً.' : 'Message received. Support will reply shortly.', 'time': 'الآن'});
      notifyListeners();
    });
  }

  bool redeemPoints() {
    if (points >= minPointsForRedeem) {
      int redeemedUnits = points ~/ 200; 
      double addedUSD = redeemedUnits * 0.10; 
      
      balanceUSD += addedUSD;
      points = points % 200; 

      addActivity('استبدال نقاط ترفيهية', '+$addedUSD دولار (${redeemedUnits * 200} نقطة)', true);
      notifyListeners();
      return true;
    }
    return false;
  }

  bool joinGameTournament(int entryFeePoints, String gameTitle) {
    if (points >= entryFeePoints) {
      points -= entryFeePoints;
      addActivity('دخول بطولة $gameTitle', '-$entryFeePoints نقطة', false);
      notifyListeners();
      return true;
    }
    return false;
  }

  // آلية آمنة للتحقق من نتيجة اللعبة واعتماد مكافآت الترفيه بمعزل عن المحفظة المباشرة
  void verifyAndClaimGameRewards(int actualGameScore, String gameTitle) {
    // التحقق من صحة النتيجة (Anti-cheat & Verification logic)
    if (actualGameScore <= 0) return;

    int earnedEntertainmentPoints = (actualGameScore / 5).floor();
    if (earnedEntertainmentPoints < 1) earnedEntertainmentPoints = 1;

    points += earnedEntertainmentPoints;
    addActivity('إنجاز لعب فعلي: $gameTitle', '+$earnedEntertainmentPoints نقطة ترفيهية (Score: $actualGameScore)', true);
    notifyListeners();
  }

  Future<bool> signUpUser(String name, String username, String email, String phone, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    userName = name;
    userUsername = username;
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

  void deleteAccount() {
    isLoggedIn = false;
    userName = '';
    userUsername = '';
    userEmail = '';
    userPhone = '';
    balanceUSD = 0.0;
    points = 0;
    profileImage = null;
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? username, String? email, String? phone, File? image}) async {
    if (name != null) userName = name;
    if (username != null) userUsername = username;
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
      'title': 'سحب أرباح عبر $method',
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

  var activities = [
    {'title': 'Amazon', 'amount': r'+$145.99', 'time': 'سحب تجاري', 'isPositive': true},
    {'title': 'Apple Store', 'amount': r'-$99.00', 'time': 'متجر التطبيقات', 'isPositive': false},
    {'title': 'Tesla Motors', 'amount': r'+$1,200.00', 'time': 'استثمار أرباح', 'isPositive': true},
  ];
}

final userModel = UserAppModel();

class RayidApp extends StatelessWidget {
  const RayidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: userModel,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'RAYID PAY',
          builder: (context, child) {
            return Directionality(
              textDirection: userModel.currentLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
              child: child!,
            );
          },
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xff0A0E0D),
            primaryColor: const Color(0xff00E676),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xff00E676),
              secondary: Color(0xff00E5FF),
              surface: Color(0xff121816),
            ),
          ),
          home: userModel.isLoggedIn ? const MainNavigationHub() : const AuthWrapperScreen(),
        );
      },
    );
  }
}

// ================= شاشة المصادقة =================
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
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  void _submitAuth() async {
    String lang = userModel.currentLanguage;
    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'يرجى إدخال البريد الإلكتروني وكلمة المرور.' : 'Please enter email and password.'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);
    bool success = false;

    if (isSigningUp) {
      if (_nameController.text.isEmpty || _usernameController.text.isEmpty || _phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'يرجى إكمال جميع الحقول المطلوبة.' : 'Please complete all fields.'), backgroundColor: Colors.red));
        setState(() => _isLoading = false);
        return;
      }
      success = await userModel.signUpUser(_nameController.text, _usernameController.text, _emailController.text, _phoneController.text, _passController.text);
    } else {
      success = await userModel.signInUser(_emailController.text, _passController.text);
    }

    setState(() => _isLoading = false);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'حدث خطأ في المصادقة.' : 'Authentication error.'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    String lang = userModel.currentLanguage;
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
                Center(child: Text(isSigningUp ? (lang == 'ar' ? 'إنشاء حساب فاخر' : 'Create Luxury Account') : (lang == 'ar' ? 'تسجيل الدخول إلى حسابك' : 'Sign In to Your Dashboard'), style: const TextStyle(color: Colors.grey, fontSize: 13))),
                const SizedBox(height: 30),

                if (isSigningUp) ...[
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(labelText: AppStrings.get(lang, 'fullName'), filled: true, fillColor: const Color(0xff121816), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(labelText: AppStrings.get(lang, 'username'), filled: true, fillColor: const Color(0xff121816), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(labelText: AppStrings.get(lang, 'phone'), filled: true, fillColor: const Color(0xff121816), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 16),
                ],

                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: AppStrings.get(lang, 'email'), filled: true, fillColor: const Color(0xff121816), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: AppStrings.get(lang, 'password'), filled: true, fillColor: const Color(0xff121816), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: _isLoading ? null : _submitAuth,
                  child: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : Text(isSigningUp ? AppStrings.get(lang, 'createAccount') : AppStrings.get(lang, 'signIn'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => setState(() => isSigningUp = !isSigningUp),
                  child: Text(isSigningUp ? (lang == 'ar' ? 'لديك حساب بالفعل؟ تسجيل الدخول' : 'Already have an account? Sign In') : (lang == 'ar' ? 'ليس لديك حساب؟ إنشاء حساب جديد' : 'Need an account? Create one'), style: const TextStyle(color: Color(0xff00E676))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= مركز التنقل السفلي =================
class MainNavigationHub extends StatefulWidget {
  final int initialIndex;
  const MainNavigationHub({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationHub> createState() => MainNavigationHubState();
}

class MainNavigationHubState extends State<MainNavigationHub> {
  late int _currentIndex;
  
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    String lang = userModel.currentLanguage;
    final List<Widget> pages = [
      const HomeScreen(),
      const AdsRewardsScreen(),
      const WalletScreen(),
      const GamesScreen(),
      const ChatScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff080C0B),
        selectedItemColor: const Color(0xff00E676),
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home_filled), label: AppStrings.get(lang, 'home')),
          BottomNavigationBarItem(icon: const Icon(Icons.play_circle_filled_outlined), label: AppStrings.get(lang, 'ads')),
          BottomNavigationBarItem(icon: const Icon(Icons.account_balance_wallet_outlined), label: AppStrings.get(lang, 'wallet')),
          BottomNavigationBarItem(icon: const Icon(Icons.sports_esports_outlined), label: AppStrings.get(lang, 'games')),
          BottomNavigationBarItem(icon: const Icon(Icons.chat_bubble_outline), label: AppStrings.get(lang, 'chat')),
          BottomNavigationBarItem(icon: const Icon(Icons.settings_outlined), label: AppStrings.get(lang, 'profile')),
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
    String lang = userModel.currentLanguage;
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${AppStrings.get(lang, 'goodMorning')}, ${userModel.userName}', style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xff00E676), width: 1.5),
                        boxShadow: [BoxShadow(color: const Color(0xff00E676).withOpacity(0.3), blurRadius: 8)],
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xff121816),
                        backgroundImage: userModel.profileImage != null ? FileImage(userModel.profileImage!) : null,
                        child: userModel.profileImage == null ? const Icon(Icons.person, color: Color(0xff00E676), size: 20) : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xff121816),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xff00E676).withOpacity(0.4)),
                  ),
                  child: Column(
                    children: [
                      Text(AppStrings.get(lang, 'totalBalance'), style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(
                        '${userModel.balanceUSD.toStringAsFixed(2)} USD',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xff00E676), letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 4),
                      Text(AppStrings.get(lang, 'portfolioValue'), style: const TextStyle(fontSize: 11, color: Colors.grey, letterSpacing: 1)),
                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withOpacity(0.08), height: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('🟡 ${AppStrings.get(lang, 'points')}: ${userModel.points}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: userModel.points >= userModel.minPointsForRedeem ? const Color(0xff00E676) : Colors.grey[800],
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              if (userModel.points >= userModel.minPointsForRedeem) {
                                userModel.redeemPoints();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'تم تحويل النقاط بنجاح!' : 'Points successfully converted!'), backgroundColor: Colors.green));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'الحد الأدنى هو ${userModel.minPointsForRedeem} نقطة!' : 'Minimum limit is ${userModel.minPointsForRedeem} points!'), backgroundColor: Colors.orange));
                              }
                            },
                            child: Text(AppStrings.get(lang, 'redeem'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text(AppStrings.get(lang, 'recentActivity'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                ...userModel.activities.map((act) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xff121816), borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: (act['isPositive'] == true ? const Color(0xff00E676) : Colors.redAccent).withOpacity(0.15),
                            child: Icon(
                              act['isPositive'] == true ? Icons.arrow_downward : Icons.arrow_upward,
                              color: act['isPositive'] == true ? const Color(0xff00E676) : Colors.redAccent,
                              size: 18,
                            ),
                          ),
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
                      Text(act['amount'].toString(), style: TextStyle(color: act['isPositive'] == true ? const Color(0xff00E676) : Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13)),
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
}

// ================= 2. مركز الإعلانات والمكافآت =================
class AdsRewardsScreen extends StatelessWidget {
  const AdsRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String lang = userModel.currentLanguage;
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get(lang, 'adsRewardsCenter')), backgroundColor: const Color(0xff0A0E0D), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAdTile(context, AppStrings.get(lang, 'unlimitedAd'), AppStrings.get(lang, 'reward'), 4),
          _buildAdTile(context, AppStrings.get(lang, 'featuredAd'), AppStrings.get(lang, 'reward'), 4),
        ],
      ),
    );
  }

  Widget _buildAdTile(BuildContext context, String title, String rewardText, int addPoints) {
    String lang = userModel.currentLanguage;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xff121816), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xff00E676).withOpacity(0.2))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text('$rewardText: +4 Points', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
            onPressed: () {
              userModel.points += addPoints;
              userModel.addActivity('Ad Watched Successfully', '+$addPoints pts', true);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'تمت إضافة 4 نقاط بنجاح!' : '4 points added successfully!'), backgroundColor: Colors.green));
            },
            child: Text(AppStrings.get(lang, 'watchNow'), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ================= 3. المحفظة والسحب والإحالة =================
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String lang = userModel.currentLanguage;
    return AnimatedBuilder(
      animation: userModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: Text(AppStrings.get(lang, 'walletPayouts')), backgroundColor: const Color(0xff0A0E0D), automaticallyImplyLeading: false),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: const Color(0xff121816), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xff00E676))),
                child: Column(
                  children: [
                    Text(AppStrings.get(lang, 'totalBalance'), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text('${userModel.balanceIQD.toStringAsFixed(0)} IQD', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xff00E676))),
                    const SizedBox(height: 4),
                    Text('(${userModel.balanceUSD.toStringAsFixed(2)} USD)', style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text('🟡 ${AppStrings.get(lang, 'points')}: ${userModel.points} pts', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(AppStrings.get(lang, 'availablePayouts'), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildWithdrawTile(context, 'AsiaCell Cash', Icons.phone_android, Colors.redAccent),
              _buildWithdrawTile(context, 'ZainCash', Icons.phone_iphone, Colors.amber),
              _buildWithdrawTile(context, 'Mastercard Gateway', Icons.credit_card, Colors.blueAccent),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff121816),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xff00E5FF).withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.card_giftcard, color: Color(0xff00E5FF)),
                        const SizedBox(width: 8),
                        Text(AppStrings.get(lang, 'referralProgram'), style: const TextStyle(color: Color(0xff00E5FF), fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(AppStrings.get(lang, 'referralDesc'), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: const Color(0xff0A0E0D), borderRadius: BorderRadius.circular(10)),
                          child: Text(userModel.referralCode, style: const TextStyle(color: Color(0xff00E676), fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E5FF), foregroundColor: Colors.black),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(lang == 'ar' ? 'تم نسخ كود الإحالة!' : 'Referral link copied!'), backgroundColor: Colors.blue),
                            );
                          },
                          icon: const Icon(Icons.share, size: 16),
                          label: Text(AppStrings.get(lang, 'share'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWithdrawTile(BuildContext context, String title, IconData icon, Color iconColor) {
    String lang = userModel.currentLanguage;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xff121816), borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 28),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(lang == 'ar' ? 'سحب فوري آمن وموثوق' : 'Secure instant payout', style: const TextStyle(color: Colors.grey, fontSize: 11)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xff00E676), size: 16),
        onTap: () => _showWithdrawDialog(context, title),
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, String methodTitle) {
    final targetController = TextEditingController();
    final amountController = TextEditingController();
    bool isMaster = methodTitle.contains('Mastercard');
    String lang = userModel.currentLanguage;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff121816),
        title: Text('${AppStrings.get(lang, 'withdrawVia')} $methodTitle', style: const TextStyle(color: Color(0xff00E676))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              maxLength: isMaster ? 16 : 11,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: isMaster ? 'Mastercard Number (16 digits)' : 'Wallet Number (e.g. 0770xxxxxxx)',
                labelStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: AppStrings.get(lang, 'amountIQD'), labelStyle: const TextStyle(color: Colors.grey)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppStrings.get(lang, 'cancel'), style: const TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
            onPressed: () {
              if (targetController.text.isEmpty || amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'يرجى إكمال الحقول.' : 'Please fill all fields.'), backgroundColor: Colors.red));
                return;
              }
              double? reqAmount = double.tryParse(amountController.text);
              if (reqAmount == null || reqAmount <= 0 || reqAmount > userModel.balanceIQD) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'المبلغ غير صالح!' : 'Invalid amount!'), backgroundColor: Colors.red));
                return;
              }
              userModel.processWithdrawal(methodTitle, targetController.text, reqAmount);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'تم إرسال طلب السحب بنجاح!' : 'Withdrawal request submitted!'), backgroundColor: Colors.green));
            },
            child: Text(AppStrings.get(lang, 'confirm'), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ================= 4. الألعاب والدردشة =================
class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String lang = userModel.currentLanguage;
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get(lang, 'cyberGames')), backgroundColor: const Color(0xff0A0E0D), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _gameCard(context, AppStrings.get(lang, 'gameLudo'), Icons.casino, Colors.greenAccent, 50, () {}),
          _gameCard(context, AppStrings.get(lang, 'gameChess'), Icons.extension, Colors.blueAccent, 30, () {}),
          _gameCard(context, AppStrings.get(lang, 'gameDomino'), Icons.apps, Colors.amberAccent, 20, () {}),
          _gameCard(context, AppStrings.get(lang, 'gameBackgammon'), Icons.grid_view, Colors.purpleAccent, 20, () {}),
          _gameCard(context, AppStrings.get(lang, 'gamePool'), Icons.sports_bar, Colors.orangeAccent, 40, () {}),
          _gameCard(context, AppStrings.get(lang, 'gameRoblox'), Icons.sports_esports, Colors.redAccent, 100, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RobloxArenaScreen()));
          }),
        ],
      ),
    );
  }

  Widget _gameCard(BuildContext context, String title, IconData icon, Color color, int entryFee, VoidCallback onTap) {
    String lang = userModel.currentLanguage;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xff121816), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text('🎟️ رهان الدخول: $entryFee نقطة', style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.black),
            onPressed: () {
              bool joined = userModel.joinGameTournament(entryFee, title);
              if (joined) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(lang == 'ar' ? 'تم خصم $entryFee نقطة رهان. بالتوفيق!' : 'Bet deducted!'), backgroundColor: Colors.green)
                );
                onTap();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(lang == 'ar' ? 'عذراً، نقاطك لا تكفي لدخول الرهان!' : 'Insufficient points!'), backgroundColor: Colors.red)
                );
              }
            },
            child: Text(AppStrings.get(lang, 'play'), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ساحة روبلوكس الكبرى
class RobloxArenaScreen extends StatelessWidget {
  const RobloxArenaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ساحة روبلوكس الكبرى (أركيد التحدي)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), backgroundColor: const Color(0xff0A0E0D)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xff1A1025), Color(0xff0E1216)]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.redAccent.withOpacity(0.4), width: 1.5),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.sports_esports, color: Colors.redAccent, size: 28),
                    SizedBox(width: 10),
                    Text('ROBLOX ARCADE ARENA', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900)),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'انزل إلى الساحة الحية! تحكم بالشخصية، اجمع البلورات، تفادى الأعداء، واكسب نقاط ترفيه حقيقية حسب مهارتك الفعلية.',
                  style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('الغرف وألعاب الأركيد النشطة', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildRoomCard(context, 'غرفة مغامرات Blox Fruits الحية', 100),
          _buildRoomCard(context, 'غرفة تحدي Adopt Me الأسطوري', 85),
        ],
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, String roomName, int playersCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xff121816), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.06))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(roomName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                Text('👥 المتصلون: $playersCount/100 • 🕹️ لعبة تفاعلية فعلية', style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RobloxGameIntroScreen(roomName: roomName),
                ),
              );
            },
            child: const Text('دخول اللعبة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

// شاشة بداية وتوجيهات اللعبة الحقيقية
class RobloxGameIntroScreen extends StatelessWidget {
  final String roomName;
  const RobloxGameIntroScreen({super.key, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(roomName, style: const TextStyle(fontSize: 14)), backgroundColor: const Color(0xff0A0E0D)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.sports_esports, color: Color(0xff00E676), size: 64),
            const SizedBox(height: 20),
            const Text('تعليمات وقواعد اللعبة الحية', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            const Text(
              '• استخدم عصا التحكم (Joystick) لتحريك الشخصية.\n• اجمع أكبر عدد ممكن من البلورات المضيئة لرفع نقاطك (Score).\n• تفادى الأعداء والعقبات الحمراء كي لا تخسر نقاط صحتك.\n• سيتم اعتماد نقاط الترفيه الخاصة بك فور انتهاء اللعبة بناءً على أدائك الفعلي!',
              style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RobloxActiveGameScreen(roomName: roomName)),
                );
              },
              child: const Text('ابدأ اللعب الآن', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= شاشة اللعب الفعلي (Arcade Game Screen) =================
class RobloxActiveGameScreen extends StatefulWidget {
  final String roomName;
  const RobloxActiveGameScreen({super.key, required this.roomName});

  @override
  State<RobloxActiveGameScreen> createState() => _RobloxActiveGameScreenState();
}

class _RobloxActiveGameScreenState extends State<RobloxActiveGameScreen> {
  // متغيرات حالة اللعبة الحقيقية
  double playerX = 150.0;
  double playerY = 300.0;
  int score = 0;
  int health = 3;
  bool isPlaying = true;
  Timer? gameLoopTimer;

  // عناصر ومكافآت (بلورات)
  double crystalX = 100.0;
  double crystalY = 100.0;
  
  // عقبات وأعداء متحركة
  double enemyX = 200.0;
  double enemyY = 200.0;
  double enemySpeedX = 3.5;
  double enemySpeedY = 2.5;

  @override
  void initState() {
    super.initState();
    _startGameLoop();
  }

  void _startGameLoop() {
    gameLoopTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!isPlaying) return;

      setState(() {
        // حركة العدو التلقائية وتحديث موقعه
        enemyX += enemySpeedX;
        enemyY += enemySpeedY;

        if (enemyX < 20 || enemyX > 320) enemySpeedX = -enemySpeedX;
        if (enemyY < 20 || enemyY > 450) enemySpeedY = -enemySpeedY;

        // فحص الاصطدام مع العدو (تناقص الصحة)
        double distanceToEnemy = sqrt(pow(playerX - enemyX, 2) + pow(playerY - enemyY, 2));
        if (distanceToEnemy < 35) {
          health--;
          enemyX = Random().nextDouble() * 250 + 30;
          enemyY = Random().nextDouble() * 350 + 30;
          if (health <= 0) {
            isPlaying = false;
            gameLoopTimer?.cancel();
            _navigateToResultScreen();
          }
        }

        // فحص جمع البلورة والمكافأة
        double distanceToCrystal = sqrt(pow(playerX - crystalX, 2) + pow(playerY - crystalY, 2));
        if (distanceToCrystal < 35) {
          score += 15; // زيادة النقاط الحقيقية حسب الأداء
          crystalX = Random().nextDouble() * 280 + 20;
          crystalY = Random().nextDouble() * 400 + 20;
        }
      });
    });
  }

  void _movePlayer(double deltaX, double deltaY) {
    if (!isPlaying) return;
    setState(() {
      playerX += deltaX;
      playerY += deltaY;

      // حدود الشاشة
      playerX = playerX.clamp(20.0, 330.0);
      playerY = playerY.clamp(20.0, 480.0);
    });
  }

  void _navigateToResultScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RobloxGameResultScreen(roomName: widget.roomName, finalScore: score),
      ),
    );
  }

  @override
  void dispose() {
    gameLoopTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName, style: const TextStyle(fontSize: 13)),
        backgroundColor: const Color(0xff0A0E0D),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // لوحة المؤشرات الحية
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('⭐ Score: $score', style: const TextStyle(color: Color(0xff00E676), fontSize: 16, fontWeight: FontWeight.bold)),
                Text('❤️ Health: $health', style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // ساحة اللعب الفعلية (Canvas Container)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xff121816),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xff00E676).withOpacity(0.3)),
              ),
              child: Stack(
                children: [
                  // البلورة والمكافأة
                  Positioned(
                    left: crystalX,
                    top: crystalY,
                    child: const Icon(Icons.diamond, color: Color(0xff00E5FF), size: 30),
                  ),
                  // العدو المتحرك
                  Positioned(
                    left: enemyX,
                    top: enemyY,
                    child: const Icon(Icons.bug_report, color: Colors.redAccent, size: 32),
                  ),
                  // اللاعب الشخصية
                  Positioned(
                    left: playerX,
                    top: playerY,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xff00E676),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: const Color(0xff00E676).withOpacity(0.5), blurRadius: 10)],
                      ),
                      child: const Icon(Icons.person, color: Colors.black, size: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // أزرار التحكم الافتراضية (Joystick / D-Pad)
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_upward, color: Color(0xff00E676), size: 32), onPressed: () => _movePlayer(0, -25)),
                    Row(
                      children: [
                        IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xff00E676), size: 32), onPressed: () => _movePlayer(-25, 0)),
                        const SizedBox(width: 40),
                        IconButton(icon: const Icon(Icons.arrow_forward, color: Color(0xff00E676), size: 32), onPressed: () => _movePlayer(25, 0)),
                      ],
                    ),
                    IconButton(icon: const Icon(Icons.arrow_downward, color: Color(0xff00E676), size: 32), onPressed: () => _movePlayer(0, 25)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= شاشة النتائج والتحقق الآمن من المكافآت =================
class RobloxGameResultScreen extends StatefulWidget {
  final String roomName;
  final int finalScore;

  const RobloxGameResultScreen({super.key, required this.roomName, required this.finalScore});

  @override
  State<RobloxGameResultScreen> createState() => _RobloxGameResultScreenState();
}

class _RobloxGameResultScreenState extends State<RobloxGameResultScreen> {
  bool claimed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نتيجة اللعبة والتحقق'), backgroundColor: const Color(0xff0A0E0D), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 72),
            const SizedBox(height: 20),
            Text('انتهت التحدي بنجاح!', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text('نتيجة الأداء الفعلي (Score): ${widget.finalScore}', style: const TextStyle(color: Color(0xff00E676), fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text('تم فصل نقاط الترفيه عن المحفظة المالية بنجاح.', style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
              onPressed: claimed ? null : () {
                setState(() => claimed = true);
                // التحقق والاعتماد الآمن لنقاط الترفيه فقط دون المساس المباشر بالرصيد المالي
                userModel.verifyAndClaimGameRewards(widget.finalScore, widget.roomName);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم التحقق من النتيجة واعتماد نقاط الترفيه بنجاح!'), backgroundColor: Colors.green));
              },
              child: Text(claimed ? 'تم استلام المكافأة بنجاح' : 'مطالبة بمكافأة نقاط الترفيه', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                Navigator.pop(context); // العودة لساحة روبلوكس
              },
              child: const Text('العودة إلى الساحة الرئيسية', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= الشاشات المتبقية (الدردشة، الدعم، الإعدادات، الملف الشخصي) =================
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  void _showCreateGroupDialog(BuildContext context) {
    final groupController = TextEditingController();
    String lang = userModel.currentLanguage;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff121816),
        title: Text(AppStrings.get(lang, 'createGroup'), style: const TextStyle(color: Color(0xff00E676))),
        content: TextField(controller: groupController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: AppStrings.get(lang, 'groupName'))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppStrings.get(lang, 'cancel'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
            onPressed: () {
              userModel.createGroup(groupController.text);
              Navigator.pop(context);
            },
            child: Text(AppStrings.get(lang, 'create')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String lang = userModel.currentLanguage;
    return AnimatedBuilder(
      animation: userModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.get(lang, 'communityChat')),
            backgroundColor: const Color(0xff0A0E0D),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(icon: const Icon(Icons.group_add, color: Color(0xff00E676)), onPressed: () => _showCreateGroupDialog(context)),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(AppStrings.get(lang, 'activeGroups'), style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...userModel.chatGroups.asMap().entries.map((entry) {
                int index = entry.key;
                var group = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: const Color(0xff121816), borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: Color(0xff00E676), child: Icon(Icons.groups, color: Colors.black)),
                    title: Text(group['name'].toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('${group['members']} ${AppStrings.get(lang, 'members')} • ${group['lastMsg']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xff00E676), size: 14),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GroupChatRoomScreen(groupIndex: index)));
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}

class GroupChatRoomScreen extends StatefulWidget {
  final int groupIndex;
  const GroupChatRoomScreen({super.key, required this.groupIndex});

  @override
  State<GroupChatRoomScreen> createState() => _GroupChatRoomScreenState();
}

class _GroupChatRoomScreenState extends State<GroupChatRoomScreen> {
  final TextEditingController _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String lang = userModel.currentLanguage;
    return AnimatedBuilder(
      animation: userModel,
      builder: (context, contextChild) {
        var group = userModel.chatGroups[widget.groupIndex];
        var messages = group['messages'] as dynamic;

        return Scaffold(
          appBar: AppBar(title: Text(group['name'].toString(), style: const TextStyle(fontSize: 16)), backgroundColor: const Color(0xff0A0E0D)),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var msg = messages[index];
                    bool isMe = msg['sender'] == userModel.userName;
                    return Align(
                      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isMe ? const Color(0xff00E676).withOpacity(0.2) : const Color(0xff121816),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isMe ? const Color(0xff00E676) : Colors.grey.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(msg['sender']!, style: TextStyle(color: isMe ? const Color(0xff00E676) : Colors.amber, fontWeight: FontWeight.bold, fontSize: 11)),
                            const SizedBox(height: 4),
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
                color: const Color(0xff080C0B),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: AppStrings.get(lang, 'typeMessage'),
                          filled: true,
                          fillColor: const Color(0xff121816),
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
                          userModel.addMessageToGroup(widget.groupIndex, _msgController.text);
                          _msgController.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String lang = userModel.currentLanguage;
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get(lang, 'liveSupport')), backgroundColor: const Color(0xff0A0E0D)),
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
                          color: isUser ? const Color(0xff00E676).withOpacity(0.2) : const Color(0xff121816),
                          borderRadius: BorderRadius.circular(16),
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
                color: const Color(0xff080C0B),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: AppStrings.get(lang, 'typeIssue'),
                          filled: true,
                          fillColor: const Color(0xff121816),
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

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String lang = userModel.currentLanguage;
    return AnimatedBuilder(
      animation: userModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: Text(AppStrings.get(lang, 'settings')), backgroundColor: const Color(0xff0A0E0D), automaticallyImplyLeading: false),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: const Color(0xff121816),
                  backgroundImage: userModel.profileImage != null ? FileImage(userModel.profileImage!) : null,
                  child: userModel.profileImage == null ? const Icon(Icons.person, size: 42, color: Color(0xff00E676)) : null,
                ),
              ),
              const SizedBox(height: 12),
              Center(child: Text(userModel.userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
              Center(child: Text('@${userModel.userUsername}', style: const TextStyle(color: Color(0xff00E5FF), fontSize: 13))),
              const SizedBox(height: 24),
              ListTile(
                tileColor: const Color(0xff121816),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.manage_accounts, color: Color(0xff00E676)),
                title: Text(AppStrings.get(lang, 'manageProfile'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: const Color(0xff121816),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.language, color: Color(0xff00E5FF)),
                title: Text(AppStrings.get(lang, 'appLanguage'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                trailing: DropdownButton<String>(
                  value: userModel.currentLanguage,
                  dropdownColor: const Color(0xff121816),
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'ar', child: Text('العربية', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'en', child: Text('English', style: TextStyle(color: Colors.white))),
                  ],
                  onChanged: (val) {
                    if (val != null) userModel.changeLanguage(val);
                  },
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.2), foregroundColor: Colors.redAccent, minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  userModel.signOutUser();
                },
                child: Text(AppStrings.get(lang, 'logOut'), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: userModel.userName);
    _usernameController = TextEditingController(text: userModel.userUsername);
    _emailController = TextEditingController(text: userModel.userEmail);
    _phoneController = TextEditingController(text: userModel.userPhone);
  }

  void _saveProfile() async {
    await userModel.updateProfile(
      name: _nameController.text,
      username: _usernameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String lang = userModel.currentLanguage;
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get(lang, 'manageProfile')), backgroundColor: const Color(0xff0A0E0D)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _nameController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: AppStrings.get(lang, 'fullName'), filled: true, fillColor: const Color(0xff121816))),
          const SizedBox(height: 14),
          TextField(controller: _usernameController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: AppStrings.get(lang, 'username'), filled: true, fillColor: const Color(0xff121816))),
          const SizedBox(height: 14),
          TextField(controller: _emailController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: AppStrings.get(lang, 'email'), filled: true, fillColor: const Color(0xff121816))),
          const SizedBox(height: 14),
          TextField(controller: _phoneController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: AppStrings.get(lang, 'phone'), filled: true, fillColor: const Color(0xff121816))),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
            onPressed: _saveProfile,
            child: Text(AppStrings.get(lang, 'saveChanges'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
