import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// ============================================================================
// RAYID PAY - CYBERPUNK LUDO ARENA (ULTIMATE PRODUCTION VERSION)
// ============================================================================

enum PlayerColor { green, yellow, red, blue }

class TokenModel {
  final int id;
  final PlayerColor color;
  int position; // -1: Base, 0..51: Shared Track, 52..57: Home Lane, 58: Won

  TokenModel({
    required this.id,
    required this.color,
    this.position = -1,
  });

  TokenModel copy() => TokenModel(
        id: id,
        color: color,
        position: position,
      );
}

class LudoEngine {
  static const int totalPathCells = 52;
  static const int homeStart = 52;
  static const int homeEnd = 57;
  static const int targetWin = 58;
  static const int invalidMove = -2;

  static const Map<PlayerColor, int> startOffsets = {
    PlayerColor.green: 0,   
    PlayerColor.yellow: 26, 
    PlayerColor.red: 13,    
    PlayerColor.blue: 39,   
  };


  static const Set<int> safeAbsoluteSpots = {
    0, 8, 13, 21, 26, 34, 39, 47
  };

  static int getAbsolutePosition(int localPosition, PlayerColor color) {
    if (localPosition < 0 || localPosition >= totalPathCells) {
      return -1;
    }
    return (localPosition + startOffsets[color]!) % totalPathCells;
  }

  static int calculateNewPosition(int currentPosition, int roll, PlayerColor color) {
    if (roll < 1 || roll > 6) return invalidMove;
    if (currentPosition == targetWin) return invalidMove;

    if (currentPosition == -1) {
      return roll == 6 ? 0 : invalidMove;
    }

    if (currentPosition >= 0 && currentPosition < totalPathCells) {
      final nextPosition = currentPosition + roll;
      if (nextPosition < totalPathCells) {
        return nextPosition;
      }
      int excess = nextPosition - totalPathCells;
      int homeTarget = homeStart + excess;
      if (homeTarget <= targetWin) {
        return homeTarget;
      }
      return invalidMove;
    }

    if (currentPosition >= homeStart && currentPosition <= homeEnd) {
      final nextPosition = currentPosition + roll;
      if (nextPosition <= targetWin) {
        return nextPosition;
      }
      return invalidMove;
    }

    return invalidMove;
  }

  static List<int> getLegalMoves(List<TokenModel> tokens, int roll) {
    final result = <int>[];
    for (int i = 0; i < tokens.length; i++) {
      if (calculateNewPosition(tokens[i].position, roll, tokens[i].color) != invalidMove) {
        result.add(i);
      }
    }
    return result;
  }

  static List<int> getStepByStepPath(int currentPosition, int roll, PlayerColor color) {
    final path = <int>[];
    if (currentPosition == -1) {
      if (roll == 6) path.add(0);
      return path;
    }

    int position = currentPosition;
    for (int i = 0; i < roll; i++) {
      final next = calculateNewPosition(position, 1, color);
      if (next == invalidMove) return [];
      position = next;
      path.add(position);
      if (position == targetWin) break;
    }
    return path;
  }

  static bool isSafePosition(int localPosition, PlayerColor color) {
    if (localPosition < 0 || localPosition >= totalPathCells) return false;
    return safeAbsoluteSpots.contains(getAbsolutePosition(localPosition, color));
  }

  static bool processCaptures(
    PlayerColor activeColor,
    int movedTokenId,
    Map<PlayerColor, List<TokenModel>> allTokens,
  ) {
    final activeTokens = allTokens[activeColor];
    if (activeTokens == null || movedTokenId < 0 || movedTokenId >= activeTokens.length) {
      return false;
    }

    final activeToken = activeTokens[movedTokenId];
    if (activeToken.position < 0 || activeToken.position >= totalPathCells) {
      return false;
    }

    if (isSafePosition(activeToken.position, activeColor)) {
      return false;
    }

    final absolutePosition = getAbsolutePosition(activeToken.position, activeColor);
    bool captured = false;

    for (final entry in allTokens.entries) {
      if (entry.key == activeColor) continue;

      for (final enemy in entry.value) {
        if (enemy.position < 0 || enemy.position >= totalPathCells) continue;

        final enemyAbsolute = getAbsolutePosition(enemy.position, entry.key);
        if (enemyAbsolute == absolutePosition) {
          enemy.position = -1; // إرجاع الخصم للقاعدة
          captured = true;
        }
      }
    }
    return captured;
  }

  static bool hasWon(List<TokenModel> tokens) {
    return tokens.every((token) => token.position == targetWin);
  }
}

// ============================================================================
// BOARD GEOMETRY (52 Strictly Adjacent Cells)
// ============================================================================

class LudoBoardGeometry {
    static final List<Offset> track = _createTrack();

  static List<Offset> _createTrack() {
    final List<Offset> p = [
      // 0 - 5: مسار انطلاق الأخضر والنزول لليمين
      const Offset(6, 1), const Offset(6, 2), const Offset(6, 3), const Offset(6, 4), const Offset(6, 5), const Offset(5, 5),
      // 6 - 12: الاتجاه نحو اليسار
      const Offset(4, 5), const Offset(3, 5), const Offset(2, 5), const Offset(1, 5), const Offset(0, 5),
      const Offset(0, 6), const Offset(0, 7),
      // 13 - 18: الانعطاف نحو قاعدة الأزرق والنزول
      const Offset(0, 8), const Offset(1, 8), const Offset(2, 8), const Offset(3, 8), const Offset(4, 8), const Offset(5, 8),
      // 19 - 25: الاتجاه نحو الأسفل عند قاعدة الأزرق
      const Offset(6, 9), const Offset(6, 10), const Offset(6, 11), const Offset(6, 12), const Offset(6, 13), const Offset(6, 14),
      const Offset(7, 14), const Offset(8, 14),
      // 26 - 31: الصعود نحو جهة الأحمر
      const Offset(8, 13), const Offset(8, 12), const Offset(8, 11), const Offset(8, 10), const Offset(8, 9),
      // 32 - 38: الاتجاه نحو اليمين
      const Offset(9, 8), const Offset(10, 8), const Offset(11, 8), const Offset(12, 8), const Offset(13, 8), const Offset(14, 8),
      const Offset(14, 7), const Offset(14, 6),
      // 39 - 44: الالتفاف نحو الأعلى (قاعدة الأصفر)
      const Offset(14, 5), const Offset(13, 5), const Offset(12, 5), const Offset(11, 5), const Offset(10, 5), const Offset(9, 5),
      // 45 - 51: الاتجاه نحو البداية إكمالاً للدورة
      const Offset(8, 4), const Offset(8, 3), const Offset(8, 2), const Offset(8, 1), const Offset(8, 0),
      const Offset(7, 0), const Offset(6, 0),
    ];
    return List.unmodifiable(p);
  }

  static const Map<PlayerColor, int> startOffsets = {
    PlayerColor.green: 0,   
    PlayerColor.blue: 13,   
    PlayerColor.red: 26,    
    PlayerColor.yellow: 39, 
  };


  static Offset homePosition(PlayerColor color, int step, double cell) {
    switch (color) {
      case PlayerColor.green:
        return Offset(cell * 7.0, cell * (1.0 + step));
      case PlayerColor.yellow:
        return Offset(cell * (13.0 - step), cell * 7.0);
      case PlayerColor.red:
        return Offset(cell * 7.0, cell * (13.0 - step));
      case PlayerColor.blue:
        return Offset(cell * (1.0 + step), cell * 7.0);
    }
  }

  static Offset basePosition(PlayerColor color, int index, double cell) {
    double x = 1, y = 1;
    switch (color) {
      case PlayerColor.green: x = 1; y = 1; break;
      case PlayerColor.yellow: x = 10; y = 1; break;
      case PlayerColor.red: x = 10; y = 10; break;
      case PlayerColor.blue: x = 1; y = 10; break;
    }
    return Offset(
      cell * (x + (index % 2 == 0 ? 1.2 : 2.8)),
      cell * (y + (index < 2 ? 1.2 : 2.8)),
    );
  }
}

// ============================================================================
// LOBBY SCREEN
// ============================================================================

class LudoLobbyScreen extends StatelessWidget {
  const LudoLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff05070B),
      appBar: AppBar(
        backgroundColor: const Color(0xff0A0E17),
        centerTitle: true,
        title: const Text(
          'RAYID CYBER ARENA',
          style: TextStyle(color: Color(0xff00E5FF), fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff0D1322), Color(0xff05070B), Color(0xff140B22)],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt_rounded, size: 90, color: Color(0xff00E676)),
            const SizedBox(height: 20),
            const Text(
              'RAYID CYBER LUDO',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2),
            ),
            const SizedBox(height: 8),
            const Text(
              'CYBERPUNK NEON EDITION',
              style: TextStyle(color: Color(0xff00E5FF), fontSize: 12, letterSpacing: 3),
            ),
            const SizedBox(height: 55),
            _lobbyButton(context, 'FOUR PLAYERS VS AI', Icons.smart_toy, const Color(0xff00E5FF), true),
            const SizedBox(height: 18),
            _lobbyButton(context, 'LOCAL FOUR PLAYER', Icons.groups, const Color(0xff00E676), false),
          ],
        ),
      ),
    );
  }

  Widget _lobbyButton(BuildContext context, String title, IconData icon, Color color, bool ai) {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff0E1624),
          foregroundColor: Colors.white,
          elevation: 10,
          shadowColor: color.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: color, width: 2),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LudoGameScreen(isVsAI: ai)),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// GAME SCREEN
// ============================================================================

class LudoGameScreen extends StatefulWidget {
  final bool isVsAI;
  const LudoGameScreen({super.key, required this.isVsAI});

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> with SingleTickerProviderStateMixin {
  final Random _random = Random();
  final List<PlayerColor> turnOrder = PlayerColor.values;

  late Map<PlayerColor, List<TokenModel>> allTokens;
  int currentTurnIndex = 0;
  int diceValue = 6;

  bool isRolling = false;
  bool hasRolled = false;
  bool isAnimatingMove = false;
  bool isGameOver = false;
  bool showTutorial = true;
  bool soundEnabled = true;

  Timer? _timer;
  late AnimationController _diceController;
  late Animation<double> _diceAnimation;

  final Map<PlayerColor, String> playerNames = {
    PlayerColor.green: 'الأخضر',
    PlayerColor.yellow: 'الأصفر',
    PlayerColor.red: 'الأحمر',
    PlayerColor.blue: 'الأزرق',
  };

  final Map<PlayerColor, Color> playerColors = {
    PlayerColor.green: const Color(0xff00E676),
    PlayerColor.yellow: const Color(0xffFFD740),
    PlayerColor.red: const Color(0xffFF5252),
    PlayerColor.blue: const Color(0xff00E5FF),
  };

  PlayerColor get currentTurnColor => turnOrder[currentTurnIndex];
  String _statusMessage = 'دور اللاعب الأخضر - ارمِ النرد السيبراني';

  @override
  void initState() {
    super.initState();
    _initializeTokens();
    _diceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _diceAnimation = Tween<double>(begin: 1, end: 1.25).animate(
      CurvedAnimation(parent: _diceController, curve: Curves.easeInOut),
    );
  }

  void _initializeTokens() {
    allTokens = {
      for (final color in PlayerColor.values)
        color: List.generate(4, (i) => TokenModel(id: i, color: color)),
    };
  }

  @override
  void dispose() {
    _timer?.cancel();
    _diceController.dispose();
    super.dispose();
  }

  void resetGame() {
    _timer?.cancel();
    if (!mounted) return;
    setState(() {
      _initializeTokens();
      currentTurnIndex = 0;
      diceValue = 6;
      isRolling = false;
      hasRolled = false;
      isAnimatingMove = false;
      isGameOver = false;
      _statusMessage = 'دور اللاعب الأخضر - ارمِ النرد السيبراني';
    });
  }

  void rollDice() {
    if (!mounted || isRolling || hasRolled || isAnimatingMove || isGameOver) return;
    if (widget.isVsAI && currentTurnColor != PlayerColor.green) return;
    _executeRollSequence();
  }

  void _executeRollSequence() {
    if (!mounted || isGameOver) return;

    setState(() => isRolling = true);
    _diceController.forward().then((_) {
      if (mounted) _diceController.reverse();
    });

    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 400), () {
      if (!mounted || isGameOver) return;

      setState(() {
        diceValue = _random.nextInt(6) + 1;
        isRolling = false;
        hasRolled = true;
      });

      final legalMoves = LudoEngine.getLegalMoves(allTokens[currentTurnColor]!, diceValue);
      if (legalMoves.isEmpty) {
        _handleNoLegalMoves();
        return;
      }

      if (widget.isVsAI && currentTurnColor != PlayerColor.green) {
        _executeAIMove(legalMoves);
      }
    });
  }

  void _handleNoLegalMoves() {
    final rolledSix = diceValue == 6;
    setState(() => hasRolled = false);

    if (rolledSix) {
      _setStatus('رقم 6! حصل اللاعب على رمية إضافية.');
      _scheduleAITurnIfNeeded();
    } else {
      _setStatus('لا توجد حركة ممكنة بهذا الرقم. ينتقل الدور.');
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 900), () {
        if (mounted && !isGameOver) _nextTurn();
      });
    }
  }

  // معالجة اختيار وتحريك الحجر عند النقر الفعلي عليه
  void selectToken(PlayerColor color, int tokenId) {
    if (!mounted || !hasRolled || color != currentTurnColor || isAnimatingMove || isGameOver) return;
    if (widget.isVsAI && color != PlayerColor.green) return;

    final tokens = allTokens[color]!;
    final legalMoves = LudoEngine.getLegalMoves(tokens, diceValue);

    if (!legalMoves.contains(tokenId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('هذا الحجر لا يمكن تحريكه بهذه الرّمية!'),
          duration: Duration(milliseconds: 700),
        ),
      );
      return;
    }

    final steps = LudoEngine.getStepByStepPath(tokens[tokenId].position, diceValue, color);
    if (steps.isEmpty) return;

    _timer?.cancel();
    setState(() {
      hasRolled = false;
      isAnimatingMove = true;
    });

    _animateToken(color, tokenId, steps, 0, diceValue);
  }

  void _animateToken(PlayerColor color, int tokenId, List<int> steps, int index, int totalRoll) {
    if (!mounted || isGameOver) return;

    if (index >= steps.length) {
      _finishMove(color, tokenId, totalRoll);
      return;
    }

    setState(() {
      allTokens[color]![tokenId].position = steps[index];
    });

    _timer = Timer(const Duration(milliseconds: 140), () {
      if (mounted) _animateToken(color, tokenId, steps, index + 1, totalRoll);
    });
  }

  void _finishMove(PlayerColor color, int tokenId, int totalRoll) {
    final captured = LudoEngine.processCaptures(color, tokenId, allTokens);
    final won = LudoEngine.hasWon(allTokens[color]!);

    if (!mounted || isGameOver) return;

    setState(() {
      isAnimatingMove = false;
      hasRolled = false;
    });

    if (won) {
      _declareWinner(color);
      return;
    }

    if (captured) {
      _setStatus('⚡ تم أسر حجر الخصم وإعادته إلى قاعدته!');
    } else if (totalRoll == 6) {
      _setStatus('🎲 رمية 6 مباركة! حصلت على دور إضافي.');
    }

    if (totalRoll == 6) {
      _scheduleAITurnIfNeeded();
    } else {
      _nextTurn();
    }
  }

  void _executeAIMove(List<int> legalMoves) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 650), () {
      if (!mounted || isGameOver || !hasRolled) return;

      final color = currentTurnColor;
      final tokens = allTokens[color]!;
      int selected = legalMoves.first;
      int bestScore = -999999;

      for (final index in legalMoves) {
        final token = tokens[index];
        final newPosition = LudoEngine.calculateNewPosition(token.position, diceValue, color);
        int score = 0;

        if (newPosition == LudoEngine.targetWin) score += 35000;

        if (newPosition >= 0 && newPosition < 52) {
          final absolute = LudoEngine.getAbsolutePosition(newPosition, color);
          if (!LudoEngine.safeAbsoluteSpots.contains(absolute)) {
            for (final entry in allTokens.entries) {
              if (entry.key == color) continue;
              for (final enemy in entry.value) {
                if (enemy.position >= 0 && enemy.position < 52) {
                  if (LudoEngine.getAbsolutePosition(enemy.position, entry.key) == absolute) {
                    score += 1800;
                  }
                }
              }
            }
          }
          if (LudoEngine.isSafePosition(newPosition, color)) score += 250;
        }

        if (token.position == -1) score += 700;
        if (token.position >= 0 && token.position < 58) score += (newPosition - token.position);
        if (diceValue == 6) score += 120;

        if (score > bestScore) {
          bestScore = score;
          selected = index;
        }
      }

      selectToken(color, selected);
    });
  }

  void _scheduleAITurnIfNeeded() {
    if (!widget.isVsAI || currentTurnColor == PlayerColor.green || isGameOver) return;
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 700), () {
      if (mounted && !isGameOver) _executeRollSequence();
    });
  }

  void _nextTurn() {
    if (!mounted || isGameOver) return;
    setState(() {
      currentTurnIndex = (currentTurnIndex + 1) % turnOrder.length;
      hasRolled = false;
      isRolling = false;
      isAnimatingMove = false;
      _statusMessage = 'دور اللاعب ${playerNames[currentTurnColor]}';
    });
    _scheduleAITurnIfNeeded();
  }

  void _setStatus(String message) {
    if (!mounted) return;
    setState(() => _statusMessage = message);
  }

  void _declareWinner(PlayerColor color) {
    if (!mounted) return;
    setState(() {
      isGameOver = true;
      hasRolled = false;
      isAnimatingMove = false;
      _statusMessage = '🏆 فاز ${playerNames[color]} في المعركة السيبرانية!';
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xff0E1624),
          title: const Text('🏆 CYBER VICTORY', style: TextStyle(color: Color(0xff00E5FF), fontWeight: FontWeight.w900)),
          content: Text('الفائز الأول بالساحة هو ${playerNames[color]}!', style: const TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('القائمة الرئيسية', style: TextStyle(color: Color(0xff00E5FF))),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                resetGame();
              },
              child: const Text('إعادة اللعب', style: TextStyle(color: Color(0xff00E676))),
            ),
          ],
        );
      },
    );
  }

  Offset _tokenCoordinate(TokenModel token, int index, double cell) {
    if (token.position == -1) {
      return LudoBoardGeometry.basePosition(token.color, index, cell);
    }
    if (token.position == LudoEngine.targetWin) {
      return Offset(cell * (6.9 + (index % 2) * 0.2), cell * (6.9 + (index ~/ 2) * 0.2));
    }
    if (token.position >= 52 && token.position <= 57) {
      return LudoBoardGeometry.homePosition(token.color, token.position - 52, cell);
    }
    final absolute = LudoEngine.getAbsolutePosition(token.position, token.color);
    final base = LudoBoardGeometry.track[absolute];
    return Offset((base.dx + 0.5) * cell, (base.dy + 0.5) * cell);
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = playerColors[currentTurnColor]!;

    return Scaffold(
      backgroundColor: const Color(0xff05070B),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            if (showTutorial) _buildTutorial(),
            _buildStatusBar(),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xff0D121D),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xffFF007F), width: 2.5), // إطار نيون وردي مطابق للصورة
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffFF007F).withOpacity(0.4),
                          blurRadius: 25,
                        ),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final boardSize = constraints.maxWidth;
                        final cell = boardSize / 15;
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(painter: CyberBoardPainter(LudoBoardGeometry.track)),
                            ),
                            ..._buildTokens(boardSize, cell),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            _buildBottomControls(activeColor),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: Color(0xff0A0E17),
        border: Border(bottom: BorderSide(color: Color(0xff00E5FF), width: 0.8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.bolt, color: Color(0xff00E676)),
          const Text('RAYID CYBER ARENA', style: TextStyle(color: Color(0xff00E5FF), fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.2)),
          IconButton(onPressed: resetGame, icon: const Icon(Icons.refresh, color: Color(0xff00E676))),
        ],
      ),
    );
  }

  Widget _buildTutorial() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff121D2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff00E5FF)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_rounded, color: Color(0xff00E5FF)),
          const SizedBox(width: 8),
          const Expanded(child: Text('ارمِ النرد، ثم اضغط على حجرك المضيء لتحريكه.', style: TextStyle(color: Colors.white, fontSize: 11))),
          TextButton(onPressed: () => setState(() => showTutorial = false), child: const Text('إغلاق', style: TextStyle(color: Color(0xff00E676)))),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff0E1624),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff00E5FF).withOpacity(0.3)),
      ),
      child: Text(_statusMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }

  // رسم الأحجار بتصميم سيبراني مجسم وبراق مع تفاعل باللمس
  List<Widget> _buildTokens(double boardSize, double cell) {
    final widgets = <Widget>[];
    for (final color in PlayerColor.values) {
      final tokens = allTokens[color]!;
      for (int i = 0; i < tokens.length; i++) {
        final token = tokens[i];
        final coordinate = _tokenCoordinate(token, i, cell);
        final colorValue = playerColors[color]!;
        final isSelectable = hasRolled && currentTurnColor == color && !isAnimatingMove && !isGameOver && LudoEngine.getLegalMoves(tokens, diceValue).contains(i);

        widgets.add(
          Positioned(
            left: coordinate.dx - 13,
            top: coordinate.dy - 13,
            child: GestureDetector(
              onTap: () => selectToken(color, i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.white, colorValue, colorValue.withOpacity(0.7)],
                  ),
                  border: Border.all(
                    color: isSelectable ? Colors.white : Colors.black,
                    width: isSelectable ? 2.5 : 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorValue.withOpacity(isSelectable ? 0.95 : 0.5),
                      blurRadius: isSelectable ? 15 : 6,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    token.position == -1 ? '🤖' : token.position == 58 ? '👑' : '${token.position}',
                    style: const TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.w900),
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

  // شريط التحكم السفلي مع نرد بمربع بارز وواضح وأزرار تفاعلية
  Widget _buildBottomControls(Color activeColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: const BoxDecoration(
        color: Color(0xff0A0E17),
        border: Border(top: BorderSide(color: Color(0xff00E5FF), width: 1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, color: activeColor.withOpacity(0.2), border: Border.all(color: activeColor, width: 2)),
                child: Icon(Icons.person, color: activeColor),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text('دور اللاعب: ${playerNames[currentTurnColor]}', style: TextStyle(color: activeColor, fontWeight: FontWeight.w900, fontSize: 13))),
              IconButton(
                onPressed: () => setState(() => soundEnabled = !soundEnabled),
                icon: Icon(soundEnabled ? Icons.volume_up : Icons.volume_off, color: soundEnabled ? const Color(0xff00E676) : Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // مربع النرد الواضح والبارز
              Container(
                width: 58,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xff0E1624),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: activeColor, width: 2.5),
                  boxShadow: [BoxShadow(color: activeColor.withOpacity(0.4), blurRadius: 10)],
                ),
                child: Text(
                  '$diceValue',
                  style: TextStyle(color: activeColor, fontSize: 30, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ScaleTransition(
                  scale: _diceAnimation,
                  child: ElevatedButton(
                    onPressed: (!isRolling && !hasRolled && !isAnimatingMove && !isGameOver && (!widget.isVsAI || currentTurnColor == PlayerColor.green)) ? rollDice : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeColor,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 8,
                    ),
                    child: Text(
                      isRolling ? 'جاري رمي النرد...' : hasRolled ? 'اختر حجراً للتحريك' : '🎲 ارمِ النرد السيبراني',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CYBERPUNK BOARD PAINTER (NEON & METALLIC CYBERPUNK THEME)
// ============================================================================

class CyberBoardPainter extends CustomPainter {
  final List<Offset> path;
  CyberBoardPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / 15;

    // خلفية معدنية داكنة مطابقة لصورة السايبربانك
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xff0B1019));

    // خطوط الشبكة الإلكترونية الخافتة
    final gridPaint = Paint()..color = const Color(0xff00E5FF).withOpacity(0.06)..strokeWidth = 0.6;
    for (int i = 0; i <= 15; i++) {
      canvas.drawLine(Offset(i * cell, 0), Offset(i * cell, size.height), gridPaint);
      canvas.drawLine(Offset(0, i * cell), Offset(size.width, i * cell), gridPaint);
    }

    // القواعد الأربع بتصميم معدني ونيون (أخضر، أصفر، أحمر، أزرق)
    _drawCyberBase(canvas, Rect.fromLTWH(0, 0, cell * 6, cell * 6), const Color(0xff00E676));
    _drawCyberBase(canvas, Rect.fromLTWH(cell * 9, 0, cell * 6, cell * 6), const Color(0xffFFD740));
    _drawCyberBase(canvas, Rect.fromLTWH(cell * 9, cell * 9, cell * 6, cell * 6), const Color(0xffFF5252));
    _drawCyberBase(canvas, Rect.fromLTWH(0, cell * 9, cell * 6, cell * 6), const Color(0xff00E5FF));

    // مسار الخانات المشتركة الـ 52
    final trackPaint = Paint()..color = const Color(0xff131C2E)..style = PaintingStyle.fill;
    final borderPaint = Paint()..color = const Color(0xff00E5FF).withOpacity(0.8)..style = PaintingStyle.stroke..strokeWidth = 1.2;

    for (int i = 0; i < path.length; i++) {
      final point = path[i];
      final rect = Rect.fromLTWH(point.dx * cell + 1, point.dy * cell + 1, cell - 2, cell - 2);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), trackPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), borderPaint);

      // مربعات الأمان على شكل نجوم نيون لامعة (★)
      if (LudoEngine.safeAbsoluteSpots.contains(i)) {
        final starPaint = Paint()..color = const Color(0xff00E676).withOpacity(0.7);
        canvas.drawCircle(rect.center, cell * 0.18, starPaint);
      }
    }

    // الممرات النهائية الأربعة المؤدية للцентر
    _drawHomeLane(canvas, cell, const Color(0xff00E676), true, 7.0, 1.0, 1);
    _drawHomeLane(canvas, cell, const Color(0xffFFD740), false, 13.0, 7.0, -1);
    _drawHomeLane(canvas, cell, const Color(0xffFF5252), true, 7.0, 13.0, -1);
    _drawHomeLane(canvas, cell, const Color(0xff00E5FF), false, 1.0, 7.0, 1);

    // مركز اللعبة السيبراني المضيء والمتوهج
    final centerRect = Rect.fromLTWH(cell * 6, cell * 6, cell * 3, cell * 3);
    final centerPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xff00E676), Color(0xff00E5FF), Color(0xffFF007F), Color(0xffFFD740)],
      ).createShader(centerRect);

    canvas.drawRect(centerRect, centerPaint);
    canvas.drawRect(centerRect, Paint()..color = Colors.white.withOpacity(0.9)..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  void _drawCyberBase(Canvas canvas, Rect rect, Color color) {
    final fill = Paint()..color = color.withOpacity(0.15);
    final border = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2.5;

    canvas.drawRRect(RRect.fromRectAndRadius(rect.deflate(3), const Radius.circular(12)), fill);
    canvas.drawRRect(RRect.fromRectAndRadius(rect.deflate(3), const Radius.circular(12)), border);
  }

  void _drawHomeLane(Canvas canvas, double cell, Color color, bool vertical, double startX, double startY, int dir) {
    final paint = Paint()..color = color.withOpacity(0.4);
    for (int i = 0; i < 6; i++) {
      final rect = vertical
          ? Rect.fromLTWH(cell * startX, cell * (startY + (i * dir)), cell, cell)
          : Rect.fromLTWH(cell * (startX + (i * dir)), cell * startY, cell, cell);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CyberBoardPainter oldDelegate) => false;
}
