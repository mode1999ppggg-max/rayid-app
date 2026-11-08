import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'games/ludo/ludo_screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

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
      'adsRewardsCenter': 'مركز الإعلانات والمكافآت التفاعلية',
      'walletPayouts': 'المحفظة وأرباح المنصة (محاكاة)',
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
      'availablePayouts': 'طرق السحب المتاحة (محاكاة تجريبية)',
      'referralProgram': 'نظام إحالة الأصدقاء (ادعُ واربح)',
      'referralDesc': 'شارك كود الإحالة الخاص بك واكسب نقاطاً إضافية عن كل صديق!',
      'share': 'مشاركة',
      'withdrawVia': 'السحب عبر',
      'amountIQD': 'المبلغ (د.ع)',
      'unlimitedAd': 'مكافأة تفاعلية غير محدودة',
      'featuredAd': 'إعلان ترويجي مميز',
      'reward': 'المكافأة',
      'watchNow': 'تفاعل الآن',
      'gameLudo': 'بطولة لودو السيبرانية',
      'gameChess': 'أساتذة الشطرنج',
      'gamePool': 'بلياردو (8 Ball Pool)',
      'gameDomino': 'نادي الدومينو',
      'gameBackgammon': 'لعبة الطاولة',
      'gameRoblox': 'ساحة أركيد النيون (تحدي المنصات)',
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
      'adsRewardsCenter': 'Interactive Ads & Rewards Center',
      'walletPayouts': 'Wallet & Payouts (Simulation)',
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
      'availablePayouts': 'Available Payout Methods (Simulation)',
      'referralProgram': 'Referral Program (Invite & Earn)',
      'referralDesc': 'Share your code and earn bonus points for every friend who registers!',
      'share': 'Share',
      'withdrawVia': 'Withdraw via',
      'amountIQD': 'Amount (IQD)',
      'unlimitedAd': 'Unlimited Interactive Reward',
      'featuredAd': 'Featured Promotional Ad',
      'reward': 'Reward',
      'watchNow': 'Interact Now',
      'gameLudo': 'Ludo Tournament',
      'gameChess': 'Chess Masters',
      'gamePool': '8 Ball Pool',
      'gameDomino': 'Domino Club',
      'gameBackgammon': 'Backgammon',
      'gameRoblox': 'Neon Arcade Arena (Platform Challenge)',
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
  
  int points = 1240; 
  final int minPointsForRedeem = 3000;

  late String referralCode;
  int referralCount = 3;
  int highestGameScore = 0;

  UserAppModel() {
    referralCode = 'RAYID-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  }

  var supportMessages = [
    {'sender': 'support', 'text': 'مرحباً بك في دعم RAYID PAY. كيف يمكننا خدمتك اليوم؟', 'time': 'الآن'}
  ];

  var chatGroups = [
    {
      'name': 'مجموعة أرباح المنصة الكبرى', 
      'members': 1420, 
      'lastMsg': 'تم تحديث نظام التفاعل بنجاح!',
      'messages': [
        {'sender': 'أحمد', 'text': 'شباب كيف نعمل استبدال للنقاط؟', 'time': '10:30 ص'},
        {'sender': 'المشرف', 'text': 'عند الوصول إلى 3000 نقطة يمكنك الاستبدال فوراً.', 'time': '11:00 ص'},
      ]
    },
    {
      'name': 'متداولو المحفظة الرقمية', 
      'members': 850, 
      'lastMsg': 'المحفظة تعمل بشكل ممتاز التجريبي.',
      'messages': [
        {'sender': 'كرار', 'text': 'هل السحب تجريبي حالياً؟', 'time': 'أمس'},
        {'sender': 'علي', 'text': 'نعم، المحفظة تعمل بمحاكاة آمنة ومستقرة.', 'time': 'أمس'},
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
      supportMessages.add({'sender': 'support', 'text': currentLanguage == 'ar' ? 'تم استلام رسالتك. سيقوم فريق الدعم بالرد قريباً.' : 'Message received. Support will reply shortly.', 'time': 'الآن'});
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

  void verifyAndClaimGameRewards(int actualGameScore, String gameTitle) {
    if (actualGameScore <= 0) return;
    if (actualGameScore > highestGameScore) {
      highestGameScore = actualGameScore;
    }
    int earnedEntertainmentPoints = (actualGameScore / 5).floor();
    if (earnedEntertainmentPoints < 1) earnedEntertainmentPoints = 1;

    points += earnedEntertainmentPoints;
    addActivity('إنجاز لعبة الأركيد: $gameTitle', '+$earnedEntertainmentPoints نقطة (Score: $actualGameScore)', true);
    notifyListeners();
  }

  Future<String?> signUpUser(String name, String username, String email, String phone, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    
      if (credential.user != null) {
        userName = name;
       await FirebaseFirestore.instance
    .collection('users')
    .doc(credential.user!.uid)
    .set({
  'uid': credential.user!.uid,
  'name': name,
  'username': username,
  'email': email.trim(),
  'phone': phone,
  'language': currentLanguage,
  'createdAt': FieldValue.serverTimestamp(),
  'updatedAt': FieldValue.serverTimestamp(),
});
        userUsername = username;
        userEmail = email;
        userPhone = phone;
        isLoggedIn = true;
        notifyListeners();
        return null;
      }
    } on FirebaseAuthException catch (e) {
      return e.message ?? e.code;
    } catch (e) {
      return e.toString();
    }
    return 'Unknown error occurred';
  }

  Future<String?> signInUser(String email, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (credential.user != null) {
        userEmail = email;
        isLoggedIn = true;
        notifyListeners();
        return null;
      }
    } on FirebaseAuthException catch (e) {
      return e.message ?? e.code;
    } catch (e) {
      return e.toString();
    }
    return 'Unknown error occurred';
  }

  void signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}
    isLoggedIn = false;
    notifyListeners();
  }

  void deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (_) {}
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
      'title': 'طلب سحب تجريبي عبر $method',
      'amount': '-${amountIQD.toStringAsFixed(0)} د.ع',
      'time': 'الآن (محاكاة)',
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
    {'title': 'Amazon Simulation', 'amount': r'+$145.99', 'time': 'نشاط تجاري', 'isPositive': true},
    {'title': 'App Store Simulation', 'amount': r'-$99.00', 'time': 'متجر التطبيقات', 'isPositive': false},
    {'title': 'Tesla Motors Simulation', 'amount': r'+$1,200.00', 'time': 'أرباح استثمارية', 'isPositive': true},
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
            
scaffoldBackgroundColor: const Color(0xff090711),
primaryColor: const Color(0xff8B5CF6),
colorScheme: const ColorScheme.dark(
  primary: Color(0xff8B5CF6),
  secondary: Color(0xffFFD166),
  surface: Color(0xff171225),
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
    String? errorResult;

    if (isSigningUp) {
      if (_nameController.text.isEmpty || _usernameController.text.isEmpty || _phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'يرجى إكمال جميع الحقول المطلوبة.' : 'Please complete all fields.'), backgroundColor: Colors.red));
        setState(() => _isLoading = false);
        return;
      }
      errorResult = await userModel.signUpUser(_nameController.text, _usernameController.text, _emailController.text, _phoneController.text, _passController.text);
    } else {
      errorResult = await userModel.signInUser(_emailController.text, _passController.text);
    }

    setState(() => _isLoading = false);
    if (errorResult != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $errorResult'), backgroundColor: Colors.red));
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
                Center(child: Text(isSigningUp ? (lang == 'ar' ? 'إنشاء حساب جديد' : 'Create Account') : (lang == 'ar' ? 'تسجيل الدخول إلى حسابك' : 'Sign In to Your Dashboard'), style: const TextStyle(color: Colors.grey, fontSize: 13))),
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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xff090711),
          border: Border(
            top: BorderSide(
              color: Color(0xff8B5CF6),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xff0B0712),
          selectedItemColor: const Color(0xffFFD166),
          unselectedItemColor: const Color(0xff9B8BAE),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              label: AppStrings.get(lang, 'home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.play_circle_fill_rounded),
              label: AppStrings.get(lang, 'ads'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_wallet_rounded),
              label: AppStrings.get(lang, 'wallet'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.sports_esports_rounded),
              label: AppStrings.get(lang, 'games'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat_bubble_rounded),
              label: AppStrings.get(lang, 'chat'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_rounded),
              label: AppStrings.get(lang, 'profile'),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= 1. الواجهة الرئيسية (Cyberpunk Home) =================
 
// ================= RAYID PAY - PREMIUM HOME =================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color bg = Color(0xff090711);
  static const Color card = Color(0xff171225);
  static const Color purple = Color(0xff8B5CF6);
  static const Color gold = Color(0xffFFD166);

  @override
  Widget build(BuildContext context) {
    final String lang = userModel.currentLanguage;
    final bool isAr = lang == 'ar';

    return AnimatedBuilder(
      animation: userModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: bg,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff171027),
                  Color(0xff090711),
                  Color(0xff100B1C),
                ],
              ),
            ),
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  // HEADER
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: gold, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 23,
                          backgroundColor: card,
                          backgroundImage: userModel.profileImage != null
                              ? FileImage(userModel.profileImage!)
                              : null,
                          child: userModel.profileImage == null
                              ? const Icon(
                                  Icons.person,
                                  color: gold,
                                  size: 25,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'RAYID PAY',
                              style: TextStyle(
                                color: gold,
                                fontSize: 12,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${AppStrings.get(lang, 'goodMorning')}, ${userModel.userName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: purple.withOpacity(0.5),
                          ),
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: gold,
                          size: 22,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // BALANCE CARD
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff55318F),
                          Color(0xff25183F),
                          Color(0xff171225),
                        ],
                      ),
                      border: Border.all(
                        color: gold.withOpacity(0.65),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: purple.withOpacity(0.20),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isAr ? 'إجمالي رصيدك' : 'TOTAL BALANCE',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.75),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: gold,
                              size: 25,
                            ),
                          ],
                        ),
                        const SizedBox(height: 17),
                        Text(
                          '${userModel.balanceUSD.toStringAsFixed(2)} USD',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          '≈ ${userModel.balanceIQD.toStringAsFixed(0)} IQD',
                          style: const TextStyle(
                            color: gold,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Container(
                          height: 1,
                          color: Colors.white.withOpacity(0.16),
                        ),
                        const SizedBox(height: 17),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.stars_rounded,
                                  color: gold,
                                  size: 23,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isAr ? 'نقاطك' : 'YOUR POINTS',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      '${userModel.points}',
                                      style: const TextStyle(
                                        color: gold,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    userModel.points >=
                                            userModel.minPointsForRedeem
                                        ? gold
                                        : Colors.white24,
                                foregroundColor: bg,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              onPressed: () {
                                if (userModel.points >=
                                    userModel.minPointsForRedeem) {
                                  userModel.redeemPoints();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isAr
                                            ? 'تم تحويل النقاط بنجاح!'
                                            : 'Points successfully converted!',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isAr
                                            ? 'الحد الأدنى للاستبدال هو ${userModel.minPointsForRedeem} نقطة!'
                                            : 'Minimum limit is ${userModel.minPointsForRedeem} points!',
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                AppStrings.get(lang, 'redeem'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ACTIVITY TITLE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.get(lang, 'recentActivity'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Icon(
                        Icons.history_rounded,
                        color: gold,
                        size: 22,
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // ACTIVITY LIST
                  if (userModel.activities.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: purple.withOpacity(0.25),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          isAr ? 'لا توجد عمليات حالياً' : 'No activity yet',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    )
                  else
                    ...userModel.activities.map(
                      (act) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.07),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: (act['isPositive'] == true
                                        ? Colors.green
                                        : Colors.redAccent)
                                    .withOpacity(0.13),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                act['isPositive'] == true
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded,
                                color: act['isPositive'] == true
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    act['title'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    act['time'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              act['amount'].toString(),
                              style: TextStyle(
                                color: act['isPositive'] == true
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'RAYID PAY • YOUR DIGITAL WORLD',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.30),
                        fontSize: 9,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ================= 2. مركز الإعلانات والمكافآت التفاعلية =================
class AdsRewardsScreen extends StatelessWidget {
  const AdsRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String lang = userModel.currentLanguage;
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get(lang, 'adsRewardsCenter')), backgroundColor: const Color(0xff090711), automaticallyImplyLeading: false),
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
      decoration: BoxDecoration(color: const Color(0xff171225), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text('$rewardText: +4 Points (تفاعل تجريبي)', style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffFFD166), foregroundColor: Colors.black),
            onPressed: () {
              userModel.points += addPoints;
              userModel.addActivity('مكافأة تفاعلية', '+$addPoints pts', true);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'تمت إضافة 4 نقاط تفاعلية بنجاح!' : '4 interactive points added!'), backgroundColor: Colors.green));
            },
            child: Text(AppStrings.get(lang, 'watchNow'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
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
          appBar: AppBar(title: Text(AppStrings.get(lang, 'walletPayouts')), backgroundColor: const Color(0xff090711), automaticallyImplyLeading: false),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
               decoration: BoxDecoration(
  gradient: const LinearGradient(
    colors: [
      Color(0xff55318F),
      Color(0xff25183F),
      Color(0xff171225),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  borderRadius: BorderRadius.circular(24),
  border: Border.all(color: const Color(0xffFFD166), width: 1.2),
  boxShadow: [
    BoxShadow(
      color: const Color(0xff8B5CF6).withOpacity(0.22),
      blurRadius: 18,
      spreadRadius: 2,
    ),
  ],
),
  child: Column(
  children: [
  
                    
                    Text(AppStrings.get(lang, 'totalBalance'), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text('${userModel.balanceIQD.toStringAsFixed(0)} IQD', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xffFFD166))),
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
                  color: const Color(0xff171225),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xffFFD166).withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.card_giftcard, color: Color(0xffFFD166)),
                        const SizedBox(width: 8),
                        Text(AppStrings.get(lang, 'referralProgram'), style: const TextStyle(color: Color(0xffFFD166), fontWeight: FontWeight.bold, fontSize: 14)),
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
                          decoration: BoxDecoration(color: const Color(0xff090711), borderRadius: BorderRadius.circular(10)),
                          child: Text(userModel.referralCode, style: const TextStyle(color: Color(0xffFFD166), fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffFFD166), foregroundColor: Colors.black),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'تم نسخ كود الإحالة!' : 'Referral code copied!'), backgroundColor: Colors.blue));
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
      decoration: BoxDecoration(
  color: const Color(0xff171225),
  borderRadius: BorderRadius.circular(18),
  border: Border.all(
    color: const Color(0xff8B5CF6).withOpacity(0.35),
  ),
),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 28),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(lang == 'ar' ? 'محاكاة سحب تجريبي آمن' : 'Secure simulation payout', style: const TextStyle(color: Colors.grey, fontSize: 11)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xffFFD166), size: 16),
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
        backgroundColor: const Color(0xff171225),
        title: Text('${AppStrings.get(lang, 'withdrawVia')} $methodTitle', style: const TextStyle(color: Color(0xffFFD166))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              maxLength: isMaster ? 16 : 11,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: isMaster ? 'Mastercard Number (16 digits)' : 'Wallet Number (e.g. 0770xxxxxxx)', labelStyle: const TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: AppStrings.get(lang, 'amountIQD'), labelStyle: const TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 6),
            const Text('ملاحظة: هذا الطلب هو محاكاة تجريبية غير متصل بجهة دفع فعلية حالياً.', style: TextStyle(color: const Color(0xffFFD166)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppStrings.get(lang, 'cancel'), style: const TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffFFD166), foregroundColor: Colors.black),
            onPressed: () {
              if (targetController.text.isEmpty || amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'يرجى إكمال الحقول.' : 'Please fill all fields.'), backgroundColor: Colors.red));
                return;
              }
              double? reqAmount = double.tryParse(amountController.text);
              if (reqAmount == null || reqAmount <= 0 || reqAmount > userModel.balanceIQD) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'المبلغ غير صالح أو يفوق الرصيد!' : 'Invalid amount!'), backgroundColor: Colors.red));
                return;
              }
              userModel.processWithdrawal(methodTitle, targetController.text, reqAmount);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'تم تقديم طلب السحب التجريبي بنجاح!' : 'Simulation withdrawal submitted!'), backgroundColor: Colors.green));
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
      appBar: AppBar(title: Text(AppStrings.get(lang, 'cyberGames')), backgroundColor: const Color(0xff0B0712), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _gameCard(context, AppStrings.get(lang, 'gameLudo'), Icons.casino, const Color(0xffFFD166), 50, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LudoLobbyScreen()),
            );
          }),
          _gameCard(context, AppStrings.get(lang, 'gameChess'), Icons.extension, Colors.blueAccent, 30, () {}),
          _gameCard(context, AppStrings.get(lang, 'gameDomino'), Icons.apps,const Color(0xffFFD166), 20, () {}),
          _gameCard(context, AppStrings.get(lang, 'gameBackgammon'), Icons.grid_view, const Color(0xffFFD166), 20, () {}),
          _gameCard(context, AppStrings.get(lang, 'gamePool'), Icons.sports_bar, const Color(0xffFFD166), 40, () {}),
          _gameCard(context, AppStrings.get(lang, 'gameRoblox'), Icons.sports_esports, const Color(0xffFFD166), 100, () {
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
      decoration: BoxDecoration(color: const Color(0xff171225), borderRadius: BorderRadius.circular(20)),
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
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'تم خصم $entryFee نقطة رهان. بالتوفيق!' : 'Bet deducted!'), backgroundColor: Colors.green));
                onTap();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? 'عذراً، نقاطك لا تكفي لدخول الرهان!' : 'Insufficient points!'), backgroundColor: Colors.red));
              }
            },
            child: Text(AppStrings.get(lang, 'play'), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class RobloxArenaScreen extends StatelessWidget {
  const RobloxArenaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ساحة أركيد النيون (تحدي المنصات)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), backgroundColor: const Color(0xff0B0712)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xff1A1025), Color(0xff0E1216)]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xffFFD166).withOpacity(0.4), width: 1.5),
           ),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.sports_esports, color: Colors.redAccent, size: 28),
                    SizedBox(width: 10),
                    Text('NEON ARCADE ARENA', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'لعبة منصات أركيدية بأسلوب نيون مميز! تحكم بالشخصية عبر أزرار اللمس، اقفز بين المنصات السيبرانية، اجمع البلورات، وحقق أعلى نتيجة.',
                  style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.5),
                ),
                const SizedBox(height: 14),
                AnimatedBuilder(
                  animation: userModel,
                  builder: (context, child) {
                    return Text('🏆 أعلى نتيجة حققتها: ${userModel.highestGameScore} نقطة', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 12));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('مراحل الأركيد السيبرانية', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildStageCard(context, 'المرحلة 1: Neon Jungle (سهل)', 1),
          _buildStageCard(context, 'المرحلة 2: Cyber Heights (متوسط)', 2),
          _buildStageCard(context, 'المرحلة 3: Quantum Grid (صعب)', 3),
        ],
      ),
    );
  }

  Widget _buildStageCard(BuildContext context, String stageName, int stageLevel) {
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
                Text(stageName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                const Text('🎮 تحدي أركيدي • قفز وتجميع بلورات', style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Roblox3DPlatformerGameScreen(stageLevel: stageLevel, stageName: stageName),
                ),
              );
            },
            child: const Text('العب الآن', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class Roblox3DPlatformerGameScreen extends StatefulWidget {
  final int stageLevel;
  final String stageName;

  const Roblox3DPlatformerGameScreen({super.key, required this.stageLevel, required this.stageName});

  @override
  State<Roblox3DPlatformerGameScreen> createState() => _Roblox3DPlatformerGameScreenState();
}

class _Roblox3DPlatformerGameScreenState extends State<Roblox3DPlatformerGameScreen> {
  double playerX = 50.0;
  double playerY = 300.0;
  double velocityY = 0.0;
  bool isJumping = false;
  
  int score = 0;
  int coinsCollected = 0;
  int health = 3;
  bool isPlaying = true;
  bool isPaused = false;
  bool hasWon = false;
  
  Timer? gameLoopTimer;
  int hitCooldown = 0;

  List platforms = [];
  List crystals = [];
  List hazards = [];

  @override
  void initState() {
    super.initState();
    _initLevel();
    _startGameLoop();
  }

  void _initLevel() {
    double difficultyMultiplier = widget.stageLevel * 0.6;
    
    platforms = [
      {'x': 0.0, 'y': 420.0, 'w': 220.0, 'h': 28.0},
      {'x': 250.0, 'y': 330.0, 'w': 180.0, 'h': 28.0},
      {'x': 460.0, 'y': 240.0, 'w': 190.0, 'h': 28.0},
      {'x': 680.0, 'y': 150.0, 'w': 220.0, 'h': 28.0},
    ];

    crystals = [
      {'x': 310.0, 'y': 280.0, 'collected': false},
      {'x': 530.0, 'y': 190.0, 'collected': false},
      {'x': 750.0, 'y': 100.0, 'collected': false},
    ];

    hazards = [
      {'x': 290.0, 'y': 305.0, 'dir': 1.0, 'speed': 2.2 * difficultyMultiplier},
      {'x': 510.0, 'y': 215.0, 'dir': -1.0, 'speed': 2.8 * difficultyMultiplier},
    ];
  }

  void _startGameLoop() {
    gameLoopTimer?.cancel();
    gameLoopTimer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      if (!isPlaying || isPaused) return;

      setState(() {
        if (hitCooldown > 0) hitCooldown--;

        velocityY += 0.85;
        playerY += velocityY;

        for (var haz in hazards) {
          haz['x'] = (haz['x'] as double) + ((haz['dir'] as double) * (haz['speed'] as double));
          if ((haz['x'] as double) < 220 || (haz['x'] as double) > 650) {
            haz['dir'] = -(haz['dir'] as double);
          }
        }

        for (var plat in platforms) {
          if (playerX + 38 >= (plat['x'] as double) && 
              playerX <= (plat['x'] as double) + (plat['w'] as double) &&
              playerY + 48 >= (plat['y'] as double) && 
              playerY + 48 <= (plat['y'] as double) + (plat['h'] as double) + 12 && 
              velocityY >= 0) {
            playerY = (plat['y'] as double) - 48.0;
            velocityY = 0.0;
            isJumping = false;
            break;
          }
        }

        if (playerY > 580) {
          _loseLife('سقطت في الهاوية السيبرانية!');
        }

        for (var crystal in crystals) {
          if (crystal['collected'] == false) {
            double dist = sqrt(pow(playerX - (crystal['x'] as double), 2) + pow(playerY - (crystal['y'] as double), 2));
            if (dist < 45) {
              crystal['collected'] = true;
              coinsCollected++;
              score += 50;
            }
          }
        }

        for (var haz in hazards) {
          double distHaz = sqrt(pow(playerX - (haz['x'] as double), 2) + pow(playerY - (haz['y'] as double), 2));
          if (distHaz < 35 && hitCooldown == 0) {
            _loseLife('اصطدمت بعائق نيون جارح!');
            hitCooldown = 45;
            break;
          }
        }

        if (playerX >= 720 && playerX <= 880 && playerY <= 140) {
          hasWon = true;
          isPlaying = false;
          gameLoopTimer?.cancel();
        }
      });
    });
  }

  void _loseLife(String reason) {
    health--;
    if (health <= 0) {
      isPlaying = false;
      gameLoopTimer?.cancel();
    } else {
      playerX = 50.0;
      playerY = 300.0;
      velocityY = 0.0;
    }
  }

  void _restartGame() {
    setState(() {
      playerX = 50.0;
      playerY = 300.0;
      velocityY = 0.0;
      isJumping = false;
      score = 0;
      coinsCollected = 0;
      health = 3;
      isPlaying = true;
      isPaused = false;
      hasWon = false;
      hitCooldown = 0;
      _initLevel();
    });
    _startGameLoop();
  }

  void _movePlayer(double deltaX) {
    if (!isPlaying || isPaused) return;
    setState(() {
      playerX += deltaX;
      playerX = playerX.clamp(0.0, 900.0);
    });
  }

  void _jumpPlayer() {
    if (!isJumping && isPlaying && !isPaused) {
      setState(() {
        velocityY = -15.0;
        isJumping = true;
      });
    }
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
        title: Text(widget.stageName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xff0A0E0D),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(isPaused ? Icons.play_arrow : Icons.pause, color: const Color(0xff00E5FF)),
            onPressed: () {
              setState(() {
                isPaused = !isPaused;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xff121816), Color(0xff1A1025)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xff00E5FF).withOpacity(0.5), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.flash_on, color: Color(0xff00E676), size: 18),
                    const SizedBox(width: 4),
                    Text('SCORE: $score', style: const TextStyle(color: Color(0xff00E676), fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.diamond, color: Color(0xff00E5FF), size: 18),
                    const SizedBox(width: 4),
                    Text('$coinsCollected', style: const TextStyle(color: Color(0xff00E5FF), fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.redAccent, size: 18),
                    const SizedBox(width: 4),
                    Text('HEALTH: $health', style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xff050709),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xff00E5FF), width: 2),
                boxShadow: [
                  BoxShadow(color: const Color(0xff00E5FF).withOpacity(0.3), blurRadius: 18, spreadRadius: 3),
                  BoxShadow(color: const Color(0xff00E676).withOpacity(0.2), blurRadius: 10),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: CyberGridPainter(),
                      ),
                    ),

                    ...platforms.map((plat) => Positioned(
                      left: (plat['x'] as double) - (playerX > 300 ? playerX - 300 : 0),
                      top: plat['y'] as double,
                      child: Container(
                        width: plat['w'] as double,
                        height: plat['h'] as double,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xff00E676), Color(0xff00E5FF), Color(0xffFF007F)]),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: const Color(0xff00E676).withOpacity(0.8), blurRadius: 16, spreadRadius: 2),
                            BoxShadow(color: const Color(0xff00E5FF).withOpacity(0.6), blurRadius: 8),
                          ],
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    )),

                    ...crystals.where((c) => c['collected'] == false).map((c) => Positioned(
                      left: (c['x'] as double) - (playerX > 300 ? playerX - 300 : 0),
                      top: c['y'] as double,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: const Color(0xff00E5FF).withOpacity(0.9), blurRadius: 14, spreadRadius: 3),
                            BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 6),
                          ],
                        ),
                        child: const Icon(Icons.diamond, color: Color(0xff00E5FF), size: 32),
                      ),
                    )),

                    ...hazards.map((h) => Positioned(
                      left: (h['x'] as double) - (playerX > 300 ? playerX - 300 : 0),
                      top: h['y'] as double,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.redAccent.withOpacity(0.95), blurRadius: 16, spreadRadius: 4),
                            BoxShadow(color: Colors.amber.withOpacity(0.6), blurRadius: 8),
                          ],
                        ),
                        child: const Icon(Icons.local_fire_department, color: Colors.redAccent, size: 34),
                      ),
                    )),

                    Positioned(
                      left: playerX > 300 ? 300.0 : playerX,
                      top: playerY,
                      child: Container(
                        width: 42,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xffFF007F), Color(0xff00E5FF), Color(0xff00E676)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(color: const Color(0xffFF007F).withOpacity(0.9), blurRadius: 20, spreadRadius: 3),
                            BoxShadow(color: const Color(0xff00E5FF).withOpacity(0.8), blurRadius: 10),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            hitCooldown > 0 ? Icons.flash_on : Icons.android,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),

                    if (isPaused)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xff121816).withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xff00E5FF), width: 2),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('اللعبة متوقفة مؤقتاً', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
                                onPressed: () => setState(() => isPaused = false),
                                child: const Text('استئناف اللعب', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),

                    if (!isPlaying && !isPaused)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xff121816).withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: hasWon ? const Color(0xff00E676) : Colors.redAccent, width: 2),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(hasWon ? Icons.emoji_events : Icons.sentiment_very_dissatisfied, color: hasWon ? Colors.amber : Colors.redAccent, size: 54),
                              const SizedBox(height: 14),
                              Text(hasWon ? 'تهانينا! أنهيت المرحلة بنجاح' : 'انتهت المحاولة! نفدت قلوب الصحة', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                              const SizedBox(height: 8),
                              Text('النتيجة النهائية: $score | البلورات: $coinsCollected', style: const TextStyle(color: Color(0xff00E676), fontSize: 13)),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800], foregroundColor: Colors.white),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('العودة'),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
                                    onPressed: () {
                                      if (hasWon) {
                                        userModel.verifyAndClaimGameRewards(score, widget.stageName);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إيداع نقاط الترفيه في حسابك بنجاح!'), backgroundColor: Colors.green));
                                        Navigator.pop(context);
                                      } else {
                                        _restartGame();
                                      }
                                    },
                                    child: Text(hasWon ? 'استلام المكافأة' : 'إعادة المحاولة', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xff080C0B),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff121816),
                        foregroundColor: const Color(0xff00E5FF),
                        minimumSize: const Size(60, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Color(0xff00E5FF), width: 1.5)),
                      ),
                      onPressed: () => _movePlayer(-20.0),
                      child: const Icon(Icons.arrow_back, size: 26),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff121816),
                        foregroundColor: const Color(0xff00E5FF),
                        minimumSize: const Size(60, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Color(0xff00E5FF), width: 1.5)),
                      ),
                      onPressed: () => _movePlayer(20.0),
                      child: const Icon(Icons.arrow_forward, size: 26),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00E676),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(130, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 8,
                    shadowColor: const Color(0xff00E676),
                  ),
                  onPressed: _jumpPlayer,
                  child: const Text('JUMP! 🚀', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CyberGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff00E5FF).withOpacity(0.15)
      ..strokeWidth = 1.2;

    for (double i = 0; i < size.width; i += 32) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double j = 0; j < size.height; j += 32) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
              }),
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

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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
