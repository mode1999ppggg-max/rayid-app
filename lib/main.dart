import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RAYID PAY',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xff0d131a), // خلفية داكنة جداً مستوحاة من ويزو
      ),
      // تفعيل اتجاه اليمين إلى اليسار للغة العربية بشكل صحيح من البداية لضمان عدم حدوث تداخل
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'), 
      ],
      locale: const Locale('ar', 'AE'),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // للتحكم بالشريط السفلي
  bool isPlayActive = true; // للتحكم بالأزرار السريعة التفاعلية (Tabs)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. الجزء العلوي (Top Header)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // حالة الاتصال يميناً
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: Row(
                      children: const [
                        CircleAvatar(radius: 4, backgroundColor: Colors.green),
                        SizedBox(width: 6),
                        Text('متصل', style: TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  // شعار التطبيق يساراً
                  const Text(
                    'RAYID PAY',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. بطاقة الملف الشخصي والعدادات العصرية (Profile & Balance)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff161f2c),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('مرحباً لاعب_570575 !', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('أهلاً بك في RAYID PAY', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // عداد النقاط الذهبي
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: const Color(0xff222e3f), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                const Text('🪙', style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('النقاط', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    Text('1,240', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // عداد أرباح المحفظة الأخضر
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: const Color(0xff222e3f), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                const Text('💵', style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('الأرباح', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    Text('\$45.50', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. الأزرار السريعة التفاعلية المقتبسة من ويزو (Quick Tabs)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => isPlayActive = true),
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isPlayActive ? const Color(0xff00ff88) : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                        border: isPlayActive ? null : Border.all(color: Colors.grey[700]!),
                      ),
                      child: Center(
                        child: Text('العب الآن', style: TextStyle(color: isPlayActive ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => setState(() => isPlayActive = false),
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !isPlayActive ? const Color(0xff00ff88) : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                        border: !isPlayActive ? null : Border.all(color: Colors.grey[700]!),
                      ),
                      child: Center(
                        child: Text('شاهد واكسب', style: TextStyle(color: !isPlayActive ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 4. بطاقة العرض التفاعلية الرئيسية (Featured Game Card)
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xff161f2c),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('تحدي الركض والنقاط', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      const Text('Neon Cyber Run', style: TextStyle(fontSize: 14, color: Color(0xff00ff88), fontWeight: FontWeight.w500)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00ff88),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {},
                        child: const Text('ابدأ التحدي الآن', style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 5. قسم النشاطات والمعاملات الأخيرة (Recent Activities)
              const Text('النشاطات والمعاملات الأخيرة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 12),
              _buildActivityTile('🎁', 'مكافأة تسجيل الدخول اليومي', '+30 نقطة', Colors.greenAccent),
              _buildActivityTile('🎮', 'جلسة لعب Neon Cyber Run', '+120 نقطة', Colors.greenAccent),
              _buildActivityTile('🛡️', 'حالة المحفظة الآمنة', 'نشطة ومؤمنة', const Color(0xff00ff88)),
            ],
          ),
        ),
      ),
      // 6. شريط التنقل السفلي المطور بالكامل (Bottom Navigation Bar)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff111823),
        selectedItemColor: const Color(0xff00ff88), // اللون النيون المميز للتفاعل الحالي
        unselectedItemColor: Colors.grey[500],
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports_outlined), label: 'الألعاب'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'المحفظة'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'الدردشة'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'الإعدادات'),
        ],
      ),
    );
  }

  // ودجت مخصصة لبناء عناصر النشاطات الأخيرة بسلاسة وتباين ممتاز
  Widget _buildActivityTile(String emoji, String title, String trailingText, Color trailingColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xff161f2c),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
            ],
          ),
          Text(trailingText, style: TextStyle(fontSize: 14, color: trailingColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
