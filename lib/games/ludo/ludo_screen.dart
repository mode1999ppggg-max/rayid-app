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
        title: const Text('CYBERPUNK LUDO ARENA', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xff00E5FF), letterSpacing: 1.5)),
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
                child: Text('تحدَ الخصوم برقعة نيون متطورة واكسب نقاط ترفيهية في رايد باي', style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center),
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
              const SizedBox(height: 16),

              _buildLobbyButton(
                context,
                title: 'قوانين وجوائز المعركة',
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
          '1. رقعة نيون متكاملة تضم 4 مسارات طاقة رئيسية.\n'
          '2. ارمِ النرد وحرك قطعك السيبرانية بذكاء لتتجنب الخصم.\n'
          '3. الفائز يجمع أكبر عدد من نقاط الترفيه المحولة لمحفظة رايد باي.',
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

// ================= شاشة اللعبة المتكاملة والاحترافية =================
class LudoGameScreen extends StatefulWidget {
  final bool isVsAI;
  const LudoGameScreen({super.key, required this.isVsAI});

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> {
  int diceValue = 6;
  bool isRolling = false;
  
  // مواقع القطع السيبرانية الأربعة (0 يعني في القاعدة، من 1 إلى 56 مسار السباق، 57 خط النهاية)
  int greenPos = 0;
  int yellowPos = 0;
  int redPos = 0;
  int bluePos = 0;

  int currentTurn = 0; // 0: أخضر, 1: أصفر, 2: أحمر, 3: أزرق
  String gameStatus = 'دور اللاعب الأخضر (ارْمِ النرد!)';
  List<String> chatMessages = [];

  final List<String> playerNames = ['أخضر (رائد)', 'أصفر (البوت)', 'أحمر', 'أزرق'];
  final List<Color> playerColors = [Colors.greenAccent, Colors.amber, Colors.redAccent, Colors.blueAccent];

  void rollDice() {
    if (isRolling) return;
    setState(() {
      isRolling = true;
    });

    Timer(const Duration(milliseconds: 700), () {
      setState(() {
        isRolling = false;
        diceValue = Random().nextInt(6) + 1;

        // تحريك القطع حسب الدور الحالي
        if (currentTurn == 0) {
          greenPos = _movePiece(greenPos, diceValue);
        } else if (currentTurn == 1) {
          yellowPos = _movePiece(yellowPos, diceValue);
        } else if (currentTurn == 2) {
          redPos = _movePiece(redPos, diceValue);
        } else {
          bluePos = _movePiece(bluePos, diceValue);
        }

        // فحص الفوز
        if (greenPos >= 56) {
          gameStatus = '🎉 تهانينا! فاز اللاعب الأخضر بالمعركة!';
          return;
        } else if (yellowPos >= 56) {
          gameStatus = '🏆 فاز اللاعب الأصفر!';
          return;
        }

        // الانتقال للدور التالي
        do {
          currentTurn = (currentTurn + 1) % 4;
        } while (widget.isVsAI && (currentTurn == 2 || currentTurn == 3)); // إذا ضد البوت نلعب أخضر وأصفر فقط

        gameStatus = 'دور اللاعب: ${playerNames[currentTurn]}';

        if (widget.isVsAI && currentTurn == 1) {
          _triggerAITurn();
        }
      });
    });
  }

  int _movePiece(int current, int roll) {
    if (current == 0) {
      if (roll == 6) return 1; // الخروج من القاعدة برقم 6
      return 0;
    }
    int next = current + roll;
    if (next > 56) return 56; // النهاية
    return next;
  }

  void _triggerAITurn() {
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      rollDice();
    });
  }

  void _sendQuickChat(String msg) {
    setState(() {
      chatMessages.add(msg);
      if (chatMessages.length > 3) chatMessages.removeAt(0);
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
            Text(widget.isVsAI ? 'VS AI CYBER ARENA' : 'DUAL CYBER ARENA', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xff00E5FF))),
            const Text('الغرفة: #88219', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        backgroundColor: const Color(0xff080C0B),
      ),
      body: Column(
        children: [
          // لوحة معلومات اللاعبين العلوية الاحترافية
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xff121816),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPlayerBadge('أخضر', greenPos, Colors.greenAccent),
                _buildPlayerBadge('أصفر', yellowPos, Colors.amber),
                _buildPlayerBadge('أحمر', redPos, Colors.redAccent),
                _buildPlayerBadge('أزرق', bluePos, Colors.blueAccent),
              ],
            ),
          ),

          // شريط حالة اللعبة والدردشة السريعة العائمة
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            color: const Color(0xff050709),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(gameStatus, style: const TextStyle(color: Color(0xff00E676), fontSize: 11, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                ),
                if (chatMessages.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xff1A1025), borderRadius: BorderRadius.circular(8)),
                    child: Text(chatMessages.last, style: const TextStyle(color: Color(0xff00E5FF), fontSize: 10)),
                  ),
              ],
            ),
          ),

          // رقعة اللودو السيبرانية المتكاملة (Board)
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  margin: const EdgeInsets.all(10),
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
                      // تصميم الأرباع الأربعة للودو
                      Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                _buildBoardBase(Colors.greenAccent, 'أخضر', greenPos),
                                _buildCenterPathVertical(),
                                _buildBoardBase(Colors.amber, 'أصفر', yellowPos),
                              ],
                            ),
                          ),
                          _buildCenterHomeHub(),
                          Expanded(
                            child: Row(
                              children: [
                                _buildBoardBase(Colors.redAccent, 'أحمر', redPos),
                                _buildCenterPathVertical(),
                                _buildBoardBase(Colors.blueAccent, 'أزرق', bluePos),
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

          // شريط التحكم السفلي المتطور (النرد التفاعلي، المايك، الإيموجي، الدردشة)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xff080C0B),
              border: Border(top: BorderSide(color: Color(0xff121816), width: 2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.mic, color: Colors.grey, size: 20),
                      onPressed: () => _sendQuickChat('🎤 فتح المايك الصوتى'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions, color: Color(0xff00E5FF), size: 20),
                      onPressed: () => _sendQuickChat('🔥 حماس سيبراني!'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble, color: Color(0xff00E676), size: 20),
                      onPressed: () => _sendQuickChat('👋 سلام للجميع'),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: playerColors[currentTurn],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                  ),
                  onPressed: (!isRolling && (currentTurn == 0 || !widget.isVsAI)) ? rollDice : null,
                  child: Text(isRolling ? '🎲 ...' : '🎲 ارمِ ($diceValue)', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerBadge(String name, int pos, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          const SizedBox(width: 4),
          Text('$name: $pos', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBoardBase(Color color, String name, int position) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.7), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield, color: color, size: 24),
            const SizedBox(height: 4),
            Text(name, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xff0A0E0D), borderRadius: BorderRadius.circular(8)),
              child: Text('الخطوة: $position', style: const TextStyle(color: Colors.white, fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterPathVertical() {
    return Container(
      width: 40,
      color: const Color(0xff0A0E0D),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) => Container(
          margin: const EdgeInsets.all(2),
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xff00E5FF).withOpacity(0.3),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: const Color(0xff00E5FF).withOpacity(0.5)),
          ),
        )),
      ),
    );
  }

  Widget _buildCenterHomeHub() {
    return Container(
      height: 45,
      color: const Color(0xff080C0B),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.flash_on, color: Colors.amber, size: 16),
          const SizedBox(width: 6),
          const Text('منطقة الأمان السيبرانية (HOME)', style: TextStyle(color: Colors.amberAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ],
      ),
    );
  }
}
