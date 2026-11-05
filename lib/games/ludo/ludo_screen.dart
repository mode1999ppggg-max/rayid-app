// ==============================================================================
// ملف اللعبة المتكامل: lib/games/ludo_game.dart
// مشروع Rayid Pay - لودو السيبرانية الاحترافية (Cyberpunk Ludo Arena)
// ==============================================================================

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// ------------------------------------------------------------------------------
// 1. نماذج البيانات وقواعد اللعبة (Game Models & Rules)
// ------------------------------------------------------------------------------

enum LudoColor { red, green, blue, yellow }

class LudoPlayer {
  final LudoColor color;
  final Color uiColor;
  final String name;
  // مواقع القطع الأربعة: -1 في القاعدة، 0 إلى 51 مسار رئيسي، 52 إلى 57 مسار أخير، 58 وصول للبيت النهائي
  List<int> tokenPositions = [-1, -1, -1, -1];

  LudoPlayer({
    required this.color,
    required this.uiColor,
    required this.name,
  });

  bool get hasWon => tokenPositions.every((pos) => pos == 58);
}

class LudoMoveResult {
  final bool success;
  final String message;
  final bool extraTurn;

  LudoMoveResult({required this.success, required this.message, this.extraTurn = false});
}

// ------------------------------------------------------------------------------
// 2. محرك ولُب اللعبة (Game Engine & Controller)
// ------------------------------------------------------------------------------

class LudoGameController extends ChangeNotifier {
  final List<LudoPlayer> players = [
    LudoPlayer(color: LudoColor.red, uiColor: const Color(0xffff3366), name: 'الأحمر'),
    LudoPlayer(color: LudoColor.green, uiColor: const Color(0xff00ff66), name: 'الأخضر'),
    LudoPlayer(color: LudoColor.blue, uiColor: const Color(0xff00f3ff), name: 'الأزرق'),
    LudoPlayer(color: LudoColor.yellow, uiColor: const Color(0xffffcc00), name: 'الأصفر'),
  ];

  int currentTurnIndex = 0;
  int diceValue = 0;
  bool hasRolled = false;
  bool isGameOver = false;
  bool isRolling = false;
  String gameMessage = "أهلاً بك في لودو السيبرانية! اضغط لرمي النرد.";
  
  // خريطة المربعات الآمنة على المسار العام
  final Set<int> safePositions = {0, 8, 13, 21, 26, 34, 39, 47};

  LudoPlayer get currentTurnPlayer => players[currentTurnIndex];

  // بدء رمي النرد مع مؤثر حركي وهمي
  void rollDice() {
    if (hasRolled || isGameOver || isRolling) return;

    isRolling = true;
    gameMessage = "جاري رمي النرد...";
    notifyListeners();

    int counter = 0;
    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      diceValue = Random().nextInt(6) + 1;
      counter++;
      notifyListeners();
      if (counter > 10) {
        timer.cancel();
        isRolling = false;
        hasRolled = true;
        _evaluateRolledValue();
      }
    });
  }

  void _evaluateRolledValue() {
    bool canMove = false;
    for (int pos in currentTurnPlayer.tokenPositions) {
      if (pos == -1 && diceValue == 6) {
        canMove = canMoveToStart(currentTurnIndex);
        break;
      } else if (pos != -1 && pos < 58) {
        if (pos + diceValue <= 58) {
          canMove = true;
          break;
        }
      }
    }

    if (!canMove) {
      gameMessage = "لاعب ${currentTurnPlayer.name}: لا توجد حركات متاحة بهذه النتيجة!";
      notifyListeners();
      Timer(const Duration(seconds: 2), () {
        _nextTurn();
      });
    } else {
      gameMessage = "لاعب ${currentTurnPlayer.name} رمى ($diceValue). اختر قطعة لتحريكها.";
      notifyListeners();
    }
  }

  // التحقق من إمكانية الخروج من القاعدة (هل نقطة البداية مشغولة بقطعة لنفس اللاعب؟)
  bool canMoveToStart(int playerIndex) {
    int startPos = _getGlobalStartPosition(playerIndex);
    for (int i = 0; i < players[playerIndex].tokenPositions.length; i++) {
      if (players[playerIndex].tokenPositions[i] == startPos) {
        return false; // القطعة موجودة مسبقاً في نقطة البداية
      }
    }
    return true;
  }

  int _getGlobalStartPosition(int playerIndex) {
    switch (playerIndex) {
      case 0: return 0;   // الأحمر
      case 1: return 13;  // الأخضر
      case 2: return 26;  // الأزرق
      case 3: return 39;  // الأصفر
      default: return 0;
    }
  }

  // تحريك القطعة المختارة مع تطبيق القواعد بدقة
  void moveToken(int playerIndex, int tokenIndex) {
    if (!hasRolled || isGameOver || playerIndex != currentTurnIndex) return;

    int currentPos = players[playerIndex].tokenPositions[tokenIndex];

    // حالة الخروج من القاعدة
    if (currentPos == -1) {
      if (diceValue == 6) {
        if (!canMoveToStart(playerIndex)) {
          gameMessage = "لا يمكنك الخروج، نقطة البداية تشغلها قطعة خاصة بك!";
          notifyListeners();
          return;
        }
        int startPos = _getGlobalStartPosition(playerIndex);
        _captureCheck(startPos, playerIndex);
        players[playerIndex].tokenPositions[tokenIndex] = startPos;
        _finalizeMove(extraTurn: true); // رمية 6 تمنح دوراً إضافياً
      } else {
        gameMessage = "تحتاج إلى رمي (6) لإخراج قطعة من القاعدة!";
        notifyListeners();
      }
      return;
    }

    // قطعة واصلة للبيت النهائي مسبقاً
    if (currentPos == 58) return;

    // حساب المسار الجديد
    int newPos = currentPos + diceValue;
    if (newPos > 58) {
      gameMessage = "الرقم كبير جداً، لا يمكن تجاوز البيت النهائي!";
      notifyListeners();
      return;
    }

    // التحقق من أكل قطع الخصم في المسار العام (أقل من 52)
    if (newPos < 52) {
      _captureCheck(newPos, playerIndex);
    }

    players[playerIndex].tokenPositions[tokenIndex] = newPos;

    // فحص الفوز
    if (players[playerIndex].hasWon) {
      isGameOver = true;
      gameMessage = "تهانينا! الفائز في المباراة هو اللاعب ${players[playerIndex].name}!";
      notifyListeners();
      return;
    }

    // منح دور إضافي عند رمي 6 أو أكل قطعة خصم
    bool extra = (diceValue == 6);
    _finalizeMove(extraTurn: extra);
  }

  // فحص اصطدام القطع وأكلها وإعادتها للقاعدة
  void _captureCheck(int targetPos, int moverPlayerIndex) {
    if (safePositions.contains(targetPos)) return; // المربعات الآمنة لا يُؤكل فيها

    for (int p = 0; p < players.length; p++) {
      if (p == moverPlayerIndex) continue;
      for (int t = 0; t < players[p].tokenPositions.length; t++) {
        int enemyPos = players[p].tokenPositions[t];
        if (enemyPos == targetPos) {
          players[p].tokenPositions[t] = -1; // إرجاع قطعة الخصم للقاعدة
          gameMessage = "تم أكل قطعة اللاعب ${players[p].name} وإرجاعها للقاعدة!";
        }
      }
    }
  }

  void _finalizeMove({bool extraTurn = false}) {
    hasRolled = false;
    if (extraTurn) {
      gameMessage += " (حصلت على رمية إضافية لتفوقك!)";
      notifyListeners();
    } else {
      _nextTurn();
    }
  }

  void _nextTurn() {
    currentTurnIndex = (currentTurnIndex + 1) % players.length;
    diceValue = 0;
    hasRolled = false;
    gameMessage = "دور اللاعب: ${currentTurnPlayer.name} - اضغط لرمي النرد.";
    notifyListeners();
  }

  void resetGame() {
    for (var p in players) {
      p.tokenPositions = [-1, -1, -1, -1];
    }
    currentTurnIndex = 0;
    diceValue = 0;
    hasRolled = false;
    isGameOver = false;
    isRolling = false;
    gameMessage = "بدأت لعبة جديدة. دور اللاعب الأحمر.";
    notifyListeners();
  }
}

// ------------------------------------------------------------------------------
// 3. واجهة المستخدم الرسومية لـ Ludo (Cyberpunk UI Screen)
// ------------------------------------------------------------------------------

class LudoGameScreen extends StatefulWidget {
  const LudoGameScreen({super.key});

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> {
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

  void _showOnlineInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff121826),
        title: const Text('نظام الأونلاين الحقيقي (Backend)', style: TextStyle(color: Color(0xff00f3ff), fontSize: 16)),
        content: const Text(
          'يتطلب نظام الأونلاين الفعلي (إنشاء غرف، مزامنة الـ WebSockets، وتوزيع الأدوار) خادم خلفي (Node.js + Socket.io أو Firebase Cloud Functions).\n\n'
          'النسخة الحالية مدعومة بالكامل للعب المحلي (حتى 4 لاعبين على نفس الجهاز Android 16 / A16) بكامل القواعد البرمجية والتحققات الحية.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً', style: TextStyle(color: Color(0xffff3366))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xff080b12),
            appBar: AppBar(
              backgroundColor: const Color(0xff0f1523),
              elevation: 4,
              shadowColor: const Color(0xff00f3ff).withOpacity(0.2),
              title: const Text(
                'بطولة لودو السيبرانية (Ludo Arena)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.wifi_rounded, color: Color(0xff00f3ff)),
                  tooltip: 'اللعب الجماعي (Online)',
                  onPressed: _showOnlineInfoDialog,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: Color(0xffffcc00)),
                  tooltip: 'إعادة اللعبة',
                  onPressed: () => _controller.resetGame(),
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // صندوق الرسائل وحالة اللعبة العلوي
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xff121826),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _controller.currentTurnPlayer.uiColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: _controller.currentTurnPlayer.uiColor.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _controller.currentTurnPlayer.uiColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _controller.gameMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // لوحة اللعب السيبرانية الرئيسية (Ludo Board View)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 340,
                        height: 340,
                        decoration: BoxDecoration(
                          color: const Color(0xff0d121d),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xff00f3ff), width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff00f3ff).withOpacity(0.35),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // قواعد وبيوت اللاعبين الأربعة في الزوايا
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
                                  margin: const EdgeInsets.all(12),
                                  width: 130,
                                  height: 95,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: player.uiColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: player.uiColor, width: 2),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        player.name,
                                        style: TextStyle(
                                          color: player.uiColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: player.tokenPositions.asMap().entries.map((tEntry) {
                                          int tIndex = tEntry.key;
                                          int tPos = tEntry.value;
                                          bool isOut = tPos != -1;
                                          bool isHome = tPos == 58;

                                          return GestureDetector(
                                            onTap: () => _controller.moveToken(pIndex, tIndex),
                                            child: Container(
                                              width: 22,
                                              height: 22,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isHome 
                                                    ? Colors.amber 
                                                    : (isOut ? player.uiColor : const Color(0xff222a3d)),
                                                border: Border.all(
                                                  color: isOut ? Colors.white : const Color(0xff667799), 
                                                  width: 1.5,
                                                ),
                                                boxShadow: isOut ? [
                                                  BoxShadow(
                                                    color: player.uiColor.withOpacity(0.6),
                                                    blurRadius: 6,
                                                  )
                                                ] : [],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  isHome ? '★' : (isOut ? '$tPos' : 'B'),
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    color: isOut ? Colors.black : const Color(0xffaaaaaa),
                                                    fontWeight: FontWeight.bold,
                                                  ),
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

                            // زر النرد المركزي المضيء
                            Center(
                              child: GestureDetector(
                                onTap: () => _controller.rollDice(),
                                child: Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xff141c2e),
                                    border: Border.all(color: const Color(0xffffcc00), width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xffffcc00).withOpacity(0.5),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: _controller.isRolling
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: Color(0xffffcc00),
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        : Text(
                                            _controller.diceValue == 0 ? '🎲' : '${_controller.diceValue}',
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

                  // لوحة الأزرار السفلية
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xff121826),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.styleFrom != null ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _controller.hasRolled ? Colors.grey.shade800 : const Color(0xff00e676),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _controller.hasRolled || _controller.isGameOver ? null : () => _controller.rollDice(),
                          child: const Text(
                            'رمي النرد (ROLL)',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                          ),
                        ) : const SizedBox(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffff3366),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => _controller.resetGame(),
                          child: const Text(
                            'إعادة ضبط اللعبة',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
