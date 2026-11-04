import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const RayidApp());
}

// ================= نموذج البيانات المركزي (UserAppModel) =================
class UserAppModel extends ChangeNotifier {
  bool isLoggedIn = false;

  String userName = 'Alex';
  String userUsername = 'alex_fintech';
  String userEmail = 'alex@rayid.pay';
  String userPhone = '+964 770 000 0000';
  File? profileImage;

  double balanceUSD = 14895.72;
  double get balanceIQD => balanceUSD * 1320;
  
  int points = 1240;
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
      supportMessages.add({'sender': 'support', 'text': 'تم استلام رسالتك. سيقوم ممثل خدمة العملاء بالرد عليك فوراً.', 'time': 'الآن'});
      notifyListeners();
    });
  }

  bool redeemPoints() {
    if (points >= minPointsForRedeem) {
      int redeemedUnits = points ~/ 200; 
      double addedUSD = redeemedUnits * 0.10; 
      
      balanceUSD += addedUSD;
      points = points % 200; 

      addActivity('استبدال نقاط فاخر', '+$addedUSD دولار (${redeemedUnits * 200} نقطة)', true);
      notifyListeners();
      return true;
    }
    return false;
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
    {'title': 'Amazon', 'amount': '+$145.99', 'time': 'سحب تجاري', 'isPositive': true},
    {'title': 'Apple Store', 'amount': '-$99.00', 'time': 'متجر التطبيقات', 'isPositive': false},
    {'title': 'Tesla Motors', 'amount': '+$1,200.00', 'time': 'استثمار أرباح', 'isPositive': true},
    {'title': 'Netflix Sub', 'amount': '-$15.49', 'time': 'اشتراك ترفيهي', 'isPositive': false},
    {'title': 'Spotify', 'amount': '-$10.99', 'time': 'خدمات موسيقية', 'isPositive': false},
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
          textDirection: TextDirection.ltr, // ليتطابق مع تصميم الصورة تماماً
          child: child!,
        );
      },
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xff0A0E0D), // أسود زمردي فاخر نفس الصورة
        primaryColor: const Color(0xff00E676),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xff00E676),
          secondary: Color(0xff00E5FF),
          surface: Color(0xff121816),
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
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  void _submitAuth() async {
    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter email and password.'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);
    bool success = false;

    if (isSigningUp) {
      if (_nameController.text.isEmpty || _usernameController.text.isEmpty || _phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all registration fields.'), backgroundColor: Colors.red));
        setState(() => _isLoading = false);
        return;
      }
      success = await userModel.signUpUser(_nameController.text, _usernameController.text, _emailController.text, _phoneController.text, _passController.text);
    } else {
      success = await userModel.signInUser(_emailController.text, _passController.text);
    }

    setState(() => _isLoading = false);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Authentication error. Try again.'), backgroundColor: Colors.red));
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
                Center(child: Text(isSigningUp ? 'Create Luxury Account' : 'Sign In to Your Dashboard', style: const TextStyle(color: Colors.grey, fontSize: 13))),
                const SizedBox(height: 30),

                if (isSigningUp) ...[
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(labelText: 'Full Name', filled: true, fillColor: const Color(0xff121816), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(labelText: 'Username (e.g. alex_fintech)', filled: true, fillColor: const Color(0xff121816), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(labelText: 'Phone Number', filled: true, fillColor: const Color(0xff121816), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 16),
                ],

                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: 'Email Address', filled: true, fillColor: const Color(0xff121816), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: 'Password', filled: true, fillColor: const Color(0xff121816), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: _isLoading ? null : _submitAuth,
                  child: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : Text(isSigningUp, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => setState(() => isSigningUp = !isSigningUp),
                  child: Text(isSigningUp ? 'Already have an account? Sign In' : 'Need an account? Create one', style: const TextStyle(color: Color(0xff00E676))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= مركز التنقل السفلي الفاخر (مطابق للصورة) =================
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
        backgroundColor: const Color(0xff080C0B),
        selectedItemColor: const Color(0xff00E676),
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_filled_outlined), label: 'Ads'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports_outlined), label: 'Games'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Profile'),
        ],
      ),
    );
  }
}

// ================= 1. الصفحة الرئيسية (تطابق الصورة الأصلية تماماً) =================
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
                // رأس الصفحة: تحية المستخدم وأيقونة الملف الشخصي المتوهجة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Morning, ${userModel.userName}', style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
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

                // بطاقة إجمالي الرصيد الفاخرة (مطابقة للصورة)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xff121816),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xff00E676).withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(color: const Color(0xff00E676).withOpacity(0.08), blurRadius: 20, spreadRadius: 2)
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text('Total Balance', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                      const SizedBox(height: 8),
                      Text(
                        '${userModel.balanceUSD.toStringAsFixed(2)} USD',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xff00E676), letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 4),
                      const Text('Portfolio Value', style: TextStyle(fontSize: 11, color: Colors.grey, letterSpacing: 1)),
                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withOpacity(0.08), height: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('🟡 Points: ${userModel.points}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
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
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Points successfully converted!'), backgroundColor: Colors.green));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Minimum limit is ${userModel.minPointsForRedeem} points!'), backgroundColor: Colors.orange));
                              }
                            },
                            child: const Text('Redeem', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // قسم البطاقات (Wallet Cards الفاخرة مثل الصورة)
                const Text('Wallet', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [const Color(0xff16221D), const Color(0xff0E1412)]),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xff00E676).withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('AETOS BLACK CARD', style: TextStyle(color: Color(0xff00E676), fontSize: 10, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text('4SB9 12XX XXXX 7E91', style: TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace')),
                            const SizedBox(height: 12),
                            Text('\$${userModel.balanceUSD.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [const Color(0xff161F24), const Color(0xff0E1216)]),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xff00E5FF).withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('TITANIUM PREMIERE', style: TextStyle(color: Color(0xff00E5FF), fontSize: 10, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text('S67B 34XX XXXX 8012', style: TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace')),
                            const SizedBox(height: 12),
                            const Text('\$5,885.27', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // قسم النشاطات الحديثة (Recent Activity مطابقة للصورة تماماً)
                const Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Ads & Rewards Center'), backgroundColor: const Color(0xff0A0E0D), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAdTile(context, 'Unlimited Reward Ad', '+4 Points per view', 4),
          _buildAdTile(context, 'Featured Promotional Ad', '+4 Points per view', 4),
        ],
      ),
    );
  }

  Widget _buildAdTile(BuildContext context, String title, String rewardText, int addPoints) {
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
              Text('Reward: $rewardText', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
            onPressed: () {
              userModel.points += addPoints;
              userModel.addActivity('Ad Watched Successfully', '+$addPoints pts', true);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('4 points added successfully!'), backgroundColor: Colors.green));
            },
            child: const Text('Watch Now', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ================= 3. المحفظة وبوابات السحب والإحالة تحتها =================
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: userModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Wallet & Payouts'), backgroundColor: const Color(0xff0A0E0D), automaticallyImplyLeading: false),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: const Color(0xff121816), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xff00E676))),
                child: Column(
                  children: [
                    const Text('Available Balance for Payout', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text('${userModel.balanceIQD.toStringAsFixed(0)} IQD', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xff00E676))),
                    const SizedBox(height: 4),
                    Text('(${userModel.balanceUSD.toStringAsFixed(2)} USD)', style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text('🟡 Points Balance: ${userModel.points} pts', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text('Available Iraqi Payout Methods', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildWithdrawTile(context, 'AsiaCell Cash', Icons.phone_android, Colors.redAccent),
              _buildWithdrawTile(context, 'ZainCash', Icons.phone_iphone, Colors.amber),
              _buildWithdrawTile(context, 'Mastercard Gateway', Icons.credit_card, Colors.blueAccent),
              const SizedBox(height: 24),

              // بطاقة الإحالة تحت بوابات السحب تماماً
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
                    const Row(
                      children: [
                        Icon(Icons.card_giftcard, color: Color(0xff00E5FF)),
                        SizedBox(width: 8),
                        Text('Referral Program (Invite & Earn)', style: TextStyle(color: Color(0xff00E5FF), fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Share your code and earn bonus points for every friend who registers!', style: TextStyle(color: Colors.grey, fontSize: 12)),
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
                              const SnackBar(content: Text('Referral link copied to clipboard!'), backgroundColor: Colors.blue),
                            );
                          },
                          icon: const Icon(Icons.share, size: 16),
                          label: const Text('Share', style: TextStyle(fontWeight: FontWeight.bold)),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xff121816), borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 28),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: const Text('Secure instant payout', style: TextStyle(color: Colors.grey, fontSize: 11)),
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
        backgroundColor: const Color(0xff121816),
        title: Text('Withdraw via $methodTitle', style: const TextStyle(color: Color(0xff00E676))),
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
              decoration: const InputDecoration(labelText: 'Amount (IQD)', labelStyle: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
            onPressed: () {
              if (targetController.text.isEmpty || amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields.'), backgroundColor: Colors.red));
                return;
              }
              double? reqAmount = double.tryParse(amountController.text);
              if (reqAmount == null || reqAmount <= 0 || reqAmount > userModel.balanceIQD) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid amount or exceeds balance!'), backgroundColor: Colors.red));
                return;
              }
              userModel.processWithdrawal(methodTitle, targetController.text, reqAmount);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Withdrawal request submitted successfully!'), backgroundColor: Colors.green));
            },
            child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold)),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Cyber Games Arcade'), backgroundColor: const Color(0xff0A0E0D), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _gameCard(context, 'Cyber Ludo Tournament', Icons.casino, Colors.greenAccent),
          _gameCard(context, 'Neon Chess Masters', Icons.extension, Colors.blueAccent),
          _gameCard(context, 'Cyber Football League', Icons.sports_soccer, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _gameCard(BuildContext context, String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xff121816), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.black),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Launching $title...'))),
            child: const Text('Play'),
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  void _showCreateGroupDialog(BuildContext context) {
    final groupController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff121816),
        title: const Text('Create New Group', style: TextStyle(color: Color(0xff00E676))),
        content: TextField(
          controller: groupController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Group Name', labelStyle: TextStyle(color: Colors.grey)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
            onPressed: () {
              userModel.createGroup(groupController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Group created successfully!'), backgroundColor: Colors.green));
            },
            child: const Text('Create', style: TextStyle(fontWeight: FontWeight.bold)),
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
            title: const Text('Community & Chat Groups'),
            backgroundColor: const Color(0xff0A0E0D),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(icon: const Icon(Icons.group_add, color: Color(0xff00E676)), onPressed: () => _showCreateGroupDialog(context)),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Active Groups', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
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
                    subtitle: Text('${group['members']} members • ${group['lastMsg']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
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
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
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
                          hintText: 'Type your message...',
                          hintStyle: const TextStyle(color: Colors.grey),
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
    return Scaffold(
      appBar: AppBar(title: const Text('24/7 Live Support'), backgroundColor: const Color(0xff0A0E0D)),
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
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isUser ? const Color(0xff00E676).withOpacity(0.2) : const Color(0xff121816),
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
                color: const Color(0xff080C0B),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Type your issue here...',
                          hintStyle: const TextStyle(color: Colors.grey),
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

// ================= 5. شاشة الإعدادات (الملف الشخصي واليوزرنيم وحذف الحساب) =================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: userModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile & Settings'), backgroundColor: const Color(0xff0A0E0D), automaticallyImplyLeading: false),
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

              const Text('Account Settings', style: TextStyle(color: Color(0xff00E676), fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 10),

              ListTile(
                tileColor: const Color(0xff121816),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.manage_accounts, color: Color(0xff00E676)),
                title: const Text('Manage Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('Edit name, username, picture & phone', style: TextStyle(color: Colors.grey, fontSize: 11)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                },
              ),
              const SizedBox(height: 12),

              const Text('Support & Legal', style: TextStyle(color: Color(0xff00E676), fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 8),
              
              ListTile(
                tileColor: const Color(0xff121816),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.support_agent, color: Color(0xff00E676)),
                title: const Text('Live Support', style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen()));
                },
              ),
              const SizedBox(height: 10),

              ListTile(
                tileColor: const Color(0xff121816),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xff00E676)),
                title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () => _showPrivacyPolicyDialog(context),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.2), foregroundColor: Colors.redAccent, minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  userModel.signOutUser();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out successfully.'), backgroundColor: Colors.orange));
                },
                child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff121816),
        title: const Text('Privacy Policy - RAYID PAY', style: TextStyle(color: Color(0xff00E676), fontSize: 16)),
        content: const SingleChildScrollView(
          child: Text(
            'We protect your financial and personal data with advanced encryption.\n\n• Secure Payouts: All withdrawals are fully encrypted.\n• Privacy: Your data is secure and used only for reward processing.',
            style: TextStyle(color: Colors.grey, height: 1.4, fontSize: 13),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close', style: TextStyle(color: Color(0xff00E676))))
        ],
      ),
    );
  }
}

// ================= شاشة إدارة الملف الشخصي وتعديل البيانات والحذف =================
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await userModel.updateProfile(image: File(pickedFile.path));
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile picture updated successfully!'), backgroundColor: Colors.green));
      }
    }
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

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff121816),
        title: const Text('Delete Account Permanently', style: TextStyle(color: Colors.redAccent)),
        content: const Text('Are you sure you want to delete your account? All balances and points will be lost.', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              userModel.deleteAccount();
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account deleted permanently.'), backgroundColor: Colors.red));
            },
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Profile'), backgroundColor: const Color(0xff0A0E0D)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: const Color(0xff121816),
                  backgroundImage: userModel.profileImage != null ? FileImage(userModel.profileImage!) : null,
                  child: userModel.profileImage == null ? const Icon(Icons.person, size: 45, color: Color(0xff00E676)) : null,
                ),
                Positioned(
                  bottom: 0, right: 0,
                  child: CircleAvatar(
                    radius: 16, backgroundColor: const Color(0xff00E676),
                    child: IconButton(icon: const Icon(Icons.camera_alt, size: 14, color: Colors.black), onPressed: _pickImage),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextField(controller: _nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Full Name', filled: true, fillColor: Color(0xff121816))),
          const SizedBox(height: 14),
          TextField(controller: _usernameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Username', filled: true, fillColor: Color(0xff121816), prefixText: '@')),
          const SizedBox(height: 14),
          TextField(controller: _emailController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Email', filled: true, fillColor: Color(0xff121816))),
          const SizedBox(height: 14),
          TextField(controller: _phoneController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Phone', filled: true, fillColor: Color(0xff121816))),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
            onPressed: _saveProfile,
            child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          const SizedBox(height: 40),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, side: const BorderSide(color: Colors.redAccent), minimumSize: const Size(double.infinity, 50)),
            onPressed: _confirmDeleteAccount,
            icon: const Icon(Icons.delete_forever),
            label: const Text('Delete Account Permanently', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
