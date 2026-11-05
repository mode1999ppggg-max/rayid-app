import 'package:flutter/material.dart';
import 'ludo_model.dart';

class LudoScreen extends StatefulWidget {
  const LudoScreen({super.key});

  @override
  State<LudoScreen> createState() => _LudoScreenState();
}

class _LudoScreenState extends State<LudoScreen> {
  late final LudoGameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LudoGameController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xff0b0f19),
          appBar: AppBar(
            title: const Text(
              'بطولة لودو السيبرانية (Ludo Arena)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // صندوق الحالة العلوي
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xff141926).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xffff3366), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffff3366).withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    _controller.gameMessage.isNotEmpty 
                        ? _controller.gameMessage 
                        : 'لاعب red رمى الرقم: ${_controller.diceValue == 0 ? 5 : _controller.diceValue}',
                    style: const TextStyle(
                      color: Color(0xffff6b8b),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // لوحة اللعب الرئيسية
                Expanded(
                  child: Center(
                    child: Container(
                      width: 340,
                      height: 340,
                      decoration: BoxDecoration(
                        color: const Color(0xff111622),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xff00f3ff), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff00f3ff).withOpacity(0.4),
                            blurRadius: 25,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // رسم البيوت الأربعة في الزوايا بتصميم مطابق للصورة
                          ..._controller.players.asMap().entries.map((entry) {
                            int pIndex = entry.key;
                            var player = entry.value;
                            Alignment alignment;
                            EdgeInsets margin;

                            if (pIndex == 0) {
                              alignment = Alignment.topLeft;
                              margin = const EdgeInsets.all(12);
                            } else if (pIndex == 1) {
                              alignment = Alignment.topRight;
                              margin = const EdgeInsets.all(12);
                            } else if (pIndex == 3) {
                              alignment = Alignment.bottomLeft;
                              margin = const EdgeInsets.all(12);
                            } else {
                              alignment = Alignment.bottomRight;
                              margin = const EdgeInsets.all(12);
                            }

                            return Align(
                              alignment: alignment,
                              child: Container(
                                margin: margin,
                                width: 130,
                                height: 95,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: player.uiColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: player.uiColor, width: 2),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      player.color.name.toUpperCase(),
                                      style: TextStyle(
                                        color: player.uiColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: player.tokenPositions.asMap().entries.map((tEntry) {
                                        int tIndex = tEntry.key;
                                        int tPos = tEntry.value;
                                        return GestureDetector(
                                          onTap: () => _controller.moveToken(pIndex, tIndex),
                                          child: Container(
                                            width: 22,
                                            height: 22,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xff2b3347),
                                              border: Border.all(color: const Color(0xff778899), width: 1),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'B',
                                                style: TextStyle(fontSize: 10, color: Color(0xffaaaaaa), fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                          // النرد المركزي الدائري المضيء
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                if (!_controller.hasRolled && !_controller.isGameOver) {
                                  _controller.rollDice();
                                }
                              },
                              child: Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xff192231),
                                  border: Border.all(color: const Color(0xffffcc00), width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xffffcc00).withOpacity(0.5),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    _controller.diceValue == 0 ? '5' : '${_controller.diceValue}',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xffffcc00),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // شريط التوجيه أو الأكشن السفلي
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xff141926).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Center(
                    child: Text(
                      _controller.isGameOver 
                          ? 'المباراة انتهت. تهانينا للفائز!' 
                          : (_controller.hasRolled ? 'اختر قطعة لتحريكها...' : 'اضغط على النرد للرمي'),
                      style: const TextStyle(
                        color: Color(0xffcccccc),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
