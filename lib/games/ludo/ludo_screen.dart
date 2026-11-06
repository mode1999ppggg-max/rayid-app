import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class LudoLobbyScreen extends StatelessWidget {
  const LudoLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0A0E0D),
      appBar: AppBar(
        title: const Text('CYBERPUNK LUDO ARENA', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xff00E5FF), letterSpacing: 1.5)),
        backgroundColor: const Color(0xff080C0B),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xff00E676)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff0A0E0D), Color(0xff050807), Color(0xff0A0E0D)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Icon(Icons.casino, size: 64, color: Color(0xff00E676)),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text('CYBERPUNK LUDO', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2)),
              ),
              const SizedBox(height: 6),
              const Center(
                child: Text('ساحة المعركة السيبرانية المتقدمة بالممرات الكاملة', style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center),
              ),
              const SizedBox(height: 40),

              _buildLobbyButton(
                context,
                title: 'لعب ضد الذكاء الاصطناعي (AI)',
                icon: Icons.smart_toy,
                borderColor: const Color(0xff00E5FF),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LudoGameScreen(isVsAI: true)),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildLobbyButton(
                context,
                title: 'لعب ثنائي (مع صديق)',
                icon: Icons.people,
                borderColor: const Color(0xff00E676),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LudoGameScreen(isVsAI: false)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLobbyButton(BuildContext context, {required String title, required IconData icon, required Color borderColor, required VoidCallback onTap}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff121816),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: borderColor, width: 2),
        ),
        elevation: 6,
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: borderColor, size: 22),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

// ================= شاشة اللعبة المتكاملة مع الممرات والحركة الحقيقية =================
class LudoGameScreen extends StatefulWidget {
  final bool isVsAI;
  const LudoGameScreen({super.key, required this.isVsAI});

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> {
  int diceValue = 6;
  bool isRolling = false;

  // مواضع القطع الأربعة (0 يعني داخل القاعدة، من 1 إلى 52 مسار السباق، 53+ خط النهاية)
  List<int> playerPositions = [0, 0, 0, 0];
  int currentTurn = 0; // 0: أخضر, 1: أصفر, 2: أحمر, 3: أزرق
  String gameStatus = 'دور اللاعب الأخضر (رائد)';
  List<String> chatLogs = [];

  final List<String> playerNames = ['أخضر', 'أصفر', 'أحمر', 'أزرق'];
  final List<Color> playerColors = [Colors.green, Colors.amber, Colors.red, Colors.blue];

  void rollDice() {
    if (isRolling) return;
    setState(() {
      isRolling = true;
    });

    Timer(const Duration(milliseconds: 600), () {
      setState(() {
        isRolling = false;
        diceValue = Random().nextInt(6) + 1;

        int currentPos = playerPositions[currentTurn];

        // منطق حركة اللودو الصحيح
        if (currentPos == 0) {
          if (diceValue == 6) {
            playerPositions[currentTurn] = 1; // الخروج من القاعدة عند رمي 6
            gameStatus = '🚀 نجح ${playerNames[currentTurn]} في إخراج قطعة للممر!';
          } else {
            gameStatus = '❌ تحتاج إلى رمي (6) للخروج من القاعدة!';
          }
        } else {
          int newPos = currentPos + diceValue;
          if (newPos <= 52) {
            playerPositions[currentTurn] = newPos;
            gameStatus = '⚡ تقدم اللاعب ${playerNames[currentTurn]} إلى الخانة $newPos';
          } else {
            gameStatus = '⚠️ تجاوزت خط النهاية، انتظر الرقم المناسب!';
          }
        }

        // تبديل الدور إذا لم يكن الرقم 6 (حسب قوانين اللودو)
        if (diceValue != 6) {
          do {
            currentTurn = (currentTurn + 1) % 4;
          } while (widget.isVsAI && (currentTurn == 2 || currentTurn == 3));
        } else {
          gameStatus += ' (حصلت على رمية إضافية لوجود رقم 6!)';
        }

        if (!gameStatus.contains('تحتاج')) {
          chatLogs.add('${playerNames[currentTurn]} رمى نرد: $diceValue');
          if (chatLogs.length > 3) chatLogs.removeAt(0);
        }

        if (widget.isVsAI && currentTurn == 1) {
          _triggerAITurn();
        }
      });
    });
  }

  void _triggerAITurn() {
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      rollDice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1A1225),
      body: SafeArea(
        child: Column(
          children: [
            // شريط الإرشاد العلوي
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xff2A1B3D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xff00E5FF).withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xff00E5FF).withOpacity(0.2),
                      border: Border.all(color: const Color(0xff00E5FF)),
                    ),
                    child: const Icon(Icons.smart_toy, color: Color(0xff00E5FF), size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'نظام الممرات السيبرانية مفعل. ارمِ النرد بتركيز وتتبع خطوات قطعك!',
                      style: TextStyle(color: Colors.white, fontSize: 11, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),

            // شريط المشاهدين والإعدادات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xff2A1B3D), borderRadius: BorderRadius.circular(12)),
                    child: const Row(
                      children: [
                        Icon(Icons.visibility, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text('1 مشاهد نشط', style: TextStyle(color: Colors.white, fontSize: 10)),
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                      SizedBox(width: 12),
                      Icon(Icons.settings, color: Colors.white, size: 20),
                    ],
                  ),
                ],
              ),
            ),

            // رقعة اللودو السيبرانية الاحترافية مع الممرات التفصيلية
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xff3E2723),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 15)],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff0A0E0D),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  _buildBaseWithPathway(Colors.green, playerPositions[0]), // أخضر
                                  _buildDetailedCenterLane(),
                                  _buildBaseWithPathway(Colors.amber, playerPositions[1]), // أصفر
                                ],
                              ),
                            ),
                            Container(
                              height: 35,
                              color: const Color(0xff121816),
                              child: Center(
                                child: Text(gameStatus, style: const TextStyle(color: Color(0xff00E676), fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  _buildBaseWithPathway(Colors.red, playerPositions[2]), // أحمر
                                  _buildDetailedCenterLane(),
                                  _buildBaseWithPathway(Colors.blue, playerPositions[3]), // أزرق
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // شريط التحكم السفلي والدردشة التفاعلية
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xff2A1B3D),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Guest_5090476...', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.mic, color: Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(16)),
                            child: const Icon(Icons.emoji_emotions, color: Colors.black, size: 16),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(16)),
                            child: const Icon(Icons.chat_bubble, color: Colors.black, size: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: playerColors[currentTurn],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 6,
                      ),
                      onPressed: (!isRolling && (currentTurn == 0 || !widget.isVsAI)) ? rollDice : null,
                      child: Text(isRolling ? 'جاري الرَمي...' : '🎲 ارمِ النرد وتقدم ($diceValue)', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بناء القاعدة مع الممرات السيبرانية المدمجة
  Widget _buildBaseWithPathway(Color color, int position) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.6), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(4, (index) => Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: position > 0 ? Colors.grey[800] : color,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              )),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)),
              child: Text('الخانة: $position', style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // بناء الممرات والمسارات الوسطى بدقة
  Widget _buildDetailedCenterLane() {
    return Container(
      width: 30,
      color: const Color(0xff121816),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) => Container(
          margin: const EdgeInsets.all(1),
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xff00E5FF).withOpacity(0.4),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xff00E5FF).withOpacity(0.8)),
          ),
        )),
      ),
    );
  }
}
