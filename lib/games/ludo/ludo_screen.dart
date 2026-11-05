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
          appBar: AppBar(
            title: const Text('بطولة لودو السيبرانية (Ludo Arena)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            backgroundColor: const Color(0xff0A0E0D),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff0A0E0D), Color(0xff121816), Color(0xff0A0E0D)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xff121816),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _controller.currentTurnPlayer.uiColor, width: 2),
                  ),
                  child: Text(
                    _controller.gameMessage,
                    style: TextStyle(color: _controller.currentTurnPlayer.uiColor, fontWeight: FontWeight.bold, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        color: const Color(0xff060908),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xff00E5FF), width: 2),
                        boxShadow: [BoxShadow(color: const Color(0xff00E5FF).withOpacity(0.3), blurRadius: 15, spreadRadius: 2)],
                      ),
                      child: Stack(
                        children: [
                          ..._controller.players.asMap().entries.map((entry) {
                            int pIndex = entry.key;
                            var player = entry.value;
                            Alignment alignment;
                            if (pIndex == 0) alignment = Alignment.topLeft;
                            else if (pIndex == 1) alignment = Alignment.topRight;
                            else if (pIndex == 2) alignment = Alignment.bottomRight;
                            else alignment = Alignment.bottomLeft;

                            return Align(
                              alignment: alignment,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: player.uiColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: player.uiColor),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(player.color.name.toUpperCase(), style: TextStyle(color: player.uiColor, fontSize: 10, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: player.tokenPositions.asMap().entries.map((tEntry) {
                                        int tIndex = tEntry.key;
                                        int tPos = tEntry.value;
                                        bool isHome = tPos == 57;
                                        return GestureDetector(
                                          onTap: () => _controller.moveToken(pIndex, tIndex),
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 2),
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isHome ? Colors.amber : (tPos == -1 ? Colors.grey[800] : player.uiColor),
                                              border: Border.all(color: Colors.white, width: 1),
                                            ),
                                            child: Center(
                                              child: Text(tPos == -1 ? 'B' : '$tPos', style: const TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.bold)),
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
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xff121816),
                                border: Border.all(color: Colors.amber, width: 2),
                              ),
                              child: Text(
                                _controller.diceValue == 0 ? '🎲' : '${_controller.diceValue}',
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  color: const Color(0xff080C0B),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _controller.hasRolled ? Colors.grey : const Color(0xff00E676),
                          foregroundColor: Colors.black,
                          minimumSize: const Size(200, 52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _controller.hasRolled || _controller.isGameOver ? null : () => _controller.rollDice(),
                        child: Text(
                          _controller.hasRolled ? 'اختر قطعة للتحريك' : 'رمي النرد (ROLL DICE)',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                        ),
                      ),
                      if (_controller.isGameOver) ...[
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                          onPressed: () => _controller.resetGame(),
                          child: const Text('إعادة اللعبة', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ]
                    ],
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
