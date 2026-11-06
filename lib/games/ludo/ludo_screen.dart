// lib/games/ludo/ludo_screen.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

// 1. نماذج البيانات (Models)
enum PlayerColor { green, yellow, red, blue }

class TokenModel {
  int id;
  PlayerColor color;
  int position; // -1: القاعدة، 0-51: المسار المشترك، 52-57: الممر النهائي، 58: الفوز
  bool isHome;

  TokenModel({
    required this.id,
    required this.color,
    this.position = -1,
    this.isHome = false,
  });
}

// 2. محرك قواعد اللعبة الهندسي (LudoEngine)
class LudoEngine {
  static const int totalPathCells = 52;
  static const int homeStretchStart = 52;
  static const int homeStretchEnd = 57;
  static const int targetWin = 58;

  static const Map<PlayerColor, int> startOffsets = {
    PlayerColor.green: 0,
    PlayerColor.yellow: 13,
    PlayerColor.red: 26,
    PlayerColor.blue: 39,
  };

  static const Set<int> safeAbsoluteSpots = {0, 8, 13, 21, 26, 34, 39, 47};

  static int getAbsolutePosition(int localPos, PlayerColor color) {
    if (localPos < 0 || localPos >= totalPathCells) return -1;
    return (localPos + startOffsets[color]!) % totalPathCells;
  }

  static int calculateNewPosition(int currentPos, int roll, PlayerColor color) {
    if (currentPos == -1) {
      return roll == 6 ? 0 : -1;
    }
    if (currentPos == targetWin) return targetWin;

    if (currentPos >= 0 && currentPos < totalPathCells) {
      int nextPos = currentPos + roll;
      if (currentPos < 51 && nextPos >= 51) {
        int excess = nextPos - 51;
        if (excess == 0) return homeStretchStart;
        if (excess > 0 && excess <= 6) {
          return homeStretchStart + excess - 1;
        }
        return currentPos;
      }
      return nextPos % totalPathCells;
    }

    if (currentPos >= homeStretchStart && currentPos <= 57) {
      int stretchIndex = currentPos - homeStretchStart;
      int newStretchIndex = stretchIndex + roll;
      if (newStretchIndex == 6) {
        return targetWin;
      } else if (newStretchIndex < 6) {
        return homeStretchStart + newStretchIndex;
      } else {
        return currentPos;
      }
    }

    return currentPos;
  }

  static List<int> getLegalMoves(List<TokenModel> playerTokens, int roll) {
    List<int> legalIndices = [];
    for (int i = 0; i < playerTokens.length; i++) {
      int pos = playerTokens[i].position;
      if (pos == -1) {
        if (roll == 6) legalIndices.add(i);
      } else if (pos >= 0 && pos < totalPathCells) {
        legalIndices.add(i);
      } else if (pos >= homeStretchStart && pos <= 57) {
        int stretchIndex = pos - homeStretchStart;
        if (stretchIndex + roll <= 6) legalIndices.add(i);
      }
    }
    return legalIndices;
  }

  static List<int> getStepByStepPath(int currentPos, int roll, PlayerColor color) {
    List<int> path = [];
    int tempPos = currentPos;

    if (tempPos == -1 && roll == 6) {
      path.add(0);
      return path;
    }

    for (int step = 0; step < roll; step++) {
      tempPos = calculateNewPosition(tempPos, 1, color);
      path.add(tempPos);
      if (tempPos == targetWin) break;
    }
    return path;
  }

  static bool processCaptures(PlayerColor activeColor, int movedTokenId, Map<PlayerColor, List<TokenModel>> allTokens) {
    TokenModel activeToken = allTokens[activeColor]![movedTokenId];
    int activePos = activeToken.position;
    if (activePos < 0 || activePos >= totalPathCells) return false;

    int activeAbsolute = getAbsolutePosition(activePos, activeColor);
    if (safeAbsoluteSpots.contains(activeAbsolute)) return false;

    bool capturedAny = false;
    allTokens.forEach((color, tokens) {
      if (color == activeColor) return;
      for (var token in tokens) {
        if (token.position >= 0 && token.position < totalPathCells) {
          int enemyAbsolute = getAbsolutePosition(token.position, color);
          if (activeAbsolute == enemyAbsolute) {
            token.position = -1; // إرجاع حجر الخصم للقاعدة
            capturedAny = true;
          }
        }
      }
    });
    return capturedAny;
  }
}

// 3. شاشة البهو (Lobby)
class LudoLobbyScreen extends StatelessWidget {
  const LudoLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0A0E0D),
      appBar: AppBar(
        title: const Text('RAYID CYBER ARENA', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xff00E5FF), letterSpacing: 1.5)),
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
              const Center(child: Icon(Icons.security_rounded, size: 72, color: Color(0xff00E676))),
              const SizedBox(height: 16),
              const Center(child: Text('RAYID CYBER LUDO', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2))),
              const SizedBox(height: 6),
              const Center(child: Text('النسخة النهائية المدمجة والمتكاملة', style: TextStyle(color: Colors.grey, fontSize: 13), textAlign: TextAlign.center)),
              const SizedBox(height: 48),
              _buildLobbyButton(
                context,
                title: 'لعب رباعي ضد الذكاء الاصطناعي (AI)',
                icon: Icons.smart_toy_rounded,
                borderColor: const Color(0xff00E5FF),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LudoGameScreen(isVsAI: true)));
                },
              ),
              const SizedBox(height: 16),
              _buildLobbyButton(
                context,
                title: 'لعب رباعي محلي (مع أصدقاء)',
                icon: Icons.people_alt_rounded,
                borderColor: const Color(0xff00E676),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LudoGameScreen(isVsAI: false)));
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
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: borderColor, width: 2)),
        elevation: 8,
        shadowColor: borderColor.withOpacity(0.4),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: borderColor, size: 24),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

// 4. شاشة اللعب الرئيسية (Game Screen)
class LudoGameScreen extends StatefulWidget {
  final bool isVsAI;
  const LudoGameScreen({super.key, required this.isVsAI});

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> with TickerProviderStateMixin {
  int diceValue = 6;
  bool isRolling = false;
  bool hasRolled = false;
  bool isAnimatingMove = false;
  bool isGameOver = false;
  bool showTutorialCard = true;
  bool isMicActive = false;
  Timer? _activeTimer;

  List<PlayerColor> turnOrder = [
    PlayerColor.green,
    PlayerColor.yellow,
    PlayerColor.red,
    PlayerColor.blue,
  ];
  int currentTurnIndex = 0;
  PlayerColor get currentTurnColor => turnOrder[currentTurnIndex];

  Map<PlayerColor, List<TokenModel>> allTokens = {
    PlayerColor.green: List.generate(4, (i) => TokenModel(id: i, color: PlayerColor.green)),
    PlayerColor.yellow: List.generate(4, (i) => TokenModel(id: i, color: PlayerColor.yellow)),
    PlayerColor.red: List.generate(4, (i) => TokenModel(id: i, color: PlayerColor.red)),
    PlayerColor.blue: List.generate(4, (i) => TokenModel(id: i, color: PlayerColor.blue)),
  };

  String gameStatus = 'دور اللاعب: أخضر (رائد) - ارمِ النرد!';

  final Map<PlayerColor, String> playerNames = {
    PlayerColor.green: 'أخضر',
    PlayerColor.yellow: 'أصفر',
    PlayerColor.red: 'أحمر',
    PlayerColor.blue: 'أزرق',
  };

  final Map<PlayerColor, Color> playerColors = {
    PlayerColor.green: Colors.greenAccent,
    PlayerColor.yellow: Colors.amberAccent,
    PlayerColor.red: Colors.redAccent,
    PlayerColor.blue: Colors.blueAccent,
  };

  final List<Offset> boardPathCoordinates = _generateStrict52Path();

  late AnimationController _diceAnimController;
  late Animation<double> _diceScaleAnim;

  @override
  void initState() {
    super.initState();
    _diceAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _diceScaleAnim = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _diceAnimController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _activeTimer?.cancel();
    _diceAnimController.dispose();
    super.dispose();
  }

  static List<Offset> _generateStrict52Path() {
    List<Offset> path = [];
    for (int y = 13; y >= 9; y--) path.add(Offset(6.0, y.toDouble()));
    for (int x = 5; x >= 0; x--) path.add(Offset(x.toDouble(), 8.0));
    path.add(const Offset(0.0, 7.0));
    path.add(const Offset(0.0, 6.0));
    for (int x = 1; x <= 6; x++) path.add(Offset(x.toDouble(), 6.0));
    for (int y = 5; y >= 0; y--) path.add(Offset(6.0, y.toDouble()));
    path.add(const Offset(7.0, 0.0));
    path.add(const Offset(8.0, 0.0));
    for (int y = 1; y <= 5; y++) path.add(Offset(8.0, y.toDouble()));
    for (int x = 9; x <= 14; x++) path.add(Offset(x.toDouble(), 6.0));
    path.add(const Offset(14.0, 7.0));
    path.add(const Offset(14.0, 8.0));
    for (int x = 13; x >= 8; x--) path.add(Offset(x.toDouble(), 8.0));
    for (int y = 9; y <= 14; y++) path.add(Offset(8.0, y.toDouble()));
    path.add(const Offset(7.0, 14.0));
    path.add(const Offset(6.0, 14.0));

    assert(path.length == 52);
    return path;
  }

  void resetGame() {
    _activeTimer?.cancel();
    setState(() {
      allTokens = {
        PlayerColor.green: List.generate(4, (i) => TokenModel(id: i, color: PlayerColor.green)),
        PlayerColor.yellow: List.generate(4, (i) => TokenModel(id: i, color: PlayerColor.yellow)),
        PlayerColor.red: List.generate(4, (i) => TokenModel(id: i, color: PlayerColor.red)),
        PlayerColor.blue: List.generate(4, (i) => TokenModel(id: i, color: PlayerColor.blue)),
      };
      currentTurnIndex = 0;
      hasRolled = false;
      isAnimatingMove = false;
      isGameOver = false;
      gameStatus = 'دور اللاعب: أخضر (رائد) - ارمِ النرد!';
    });
  }

  void rollDice() {
    if (isRolling || hasRolled || isAnimatingMove || isGameOver) return;
    setState(() {
      isRolling = true;
    });

    _diceAnimController.forward().then((_) => _diceAnimController.reverse());

    _activeTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        isRolling = false;
        diceValue = Random().nextInt(6) + 1;
        hasRolled = true;

        List<int> legalMoves = LudoEngine.getLegalMoves(allTokens[currentTurnColor]!, diceValue);

        if (legalMoves.isEmpty) {
          gameStatus = 'لا توجد حركات مُمكِنة للرقم $diceValue! ينتقل الدور.';
          _activeTimer = Timer(const Duration(milliseconds: 1200), () {
            if (mounted && !isGameOver) _nextTurn();
          });
        } else {
          gameStatus = 'تم رمي ($diceValue). اضغط على الحجر المناسب للتحريك!';
          if (widget.isVsAI && currentTurnColor != PlayerColor.green) {
            _executeAIMove(legalMoves);
          }
        }
      });
    });
  }

  void selectToken(PlayerColor color, int tokenId) {
    if (!hasRolled || color != currentTurnColor || isAnimatingMove || isGameOver) return;

    List<int> legalMoves = LudoEngine.getLegalMoves(allTokens[color]!, diceValue);
    if (!legalMoves.contains(tokenId)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('هذه الحركة غير قانونية!'), duration: Duration(milliseconds: 700)));
      return;
    }

    List<int> stepPath = LudoEngine.getStepByStepPath(allTokens[color]![tokenId].position, diceValue, color);
    _executeStepAnimation(color, tokenId, stepPath, 0, diceValue);
  }

  void _executeStepAnimation(PlayerColor color, int tokenId, List<int> steps, int stepIndex, int totalRoll) {
    if (stepIndex >= steps.length) {
      setState(() {
        isAnimatingMove = false;
        hasRolled = false;

        LudoEngine.processCaptures(color, tokenId, allTokens);

        bool allWon = allTokens[color]!.every((t) => t.position == LudoEngine.targetWin);
        if (allWon) {
          isGameOver = true;
          gameStatus = '🏆 فاز اللاعب ${playerNames[color]} بالمعركة السيبرانية!';
          _showWinDialog(playerNames[color]!);
          return;
        }

        if (totalRoll == 6) {
          gameStatus = 'رقم 6 مميز! حصلت على رمية إضافية.';
          if (widget.isVsAI && currentTurnColor != PlayerColor.green) {
            _activeTimer = Timer(const Duration(milliseconds: 900), () {
              if (mounted && !isGameOver) rollDice();
            });
          }
        } else {
          _nextTurn();
        }
      });
      return;
    }

    setState(() {
      isAnimatingMove = true;
      allTokens[color]![tokenId].position = steps[stepIndex];
    });

    _activeTimer = Timer(const Duration(milliseconds: 180), () {
      if (mounted) {
        _executeStepAnimation(color, tokenId, steps, stepIndex + 1, totalRoll);
      }
    });
  }

  void _nextTurn() {
    if (isGameOver) return;
    setState(() {
      currentTurnIndex = (currentTurnIndex + 1) % turnOrder.length;
      gameStatus = 'دور اللاعب: ${playerNames[currentTurnColor]} - ارمِ النرد.';
      hasRolled = false;
    });

    if (widget.isVsAI && currentTurnColor != PlayerColor.green) {
      _activeTimer = Timer(const Duration(milliseconds: 800), () {
        if (mounted && !isGameOver) rollDice();
      });
    }
  }

  void _executeAIMove(List<int> legalMoves) {
    _activeTimer?.cancel();
    _activeTimer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted || isGameOver) return;

      PlayerColor aiColor = currentTurnColor;
      int chosenMove = legalMoves.first;

      for (int idx in legalMoves) {
        int pos = allTokens[aiColor]![idx].position;
        int finalPos = LudoEngine.calculateNewPosition(pos, diceValue, aiColor);
        if (finalPos == LudoEngine.targetWin) {
          chosenMove = idx;
          break;
        }
      }

      if (chosenMove == legalMoves.first) {
        for (int idx in legalMoves) {
          int pos = allTokens[aiColor]![idx].position;
          if (pos >= 0 && pos < LudoEngine.totalPathCells) {
            int targetAbs = LudoEngine.getAbsolutePosition(LudoEngine.calculateNewPosition(pos, diceValue, aiColor), aiColor);
            bool willCapture = false;
            allTokens.forEach((c, tokens) {
              if (c == aiColor) return;
              for (var t in tokens) {
                if (t.position >= 0 && t.position < LudoEngine.totalPathCells) {
                  if (LudoEngine.getAbsolutePosition(t.position, c) == targetAbs) {
                    willCapture = true;
                  }
                }
              }
            });
            if (willCapture) {
              chosenMove = idx;
              break;
            }
          }
        }
      }

      if (diceValue == 6 && chosenMove == legalMoves.first) {
        for (int idx in legalMoves) {
          if (allTokens[aiColor]![idx].position == -1) {
            chosenMove = idx;
            break;
          }
        }
      }

      selectToken(aiColor, chosenMove);
    });
  }

  void _showWinDialog(String winnerName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff121816),
        title: Text('🏆 انتصار سيبراني', style: TextStyle(color: playerColors[currentTurnColor], fontWeight: FontWeight.bold)),
        content: Text('الفائز في الساحة الرباعية هو: $winnerName!', style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('القائمة الرئيسية', style: TextStyle(color: Color(0xff00E5FF))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text('إعادة اللعب', style: TextStyle(color: Color(0xff00E676))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0A0E0D),
      body: SafeArea(
        child: Column(
          children: [
            // Top HUD Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xff080C0B),
                border: Border(bottom: BorderSide(color: Color(0xff00E5FF), width: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.settings, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xff121816),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.amber, width: 1),
                        ),
                        child: const Icon(Icons.emoji_events, color: Colors.amber, size: 14),
                      ),
                    ],
                  ),
                  const Text('RAYID CYBER ARENA', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xff00E5FF), letterSpacing: 1.2)),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xff121816),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xff00E5FF).withOpacity(0.4)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.visibility, color: Colors.grey, size: 12),
                            SizedBox(width: 4),
                            Text('0 مشاهد', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Color(0xff00E676), size: 20),
                        onPressed: resetGame,
                        tooltip: 'إعادة تعيين',
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tutorial Banner
            if (showTutorialCard)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xff1A2624), Color(0xff0E1412)]),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xff00E676), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: const Color(0xff00E676).withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.mic, color: Color(0xff00E676), size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'تشتغل الميكروفون لديك الآن، حاول إجراء الدردشة الصوتية مع الآخرين ، استمتع به !',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => showTutorialCard = false),
                      child: const Text('تخطي الإرشاد', style: TextStyle(color: Color(0xff00E5FF), fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

            // Status Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xff121816),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xff00E5FF).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: Color(0xff00E676), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      gameStatus,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Game Board
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xff050709),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xff00E676), width: 2),
                      boxShadow: [BoxShadow(color: const Color(0xff00E676).withOpacity(0.2), blurRadius: 15)],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double size = constraints.maxWidth;
                        return Stack(
                          children: [
                            CustomPaint(
                              size: Size(size, size),
                              painter: CyberBoardPainter(boardPathCoordinates),
                            ),
                            ..._buildAllTokens(size),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Bottom HUD Controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xff080C0B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(top: BorderSide(color: Color(0xff00E5FF), width: 1)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: playerColors[currentTurnColor]!.withOpacity(0.2),
                                  border: Border.all(color: playerColors[currentTurnColor]!, width: 2),
                                ),
                                child: Icon(Icons.person, color: playerColors[currentTurnColor], size: 20),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                                  child: const Icon(Icons.star, size: 8, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('دور: ${playerNames[currentTurnColor]}', style: TextStyle(color: playerColors[currentTurnColor], fontSize: 11, fontWeight: FontWeight.bold)),
                              const Text('الترتيب: 1 | 👑 VIP', style: TextStyle(color: Colors.amber, fontSize: 9)),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(isMicActive ? Icons.mic : Icons.mic_off, color: isMicActive ? const Color(0xff00E676) : Colors.grey, size: 22),
                            onPressed: () {
                              setState(() {
                                isMicActive = !isMicActive;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(isMicActive ? 'تم تشغيل الميكروفون والصوتيات بنجاح 🎙️' : 'تم كتم الميكروفون 🔇'),
                                duration: const Duration(milliseconds: 800),
                              ));
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), shape: BoxShape.circle),
                            child: const Icon(Icons.emoji_emotions, color: Colors.amber, size: 18),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: const Color(0xff00E5FF).withOpacity(0.2), shape: BoxShape.circle),
                            child: const Icon(Icons.chat_bubble, color: Color(0xff00E5FF), size: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xff121816),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: playerColors[currentTurnColor]!, width: 2),
                          boxShadow: [BoxShadow(color: playerColors[currentTurnColor]!.withOpacity(0.3), blurRadius: 8)],
                        ),
                        child: Center(
                          child: Text(
                            '$diceValue',
                            style: TextStyle(color: playerColors[currentTurnColor], fontSize: 20, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ScaleTransition(
                          scale: _diceScaleAnim,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: playerColors[currentTurnColor],
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 6,
                            ),
                            onPressed: (!isRolling && !hasRolled && !isAnimatingMove && !isGameOver && (currentTurnColor == PlayerColor.green || !widget.isVsAI)) ? rollDice : null,
                            child: Text(
                              isRolling ? 'جاري الرَمي...' : (hasRolled ? 'اختر حجراً للتحريك' : '🎲 ارمِ النرد'),
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAllTokens(double boardSize) {
    List<Widget> widgets = [];
    double cell = boardSize / 15.0;

    allTokens.forEach((color, tokens) {
      for (int i = 0; i < tokens.length; i++) {
        TokenModel token = tokens[i];
        Offset coord;

        if (token.position == -1) {
          coord = _getBaseOffset(color, i, boardSize, cell);
        } else if (token.position == LudoEngine.targetWin) {
          int pIdx = turnOrder.indexOf(color);
          coord = Offset(boardSize * 0.5 + (pIdx == 0 ? -10 : (pIdx == 1 ? 10 : 0)), boardSize * 0.5 + (pIdx == 2 ? 10 : (pIdx == 3 ? -10 : 0)));
        } else if (token.position >= 0 && token.position < LudoEngine.totalPathCells) {
          int absoluteIndex = LudoEngine.getAbsolutePosition(token.position, color);
          coord = Offset((boardPathCoordinates[absoluteIndex].dx + 0.5) * cell, (boardPathCoordinates[absoluteIndex].dy + 0.5) * cell);
        } else {
          coord = _getHomeStretchOffset(color, token.position - LudoEngine.homeStretchStart, boardSize, cell);
        }

        widgets.add(
          Positioned(
            left: coord.dx - 11,
            top: coord.dy - 11,
            child: GestureDetector(
              onTap: () => selectToken(color, i),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: playerColors[color],
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 4)],
                ),
                child: Center(
                  child: Text(
                    token.position == -1 ? '🏠' : (token.position == LudoEngine.targetWin ? '👑' : '${token.position}'),
                    style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    });
    return widgets;
  }

  Offset _getBaseOffset(PlayerColor color, int idx, double boardSize, double cell) {
    double startX = 0, startY = 0;
    if (color == PlayerColor.green) { startX = cell * 1; startY = cell * 1; }
    else if (color == PlayerColor.yellow) { startX = cell * 10; startY = cell * 1; }
    else if (color == PlayerColor.red) { startX = cell * 10; startY = cell * 10; }
    else if (color == PlayerColor.blue) { startX = cell * 1; startY = cell * 10; }

    double dx = (idx % 2 == 0) ? startX + cell * 1.0 : startX + cell * 3.0;
    double dy = (idx < 2) ? startY + cell * 1.0 : startY + cell * 3.0;
    return Offset(dx, dy);
  }

  Offset _getHomeStretchOffset(PlayerColor color, int stepIdx, double boardSize, double cell) {
    double cx = boardSize * 0.5;
    double cy = boardSize * 0.5;
    if (color == PlayerColor.green) return Offset(cx, cell * (1.5 + stepIdx));
    if (color == PlayerColor.yellow) return Offset(boardSize - cell * (1.5 + stepIdx), cy);
    if (color == PlayerColor.red) return Offset(cx, boardSize - cell * (1.5 + stepIdx));
    return Offset(cell * (1.5 + stepIdx), cy);
  }
}

// 5. رسام رقعة اللعب السيبرانية
class CyberBoardPainter extends CustomPainter {
  final List<Offset> pathCoordinates;
  CyberBoardPainter(this.pathCoordinates);

  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = const Color(0xff00E5FF).withOpacity(0.12)
      ..strokeWidth = 1;

    double cell = size.width / 15.0;

    for (int i = 0; i <= 15; i++) {
      canvas.drawLine(Offset(i * cell, 0), Offset(i * cell, size.height), paintGrid);
      canvas.drawLine(Offset(0, i * cell), Offset(size.width, i * cell), paintGrid);
    }

    final paintGreen = Paint()..color = Colors.green.withOpacity(0.25);
    final paintYellow = Paint()..color = Colors.amber.withOpacity(0.25);
    final paintRed = Paint()..color = Colors.red.withOpacity(0.25);
    final paintBlue = Paint()..color = Colors.blue.withOpacity(0.25);

    canvas.drawRect(Rect.fromLTWH(0, 0, cell * 6, cell * 6), paintGreen);
    canvas.drawRect(Rect.fromLTWH(cell * 9, 0, cell * 6, cell * 6), paintYellow);
    canvas.drawRect(Rect.fromLTWH(cell * 9, cell * 9, cell * 6, cell * 6), paintRed);
    canvas.drawRect(Rect.fromLTWH(0, cell * 9, cell * 6, cell * 6), paintBlue);

    final paintDot = Paint()
      ..color = const Color(0xff00E676)
      ..style = PaintingStyle.fill;

    for (var coord in pathCoordinates) {
      canvas.drawCircle(Offset((coord.dx + 0.5) * cell, (coord.dy + 0.5) * cell), 3.5, paintDot);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
