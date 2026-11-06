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
              const Center(child: Text('محرك اللعبة السيبراني الهندسي المطور والنهائي مع تصحيح المتغيرات', style: TextStyle(color: Colors.grey, fontSize: 13), textAlign: TextAlign.center)),
              const SizedBox(height: 48),
              _buildLobbyButton(
                context,
                title: 'لعب ضد الذكاء الاصطناعي (AI)',
                icon: Icons.smart_toy_rounded,
                borderColor: const Color(0xff00E5FF),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LudoGameScreen(isVsAI: true, isTwoPlayerMode: true)));
                },
              ),
              const SizedBox(height: 16),
              _buildLobbyButton(
                context,
                title: 'لعب ثنائي محلي (مع صديق)',
                icon: Icons.people_alt_rounded,
                borderColor: const Color(0xff00E676),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LudoGameScreen(isVsAI: false, isTwoPlayerMode: true)));
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

// محرك قواعد اللعبة الهندسي المستقل والمصحح بالكامل
class LudoEngine {
  static const int totalPathCells = 52;
  static const int homeStretchStart = 52;
  static const int homeStretchEnd = 57;
  static const int targetWin = 58;

  static const List<int> startOffsets = [0, 13, 26, 39];
  static const Set<int> safeAbsoluteSpots = {0, 8, 13, 21, 26, 34, 39, 47};

  static int getAbsolutePosition(int localPos, int playerIndex) {
    if (localPos < 0 || localPos >= totalPathCells) return -1;
    return (localPos + startOffsets[playerIndex]) % totalPathCells;
  }

  static int calculateNewPosition(int currentPos, int roll, int playerIndex) {
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

  static List<int> getLegalMoves(List<int> playerPieces, int roll, int playerIndex) {
    List<int> legalIndices = [];
    for (int i = 0; i < 4; i++) {
      int pos = playerPieces[i];
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

  static List<int> getStepByStepPath(int currentPos, int roll, int playerIndex) {
    List<int> path = [];
    int tempPos = currentPos;

    if (tempPos == -1 && roll == 6) {
      path.add(0);
      return path;
    }

    for (int step = 0; step < roll; step++) {
      tempPos = calculateNewPosition(tempPos, 1, playerIndex);
      path.add(tempPos);
      if (tempPos == targetWin) break;
    }
    return path;
  }

  static void processCaptures(int activePlayer, int movedPieceIdx, List<List<int>> allPieces, int totalActivePlayers) {
    int activePos = allPieces[activePlayer][movedPieceIdx];
    if (activePos < 0 || activePos >= totalPathCells) return;

    int activeAbsolute = getAbsolutePosition(activePos, activePlayer);
    if (safeAbsoluteSpots.contains(activeAbsolute)) return;

    for (int p = 0; p < totalActivePlayers; p++) {
      if (p == activePlayer) continue;
      for (int i = 0; i < 4; i++) {
        int enemyPos = allPieces[p][i];
        if (enemyPos >= 0 && enemyPos < totalPathCells) {
          int enemyAbsolute = getAbsolutePosition(enemyPos, p);
          if (activeAbsolute == enemyAbsolute) {
            allPieces[p][i] = -1;
          }
        }
      }
    }
  }

  static String runEngineUnitTests() {
    StringBuffer log = StringBuffer();
    try {
      List<int> pieces = [-1, -1, -1, -1];
      List<int> legal = getLegalMoves(pieces, 6, 0);
      assert(legal.length == 4);
      log.writeln('اختبار خروج القاعدة (رمي 6): ناجح ✅');

      legal = getLegalMoves(pieces, 5, 0);
      assert(legal.isEmpty);
      log.writeln('اختبار منع الخروج بدون 6: ناجح ✅');

      int absGreen = getAbsolutePosition(0, 0);
      int absYellow = getAbsolutePosition(0, 1);
      assert(absGreen == 0 && absYellow == 13);
      log.writeln('اختبار حساب الموقع المطلق للاعبين: ناجح ✅');

      int nearWin = 57;
      int winPos = calculateNewPosition(nearWin, 1, 0);
      assert(winPos == targetWin);
      log.writeln('اختبار الوصول الدقيق للمركز والفوز: ناجح ✅');

      int overPos = calculateNewPosition(57, 3, 0);
      assert(overPos == 57);
      log.writeln('اختبار منع تجاوز النهاية: ناجح ✅');

      log.writeln('جميع اختبارات وحدة المحرك نجحت بامتياز تام! 🚀');
    } catch (e) {
      log.writeln('فشل في اختبارات المحرك: $e');
    }
    return log.toString();
  }
}

class LudoGameScreen extends StatefulWidget {
  final bool isVsAI;
  final bool isTwoPlayerMode;
  const LudoGameScreen({super.key, required this.isVsAI, required this.isTwoPlayerMode});

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> with TickerProviderStateMixin {
  int diceValue = 6;
  bool isRolling = false;
  bool hasRolled = false;
  bool isAnimatingMove = false;
  bool isGameOver = false;
  Timer? _activeTimer;

  final int activePlayersCount = 2;

  List<List<int>> playerPieces = [
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
  ];

  int currentTurn = 0;
  String gameStatus = 'دور اللاعب: أخضر (رائد) - ارمِ النرد!';

  final List<String> playerNames = ['أخضر', 'أصفر', 'أحمر', 'أزرق'];
  final List<Color> playerColors = [Colors.greenAccent, Colors.amberAccent, Colors.redAccent, Colors.blueAccent];

  final List<Offset> boardPathCoordinates = _generateStrict52Path();

  late AnimationController _diceAnimController;
  late Animation<double> _diceScaleAnim;

  @override
  void initState() {
    super.initState();
    _diceAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _diceScaleAnim = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _diceAnimController, curve: Curves.easeInOut));
    
    debugPrint(LudoEngine.runEngineUnitTests());
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
      playerPieces = [
        [-1, -1, -1, -1],
        [-1, -1, -1, -1],
        [-1, -1, -1, -1],
        [-1, -1, -1, -1],
      ];
      currentTurn = 0;
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

        List<int> legalMoves = LudoEngine.getLegalMoves(playerPieces[currentTurn], diceValue, currentTurn);

        if (legalMoves.isEmpty) {
          gameStatus = 'لا توجد حركات مُمكِنة للرقم $diceValue! ينتقل الدور.';
          _activeTimer = Timer(const Duration(milliseconds: 1200), () {
            if (mounted && !isGameOver) _nextTurn();
          });
        } else {
          gameStatus = 'تم رمي ($diceValue). اضغط على الحجر المناسب للتحريك!';
          if (widget.isVsAI && currentTurn == 1) {
            _executeAIMove(legalMoves);
          }
        }
      });
    });
  }

  void selectPiece(int player, int pieceIndex) {
    if (!hasRolled || player != currentTurn || isAnimatingMove || isGameOver) return;

    List<int> legalMoves = LudoEngine.getLegalMoves(playerPieces[player], diceValue, player);
    if (!legalMoves.contains(pieceIndex)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('هذه الحركة غير قانونية!'), duration: Duration(milliseconds: 700)));
      return;
    }

    List<int> stepPath = LudoEngine.getStepByStepPath(playerPieces[player][pieceIndex], diceValue, player);
    _executeStepAnimation(player, pieceIndex, stepPath, 0, diceValue);
  }

  void _executeStepAnimation(int player, int pieceIndex, List<int> steps, int stepIndex, int totalRoll) {
    if (stepIndex >= steps.length) {
      setState(() {
        isAnimatingMove = false;
        hasRolled = false;

        LudoEngine.processCaptures(player, pieceIndex, playerPieces, activePlayersCount);

        bool allWon = playerPieces[player].every((p) => p == LudoEngine.targetWin);
        if (allWon) {
          isGameOver = true;
          gameStatus = '🏆 فاز اللاعب ${playerNames[player]} بالمعركة السيبرانية!';
          _showWinDialog(playerNames[player]);
          return;
        }

        if (totalRoll == 6) {
          gameStatus = 'رقم 6 مميز! حصلت على رمية إضافية.';
          if (widget.isVsAI && currentTurn == 1) {
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
      playerPieces[player][pieceIndex] = steps[stepIndex];
    });

    _activeTimer = Timer(const Duration(milliseconds: 180), () {
      if (mounted) {
        _executeStepAnimation(player, pieceIndex, steps, stepIndex + 1, totalRoll);
      }
    });
  }

  void _nextTurn() {
    if (isGameOver) return;
    do {
      currentTurn = (currentTurn + 1) % activePlayersCount;
    } while (widget.isVsAI && currentTurn == 1);

    gameStatus = 'دور اللاعب: ${playerNames[currentTurn]} - ارمِ النرد.';
    hasRolled = false;

    if (widget.isVsAI && currentTurn == 1) {
      _activeTimer = Timer(const Duration(milliseconds: 800), () {
        if (mounted && !isGameOver) rollDice();
      });
    }
  }

  void _executeAIMove(List<int> legalMoves) {
    _activeTimer?.cancel();
    _activeTimer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted || isGameOver) return;

      int chosenMove = legalMoves.first;

      for (int idx in legalMoves) {
        int pos = playerPieces[1][idx];
        int finalPos = LudoEngine.calculateNewPosition(pos, diceValue, 1);
        if (finalPos == LudoEngine.targetWin) {
          chosenMove = idx;
          break;
        }
      }

      if (chosenMove == legalMoves.first) {
        for (int idx in legalMoves) {
          int pos = playerPieces[1][idx];
          if (pos >= 0 && pos < LudoEngine.totalPathCells) {
            int targetAbs = LudoEngine.getAbsolutePosition(LudoEngine.calculateNewPosition(pos, diceValue, 1), 1);
            bool willCapture = false;
            for (int p = 0; p < activePlayersCount; p++) {
              if (p == 1) continue;
              for (int e = 0; e < 4; e++) {
                int enemyPos = playerPieces[p][e];
                if (enemyPos >= 0 && enemyPos < LudoEngine.totalPathCells) {
                  if (LudoEngine.getAbsolutePosition(enemyPos, p) == targetAbs) {
                    willCapture = true;
                    break;
                  }
                }
              }
              if (willCapture) break;
            }
            if (willCapture) {
              chosenMove = idx;
              break;
            }
          }
        }
      }

      if (diceValue == 6 && chosenMove == legalMoves.first) {
        for (int idx in legalMoves) {
          if (playerPieces[1][idx] == -1) {
            chosenMove = idx;
            break;
          }
        }
      }

      selectPiece(1, chosenMove);
    });
  }

  void _showWinDialog(String winnerName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff121816),
        title: Text('🏆 انتصار سيبراني', style: TextStyle(color: playerColors[currentTurn], fontWeight: FontWeight.bold)),
        content: Text('الفائز في الساحة الثنائية هو: $winnerName!', style: const TextStyle(color: Colors.white)),
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
      appBar: AppBar(
        title: const Text('RAYID CYBER ARENA', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xff00E5FF))),
        backgroundColor: const Color(0xff080C0B),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xff00E676)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xff00E676)),
            onPressed: resetGame,
            tooltip: 'إعادة تعيين',
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xff121816),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xff00E5FF).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: Color(0xff00E676), size: 20),
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
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xff050709),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xff00E676), width: 2),
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
                            ..._buildAllPieces(size),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xff080C0B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(top: BorderSide(color: Color(0xff00E5FF), width: 1)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xff121816),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: playerColors[currentTurn], width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '$diceValue',
                        style: TextStyle(color: playerColors[currentTurn], fontSize: 22, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ScaleTransition(
                      scale: _diceScaleAnim,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: playerColors[currentTurn],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 6,
                        ),
                        onPressed: (!isRolling && !hasRolled && !isAnimatingMove && !isGameOver && (currentTurn == 0 || !widget.isVsAI)) ? rollDice : null,
                        child: Text(
                          isRolling ? 'جاري الرَمي...' : (hasRolled ? 'اختر حجراً للتحريك' : '🎲 ارمِ النرد'),
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                        ),
                      ),
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

  List<Widget> _buildAllPieces(double boardSize) {
    List<Widget> widgets = [];
    double cell = boardSize / 15.0;

    for (int p = 0; p < activePlayersCount; p++) {
      for (int i = 0; i < 4; i++) {
        int pos = playerPieces[p][i];
        Offset coord;

        if (pos == -1) {
          coord = _getBaseOffset(p, i, boardSize, cell);
        } else if (pos == LudoEngine.targetWin) {
          coord = Offset(boardSize * 0.5 + (p == 0 ? -10 : 10), boardSize * 0.5);
        } else if (pos >= 0 && pos < LudoEngine.totalPathCells) {
          int absoluteIndex = LudoEngine.getAbsolutePosition(pos, p);
          coord = Offset((boardPathCoordinates[absoluteIndex].dx + 0.5) * cell, (boardPathCoordinates[absolute].dy + 0.5) * cell);
        } else {
          coord = _getHomeStretchOffset(p, pos - LudoEngine.homeStretchStart, boardSize, cell);
        }

        widgets.add(
          Positioned(
            left: coord.dx - 11,
            top: coord.dy - 11,
            child: GestureDetector(
              onTap: () => selectPiece(p, i),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: playerColors[p],
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 4)],
                ),
                child: Center(
                  child: Text(
                    pos == -1 ? '🏠' : (pos == LudoEngine.targetWin ? '👑' : '$pos'),
                    style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }

    Offset _getBaseOffset(int player, int idx, double boardSize, double cell) {
    double startX = 0, startY = 0;
    if (player == 0) { startX = cell * 1; startY = cell * 1; }
    else if (player == 1) { startX = cell * 10; startY = cell * 1; }

    double dx = (idx % 2 == 0) ? startX + cell * 1.0 : startX + cell * 3.0;
    double dy = (idx < 2) ? startY + cell * 1.0 : startY + cell * 3.0;
    return Offset(dx, dy);
  }

  Offset _getHomeStretchOffset(int player, int stepIdx, double boardSize, double cell) {
    double cx = boardSize * 0.5;
    double cy = boardSize * 0.5;
    if (player == 0) return Offset(cx, cell * (1.5 + stepIdx));
    if (player == 1) return Offset(boardSize - cell * (1.5 + stepIdx), cy);
    return Offset(cx, cy);
  }
}

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
