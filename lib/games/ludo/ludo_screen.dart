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
                child: Text('اختر وضع اللعبة وادخل ساحة المعركة السيبرانية', style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center),
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

// ================= شاشة اللعبة المطابقة تماماً للشكل الاحترافي =================
class LudoGameScreen extends StatefulWidget {
  final bool isVsAI;
  const LudoGameScreen({super.key, required this.isVsAI});

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> {
  int diceValue = 6;
  bool isRolling = false;

  // مواضع القطع والتقدم للأرباع الأربعة (أخضر، أصفر، أحمر، أزرق)
  List<int> playerSteps = [0, 0, 0, 0];
  int currentTurn = 0; // 0: أخضر, 1: أصفر, 2: أحمر, 3: أزرق
  String gameStatus = 'دور اللاعب الأخضر (رائد)';
  
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

        playerSteps[currentTurn] += diceValue;
        if (playerSteps[currentTurn] >= 40) {
          playerSteps[currentTurn] = 40;
          gameStatus = '🏆 فاز اللاعب ${playerNames[currentTurn]} بالمعركة السيبرانية!';
        } else {
          do {
            currentTurn = (currentTurn + 1) % 4;
          } while (widget.isVsAI && (currentTurn == 2 || currentTurn == 3));

          gameStatus = 'دور اللاعب: ${playerNames[currentTurn]}';
          if (widget.isVsAI && currentTurn == 1) {
            _triggerAITurn();
          }
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
      backgroundColor: const Color(0xff1A1225), // خلفية بنفسجية داكنة مشابهة للصورة
      body: SafeArea(
        child: Column(
          children: [
            // شريط الإرشاد العلوي والشخصية التفاعلية
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
                  // أيقونة أو شخصية افتراضية في الزاوية
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xff00E5FF).withOpacity(0.2),
                      border: Border.all(color: const Color(0xff00E5FF)),
                    ),
                    child: const Icon(Icons.smart_toy, color: Color(0xff00E5FF), size: 24),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'تشتغل الميكروفون لديك الآن ، حاول إجراء الدردشة الصوتية مع الآخرين ، استمع به !',
                      style: TextStyle(color: Colors.white, fontSize: 11, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),

            // شريط الرأس (مشاهدين، كأس الترتيب، والإعدادات)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xff2A1B3D), borderRadius: BorderRadius.circular(12)),
                        child: const Row(
                          children: [
                            Icon(Icons.visibility, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text('0 مشاهد', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.amber, size: 22),
                      const SizedBox(width: 12),
                      const Icon(Icons.settings, color: Colors.white, size: 22),
                    ],
                  ),
                ],
              ),
            ),

            // رقعة اللودو المربعة السيبرانية (مطابقة تماماً للصورة بأرباعها الأربعة)
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xff3E2723), // إطار خشبي/سيبراني للرقعة
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 15, spreadRadius: 2)],
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
                                  _buildQuadrant(Colors.green, playerSteps[0]), // أخضر
                                  _buildCenterColumn(),
                                  _buildQuadrant(Colors.amber, playerSteps[1]), // أصفر
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
                                  _buildQuadrant(Colors.red, playerSteps[2]), // أحمر
                                  _buildCenterColumn(),
                                  _buildQuadrant(Colors.blue, playerSteps[3]), // أزرق
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

            // شريط معلومات المستخدم والتحكم السفلي (مطابق للصورة)
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
                          IconButton(
                            icon: const Icon(Icons.mic, color: Colors.grey, size: 20),
                            onPressed: () {},
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(16)),
                            child: const Icon(Icons.emoji_emotions, color: Colors.black, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(16)),
                            child: const Icon(Icons.chat_bubble, color: Colors.black, size: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // زر رمي النرد الرئيسي
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
                      child: Text(isRolling ? 'جاري الرَمي...' : '🎲 ارمِ النرد ($diceValue)', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
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

  Widget _buildQuadrant(Color color, int progress) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: Stack(
          children: [
            Center(
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(4, (index) => Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 4)],
                  ),
                  child: Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                    ),
                  ),
                )),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                child: Text('$progress', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterColumn() {
    return Container(
      width: 35,
      color: Colors.white10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) => Container(
          margin: const EdgeInsets.all(1),
          height: 10,
          decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
        )),
      ),
    );
  }
}
