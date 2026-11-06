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
                child: Text('CYBERPUNK LUDO ARENA', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2)),
              ),
              const SizedBox(height: 6),
              const Center(
                child: Text('تحدَ الخصوم برقعة نيون سيبرانية واكسب نقاط في رايد باي', style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center),
              ),
              const SizedBox(height: 40),

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

              _buildLobbyButton(
                context,
                title: 'قوانين وجوائز اللعبة',
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
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  void _showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff121816),
        title: const Text('قوانين لودو السيبرانية', style: TextStyle(color: Color(0xff00E676), fontWeight: FontWeight.bold)),
        content: const Text(
          '1. رقعة نيون مستقبلية بأربعة أرباع سيبرانية (أخضر، أصفر، أحمر، أزرق).\n'
          '2. ارمِ النرد وتحرك عبر مسارات الطاقة.\n'
          '3. الفائز يربح نقاط ترفيهية مضاعفة تضاف فوراً لمحفظة رايد باي.',
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
  int playerPos = 0; 
  int aiPos = 0;     
  bool isPlayerTurn = true;
  String gameStatus = 'دور اللاعب الأخضر (ارْمِ النرد السيبراني)';

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
          if (playerPos >= 40) {
            playerPos = 40;
            gameStatus = 'فوز ساحق للسيبران الأخضر!';
          } else {
            isPlayerTurn = false;
            gameStatus = widget.isVsAI ? 'جاري تفكير البوت السيبراني...' : 'دور اللاعب الثاني (الأزرق)...';
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
        if (aiPos >= 40) {
          aiPos = 40;
          gameStatus = 'فاز البوت السيبراني بالمعركة!';
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.isVsAI ? 'VS AI CYBER ARENA' : 'DUAL CYBER ARENA', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff00E5FF))),
            const Text('رقم الغرفة: 236273', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        backgroundColor: const Color(0xff080C0B),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xff121816),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    const Text('الترتيب: 1', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xff0A0E0D), borderRadius: BorderRadius.circular(10)),
                  child: Text('🟢 أخضر: $playerPos | 🔵 خصم: $aiPos', style: const TextStyle(color: Color(0xff00E676), fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xff050709),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xff00E676), width: 3),
                    boxShadow: [
                      BoxShadow(color: const Color(0xff00E676).withOpacity(0.3), blurRadius: 20, spreadRadius: 2),
                      BoxShadow(color: const Color(0xff00E5FF).withOpacity(0.2), blurRadius: 10),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                _buildBaseQuadrant(Colors.greenAccent, 'أخضر', playerPos),
                                _buildCenterPathColumn(),
                                _buildBaseQuadrant(Colors.amber, 'أصفر', aiPos),
                              ],
                            ),
                          ),
                          Container(
                            height: 60,
                            color: const Color(0xff0A0E0D),
                            child: Center(
                              child: Text(
                                gameStatus,
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _buildBaseQuadrant(Colors.redAccent, 'أحمر', 0),
                                _buildCenterPathColumn(),
                                _buildBaseQuadrant(Colors.blueAccent, 'أزرق', 0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xff080C0B),
              border: Border(top: BorderSide(color: Color(0xff121816), width: 2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.mic_off, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.emoji_emotions, color: Color(0xff00E5FF)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble, color: Color(0xff00E676)),
                  onPressed: () {},
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00E676),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                  ),
                  onPressed: (isPlayerTurn && !isRolling && playerPos < 40 && aiPos < 40) ? rollDice : null,
                  child: Text(isRolling ? '...' : '🎲 ارمِ ($diceValue)', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaseQuadrant(Color color, String name, int progress) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.6), width: 1.5),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.casino, color: color, size: 28),
              const SizedBox(height: 4),
              Text(name, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('تقدم: $progress', style: const TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterPathColumn() {
    return Container(
      width: 45,
      color: const Color(0xff0A0E0D),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) => Container(
          margin: const EdgeInsets.all(2),
          height: 10,
          decoration: BoxDecoration(
            color: const Color(0xff00E5FF).withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        )),
      ),
    );
  }
}
