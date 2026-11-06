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
                child: Icon(Icons.security, size: 64, color: Color(0xff00E676)),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text('VS AI CYBER ARENA', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2)),
              ),
              const SizedBox(height: 6),
              const Center(
                child: Text('ساحة التحدي السيبرانية المتقدمة داخل رايد باي', style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center),
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
                title: 'لعب ثنائي محلي (مع صديق)',
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

// ================= شاشة اللعبة السيبرانية المتكاملة =================
class LudoGameScreen extends StatefulWidget {
  final bool isVsAI;
  const LudoGameScreen({super.key, required this.isVsAI});

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> {
  int diceValue = 6;
  bool isRolling = false;
  
  // خطوات اللاعبين الأربعة (أخضر، أصفر، أحمر، أزرق)
  List<int> steps = [0, 0, 0, 0];
  List<int> scores = [0, 0, 0, 0];
  
  int currentTurn = 0; // 0: أخضر, 1: أصفر, 2: أحمر, 3: أزرق
  String gameStatus = 'دور اللاعب: أخضر (رائد)';

  final List<String> playerNames = ['أخضر (رائد)', 'أصفر', 'أحمر', 'أزرق'];
  final List<Color> playerColors = [Colors.greenAccent, Colors.amber, Colors.redAccent, Colors.blueAccent];

  void rollDiceAndMove() {
    if (isRolling) return;
    setState(() {
      isRolling = true;
    });

    Timer(const Duration(milliseconds: 600), () {
      setState(() {
        isRolling = false;
        diceValue = Random().nextInt(6) + 1;

        // تحريك اللاعب الحالي
        steps[currentTurn] += diceValue;

        // فحص التأمين (إذا وصل 5 خطوات يحصل على نقطة ويتصفير)
        if (steps[currentTurn] >= 5) {
          steps[currentTurn] = 0;
          scores[currentTurn]++;
          gameStatus = '🎉 نجح اللاعب ${playerNames[currentTurn]} في تأمين منطقته وحصل على نقطة!';
        } else {
          // الانتقال للدور التالي بالتتابع
          do {
            currentTurn = (currentTurn + 1) % 4;
          } while (widget.isVsAI && (currentTurn == 2 || currentTurn == 3)); // إذا ضد البوت نلعب أخضر وأصفر فقط

          gameStatus = 'دور اللاعب: ${playerNames[currentTurn]}';
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
      rollDiceAndMove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0A0E0D),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('الغرفة: #88219', style: TextStyle(fontSize: 11, color: Colors.grey)),
            const Text('VS AI CYBER ARENA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff00E5FF))),
          ],
        ),
        backgroundColor: const Color(0xff080C0B),
        iconTheme: const IconThemeData(color: Color(0xff00E676)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // عداد النقاط العلوي للأربعة لاعبين
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xff121816),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xff00E676).withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildScoreBadge('أخضر', scores[0], Colors.greenAccent),
                  _buildScoreBadge('أصفر', scores[1], Colors.amber),
                  _buildScoreBadge('أحمر', scores[2], Colors.redAccent),
                  _buildScoreBadge('أزرق', scores[3], Colors.blueAccent),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // مؤشر الدور الحالي
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xff050709),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xff00E5FF), style: BorderStyle.dash),
              ),
              child: Text(
                gameStatus,
                style: const TextStyle(color: Color(0xff00E676), fontSize: 11, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),

            // ساحة اللعب السيبرانية (الأرباع الأربعة)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xff050709),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xff00E676), width: 2),
                  boxShadow: [BoxShadow(color: const Color(0xff00E676).withOpacity(0.2), blurRadius: 15)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // الصف العلوي (أصفر وأخضر)
                    Expanded(
                      child: Row(
                        children: [
                          _buildPlayerBox('أصفر', steps[1], Colors.amber, currentTurn == 1),
                          _buildVerticalConnector(),
                          _buildPlayerBox('أخضر (رائد)', steps[0], Colors.greenAccent, currentTurn == 0),
                        ],
                      ),
                    ),
                    // منطقة الأمان المركزية
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xff080C0B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.withOpacity(0.4)),
                      ),
                      child: const Text(
                        '⚡ منطقة الأمان السيبرانية (HOME) ⚡',
                        style: TextStyle(color: Colors.amberAccent, fontSize: 10, fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // الصف السفلي (أزرق وأحمر)
                    Expanded(
                      child: Row(
                        children: [
                          _buildPlayerBox('أزرق', steps[3], Colors.blueAccent, currentTurn == 3),
                          _buildVerticalConnector(),
                          _buildPlayerBox('أحمر', steps[2], Colors.redAccent, currentTurn == 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // شريط التحكم السفلي
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff00E676),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: (!isRolling && (currentTurn == 0 || !widget.isVsAI)) ? rollDiceAndMove : null,
                    child: Text(isRolling ? 'جاري الرَمي...' : '🎲 تأكيد الإجراء / رمي النرد ($diceValue)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff121816),
                    foregroundColor: const Color(0xffFF5252),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xffFF5252)),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      steps = [0, 0, 0, 0];
                      scores = [0, 0, 0, 0];
                      currentTurn = 0;
                      gameStatus = 'دور اللاعب: أخضر (رائد)';
                    });
                  },
                  child: const Text('إعادة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBadge(String name, int score, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xff0A0E0D),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color),
      ),
      child: Text('$name: $score', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPlayerBox(String name, int step, Color color, bool isActive) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xff121816),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isActive ? color : color.withOpacity(0.3), width: isActive ? 2.5 : 1),
          boxShadow: isActive ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10)] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🛡️', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 2),
            Text(name, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xff0A0E0D), borderRadius: BorderRadius.circular(6)),
              child: Text('الخطوة: $step', style: const TextStyle(color: Colors.white, fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalConnector() {
    return Container(
      width: 25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) => Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xff00E5FF).withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xff00E5FF).withOpacity(0.5)),
          ),
        )),
      ),
    );
  }
}
