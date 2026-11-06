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
        title: const Text('CYBERPUNK LUDO', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xff00E5FF), letterSpacing: 1.5)),
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
                child: Icon(Icons.casino, size: 72, color: Color(0xff00E676)),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text('CYBERPUNK LUDO', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2)),
              ),
              const SizedBox(height: 6),
              const Center(
                child: Text('تحدَ الخصوم واكسب نقاط في رايد باي', style: TextStyle(color: Colors.grey, fontSize: 13)),
              ),
              const SizedBox(height: 40),

              // زر لعب ضد البوت
              _buildLobbyButton(
                context,
                title: 'لعب ضد البوت (AI)',
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

              // زر لعب ثنائي مع صديق
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
              const SizedBox(height: 16),

              // زر القوانين والجوايز
              _buildLobbyButton(
                context,
                title: 'قوانين والجوايز',
                icon: Icons.card_giftcard,
                borderColor: Colors.amber,
                onTap: () {
                  _showRulesDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLobbyButton(BuildContext context, {required String title, required IconData icon, required Color borderColor, required VoidCallback onTap}) {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff121816),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: borderColor, width: 2),
      ),
      elevation: 6,
    ).let((style) => ElevatedButton(
      style: style,
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: borderColor, size: 22),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ],
      ),
    ));
  }

  void _showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff121816),
        title: const Text('قوانين وجوائز لودو السيبرانية', style: TextStyle(color: Color(0xff00E676), fontWeight: FontWeight.bold)),
        content: const Text(
          '1. ارمِ النرد وحرك قطعك عبر مسار النيون السيبراني.\n'
          '2. كل خطوة صحيحة تمنحك نقاط تفاعلية مضافة لمحفظتك.\n'
          '3. الفائز يحصل على مكافأة كبرى تضاف لرصيد نقاط الترفيه في رايد باي.',
          style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00E676), foregroundColor: Colors.black),
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

extension on ButtonStyle {
  Widget let(Widget Function(ButtonStyle) child) => child(this);
}

// ================= شاشة اللعبة التفاعلية (Ludo Game Board) =================
class LudoGameScreen extends StatefulWidget {
  final bool isVsAI;
  const LudoGameScreen({super.key, required this.isVsAI});

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> {
  int diceValue = 6;
  bool isRolling = false;
  int playerPos = 0; // موقع اللاعب (من 0 إلى 50)
  int aiPos = 0;     // موقع الخصم/البوت
  bool isPlayerTurn = true;
  String gameStatus = 'دور اللاعب الأخضر (ارْمِ النرد!)';

  void rollDice() {
    if (isRolling) return;
    setState(() {
      isRolling = true;
    });

    Timer(const Duration(milliseconds: 600), () {
      setState(() {
        isRolling = false;
        diceValue = Random().nextInt(6) + 1;

        if (isPlayerTurn) {
          playerPos += diceValue;
          if (playerPos >= 50) {
            playerPos = 50;
            gameStatus = 'تهانينا! اللاعب الأخضر فاز بالمعركة السيبرانية!';
          } else {
            isPlayerTurn = false;
            gameStatus = widget.isVsAI ? 'دور البوت السيبراني...' : 'دور اللاعب الثاني...';
            if (widget.isVsAI) {
              _triggerAITurn();
            }
          }
        }
      });
    });
  }

  void _triggerAITurn() {
    Timer(const Duration(seconds: 1), () {
      setState(() {
        int aiRoll = Random().nextInt(6) + 1;
        diceValue = aiRoll;
        aiPos += aiRoll;
        if (aiPos >= 50) {
          aiPos = 50;
          gameStatus = 'فاز البوت السيبراني! حظاً أوفر في المرة القادمة.';
        } else {
          isPlayerTurn = true;
          gameStatus = 'دورك الآن يا رائد!';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0A0E0D),
      appBar: AppBar(
        title: Text(widget.isVsAI ? 'ساحة التحدي ضد الذكاء الاصطناعي' : 'ساحة التحدي الثنائي', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xff080C0B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // لوحة الحالة
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xff121816),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xff00E5FF).withOpacity(0.4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🟢 أخضر: $playerPos', style: const TextStyle(color: Color(0xff00E676), fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(gameStatus, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  Text('🔵 خصم: $aiPos', style: const TextStyle(color: Color(0xff00E5FF), fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // لوحة الرقعة السيبرانية المصغرة
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff050709),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xff00E676), width: 2),
                  boxShadow: [BoxShadow(color: const Color(0xff00E676).withOpacity(0.2), blurRadius: 15)],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.blur_on, color: Color(0xff00E5FF), size: 48),
                          const SizedBox(height: 10),
                          Text(
                            isRolling ? 'جاري رمي النرد...' : 'الرقم الظاهر: $diceValue',
                            style: const TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // منطقة النرد والتحكم
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00E676),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                ).let((style) => ElevatedButton(
                  style: style,
                  onPressed: (isPlayerTurn && !isRolling && playerPos < 50 && aiPos < 50) ? rollDice : null,
                  child: Text(isRolling ? '...' : '🎲 ارمِ النرد', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                )),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
