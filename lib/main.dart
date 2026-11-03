import 'package:flutter/material.dart';

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
      home: const CashPlusHomePage(),
    );
  }
}

class CashPlusHomePage extends StatefulWidget {
  const CashPlusHomePage({super.key});

  @override
  State<CashPlusHomePage> createState() => _CashPlusHomePageState();
}

class _CashPlusHomePageState extends State<CashPlusHomePage> {
  int _points = 28750;

  void _addPoints(int amount) {
    setState(() {
      _points += amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    double usdValue = _points / 100; // كل 100 نقطة تساوي 1 دولار مثلاً

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2321),
        title: Row(
          children: const [
            Icon(Icons.monetization_on, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Cash Plus', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة الرصيد الكبيرة
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
                  const Text(
                    'Available Points',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_points Points',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '(~ \$${usdValue.toStringAsFixed(2)} USD)',
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // أزرار العمليات السريعة (سحب وإرسال)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
                    label: const Text('Redeem Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.send, color: Colors.greenAccent),
                    label: const Text('Send Points', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // قسم المهام لربح النقاط
            const Text(
              'Earn More Points',
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
                _buildTaskCard('Watch Ad Video', '+50 Pts', Icons.play_circle_fill, Colors.blue, () {
                  _addPoints(50);
                }),
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
