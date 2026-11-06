
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// ============================================================================
// RAYID PAY - CYBER LUDO
// Complete local four-player game with AI
// ============================================================================

enum PlayerColor { green, yellow, red, blue }

class TokenModel {
  final int id;
  final PlayerColor color;
  int position;

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

// ============================================================================
// GAME ENGINE
// Position:
// -1 = Base
//  0..51 = Shared track (local progress)
// 52..57 = Home lane
// 58 = Won
// -2 = Invalid movement
// ============================================================================

class LudoEngine {
  static const int totalPathCells = 52;
  static const int homeStart = 52;
  static const int homeEnd = 57;
  static const int targetWin = 58;
  static const int invalidMove = -2;

  static const Map<PlayerColor, int> startOffsets = {
    PlayerColor.green: 0,
    PlayerColor.yellow: 13,
    PlayerColor.red: 26,
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

  static int calculateNewPosition(
    int currentPosition,
    int roll,
    PlayerColor color,
  ) {
    if (roll < 1 || roll > 6) return invalidMove;

    if (currentPosition == targetWin) return invalidMove;

    if (currentPosition == -1) {
      return roll == 6 ? 0 : invalidMove;
    }

    if (currentPosition >= 0 && currentPosition <= 51) {
      final nextPosition = currentPosition + roll;

      if (nextPosition <= 57) {
        return nextPosition;
      }

      if (nextPosition == targetWin) {
        return targetWin;
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

  static List<int> getLegalMoves(
    List<TokenModel> tokens,
    int roll,
  ) {
    final result = <int>[];

    for (int i = 0; i < tokens.length; i++) {
      final token = tokens[i];

      if (calculateNewPosition(token.position, roll, token.color) !=
          invalidMove) {
        result.add(i);
      }
    }

    return result;
  }

  static List<int> getStepByStepPath(
    int currentPosition,
    int roll,
    PlayerColor color,
  ) {
    final path = <int>[];

    if (currentPosition == -1) {
      if (roll == 6) path.add(0);
      return path;
    }

    int position = currentPosition;

    for (int i = 0; i < roll; i++) {
      final next = calculateNewPosition(position, 1, color);

      if (next == invalidMove) {
        return [];
      }

      position = next;
      path.add(position);

      if (position == targetWin) break;
    }

    if (path.length != roll) return [];

    return path;
  }

  static bool isSafePosition(int localPosition, PlayerColor color) {
    if (localPosition < 0 || localPosition >= totalPathCells) {
      return false;
    }

    return safeAbsoluteSpots.contains(
      getAbsolutePosition(localPosition, color),
    );
  }

  static bool processCaptures(
    PlayerColor activeColor,
    int movedTokenId,
    Map<PlayerColor, List<TokenModel>> allTokens,
  ) {
    final activeTokens = allTokens[activeColor];

    if (activeTokens == null ||
        movedTokenId < 0 ||
        movedTokenId >= activeTokens.length) {
      return false;
    }

    final activeToken = activeTokens[movedTokenId];

    if (activeToken.position < 0 ||
        activeToken.position >= totalPathCells) {
      return false;
    }

    if (isSafePosition(activeToken.position, activeColor)) {
      return false;
    }

    final absolutePosition =
        getAbsolutePosition(activeToken.position, activeColor);

    bool captured = false;

    for (final entry in allTokens.entries) {
      if (entry.key == activeColor) continue;

      for (final enemy in entry.value) {
        if (enemy.position < 0 || enemy.position >= totalPathCells) {
          continue;
        }

        final enemyAbsolute =
            getAbsolutePosition(enemy.position, entry.key);

        if (enemyAbsolute == absolutePosition) {
          enemy.position = -1;
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
// BOARD GEOMETRY - 52 UNIQUE TRACK CELLS
// ============================================================================

class LudoBoardGeometry {
  static final List<Offset> track = _createTrack();

  static List<Offset> _createTrack() {
    final p = <Offset>[];

    // Left upper vertical
    for (int y = 1; y <= 5; y++) {
      p.add(Offset(6, y.toDouble()));
    }

    // Left upper horizontal
    for (int x = 5; x >= 0; x--) {
      p.add(Offset(x.toDouble(), 6));
    }

    p.add(const Offset(0, 7));
    p.add(const Offset(0, 8));

    // Left lower horizontal
    for (int x = 1; x <= 5; x++) {
      p.add(Offset(x.toDouble(), 8));
    }

    // Left lower vertical
    for (int y = 9; y <= 14; y++) {
      p.add(Offset(6, y.toDouble()));
    }

    p.add(const Offset(7, 14));
    p.add(const Offset(8, 14));

    // Right lower vertical
    for (int y = 13; y >= 9; y--) {
      p.add(Offset(8, y.toDouble()));
    }

    // Right lower horizontal
    for (int x = 9; x <= 14; x++) {
      p.add(Offset(x.toDouble(), 8));
    }

    p.add(const Offset(14, 7));
    p.add(const Offset(14, 6));

    // Right upper horizontal
    for (int x = 13; x >= 9; x--) {
      p.add(Offset(x.toDouble(), 6));
    }

    // Right upper vertical
    for (int y = 5; y >= 0; y--) {
      p.add(Offset(8, y.toDouble()));
    }

    p.add(const Offset(7, 0));
    p.add(const Offset(6, 0));

    assert(p.length == 52);
    assert(p.toSet().length == 52);

    return List.unmodifiable(p);
  }

  static Offset homePosition(
    PlayerColor color,
    int step,
    double cell,
  ) {
    switch (color) {
      case PlayerColor.green:
        return Offset(cell * 7.5, cell * (1.5 + step));

      case PlayerColor.yellow:
        return Offset(
          cell * (13.5 - step),
          cell * 7.5,
        );

      case PlayerColor.red:
        return Offset(
          cell * 7.5,
          cell * (13.5 - step),
        );

      case PlayerColor.blue:
        return Offset(
          cell * (1.5 + step),
          cell * 7.5,
        );
    }
  }

  static Offset basePosition(
    PlayerColor color,
    int index,
    double cell,
  ) {
    late double x;
    late double y;

    switch (color) {
      case PlayerColor.green:
        x = 1;
        y = 1;
        break;
      case PlayerColor.yellow:
        x = 10;
        y = 1;
        break;
      case PlayerColor.red:
        x = 10;
        y = 10;
        break;
      case PlayerColor.blue:
        x = 1;
        y = 10;
        break;
    }

    return Offset(
      cell * (x + (index % 2 == 0 ? 1 : 3)),
      cell * (y + (index < 2 ? 1 : 3)),
    );
  }
}

// ============================================================================
// LOBBY
// ============================================================================

class LudoLobbyScreen extends StatelessWidget {
  const LudoLobbyScreen({super.key});

  static const Color background = Color(0xff080D12);
  static const Color cyan = Color(0xff00E5FF);
  static const Color green = Color(0xff00E676);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: const Color(0xff05090D),
        centerTitle: true,
        title: const Text(
          'RAYID CYBER ARENA',
          style: TextStyle(
            color: cyan,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff101D28),
              Color(0xff080D12),
              Color(0xff100D20),
            ],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sports_esports_rounded,
              size: 85,
              color: cyan,
            ),
            const SizedBox(height: 20),
            const Text(
              'RAYID CYBER LUDO',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ENTER THE NEON ARENA',
              style: TextStyle(
                color: cyan,
                fontSize: 11,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 55),
            _lobbyButton(
              context,
              'FOUR PLAYERS VS AI',
              Icons.smart_toy,
              cyan,
              true,
            ),
            const SizedBox(height: 18),
            _lobbyButton(
              context,
              'LOCAL FOUR PLAYER',
              Icons.groups,
              green,
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _lobbyButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    bool ai,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff101A22),
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: color.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: color, width: 1.5),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LudoGameScreen(isVsAI: ai),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
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

  const LudoGameScreen({
    super.key,
    required this.isVsAI,
  });

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen>
    with SingleTickerProviderStateMixin {
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
  bool isMicActive = false;

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
    PlayerColor.blue: const Color(0xff448AFF),
  };

  PlayerColor get currentTurnColor => turnOrder[currentTurnIndex];

  @override
  void initState() {
    super.initState();

    _initializeTokens();

    _diceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _diceAnimation = Tween<double>(
      begin: 1,
      end: 1.22,
    ).animate(
      CurvedAnimation(
        parent: _diceController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _initializeTokens() {
    allTokens = {
      for (final color in PlayerColor.values)
        color: List.generate(
          4,
          (i) => TokenModel(id: i, color: color),
        ),
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

    setState(() {
      _initializeTokens();
      currentTurnIndex = 0;
      diceValue = 6;
      isRolling = false;
      hasRolled = false;
      isAnimatingMove = false;
      isGameOver = false;
    });
  }

  // --------------------------------------------------------------------------
  // DICE
  // --------------------------------------------------------------------------

  void rollDice() {
    if (!mounted ||
        isRolling ||
        hasRolled ||
        isAnimatingMove ||
        isGameOver) {
      return;
    }

    if (widget.isVsAI && currentTurnColor != PlayerColor.green) {
      return;
    }

    setState(() {
      isRolling = true;
    });

    _diceController.forward().then((_) {
      if (mounted) _diceController.reverse();
    });

    _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted || isGameOver) return;

      setState(() {
        diceValue = _random.nextInt(6) + 1;
        isRolling = false;
        hasRolled = true;
      });

      final legalMoves = LudoEngine.getLegalMoves(
        allTokens[currentTurnColor]!,
        diceValue,
      );

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

    setState(() {
      hasRolled = false;
    });

    if (rolledSix) {
      _setStatus('لا توجد حركة. حصل اللاعب على رمية إضافية!');
      _scheduleAITurnIfNeeded();
    } else {
      _setStatus('لا توجد حركة ممكنة. ينتقل الدور.');
      _timer?.cancel();

      _timer = Timer(const Duration(milliseconds: 1000), () {
        if (mounted && !isGameOver) _nextTurn();
      });
    }
  }

  // --------------------------------------------------------------------------
  // TOKEN MOVEMENT
  // --------------------------------------------------------------------------

  void selectToken(PlayerColor color, int tokenId) {
    if (!mounted ||
        !hasRolled ||
        color != currentTurnColor ||
        isAnimatingMove ||
        isGameOver) {
      return;
    }

    if (widget.isVsAI && color != PlayerColor.green) return;

    final tokens = allTokens[color]!;
    final legalMoves = LudoEngine.getLegalMoves(tokens, diceValue);

    if (!legalMoves.contains(tokenId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('هذه الحركة غير قانونية'),
          duration: Duration(milliseconds: 700),
        ),
      );
      return;
    }

    final steps = LudoEngine.getStepByStepPath(
      tokens[tokenId].position,
      diceValue,
      color,
    );

    if (steps.isEmpty) return;

    _timer?.cancel();

    setState(() {
      hasRolled = false;
      isAnimatingMove = true;
    });

    _animateToken(
      color,
      tokenId,
      steps,
      0,
      diceValue,
    );
  }

  void _animateToken(
    PlayerColor color,
    int tokenId,
    List<int> steps,
    int index,
    int totalRoll,
  ) {
    if (!mounted || isGameOver) return;

    if (index >= steps.length) {
      _finishMove(color, tokenId, totalRoll);
      return;
    }

    setState(() {
      allTokens[color]![tokenId].position = steps[index];
    });

    _timer = Timer(const Duration(milliseconds: 180), () {
      if (mounted) {
        _animateToken(
          color,
          tokenId,
          steps,
          index + 1,
          totalRoll,
        );
      }
    });
  }

  void _finishMove(
    PlayerColor color,
    int tokenId,
    int totalRoll,
  ) {
    final captured = LudoEngine.processCaptures(
      color,
      tokenId,
      allTokens,
    );

    final won = LudoEngine.hasWon(allTokens[color]!);

    setState(() {
      isAnimatingMove = false;
      hasRolled = false;
    });

    if (won) {
      _declareWinner(color);
      return;
    }

    if (captured) {
      _setStatus('تم إسقاط حجر الخصم وإعادته إلى القاعدة!');
    } else if (totalRoll == 6) {
      _setStatus('رمية ممتازة! لديك رمية إضافية.');
    }

    if (totalRoll == 6) {
      _scheduleAITurnIfNeeded();
    } else {
      _nextTurn();
    }
  }

  // --------------------------------------------------------------------------
  // AI
  // --------------------------------------------------------------------------

  void _executeAIMove(List<int> legalMoves) {
    _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 800), () {
      if (!mounted || isGameOver || !hasRolled) return;

      final color = currentTurnColor;
      final tokens = allTokens[color]!;

      int selected = legalMoves.first;
      int bestScore = -999999;

      for (final index in legalMoves) {
        final token = tokens[index];

        final newPosition = LudoEngine.calculateNewPosition(
          token.position,
          diceValue,
          color,
        );

        int score = 0;

        // Winning move
        if (newPosition == LudoEngine.targetWin) {
          score += 10000;
        }

        // Capturing an opponent
        if (newPosition >= 0 && newPosition < 52) {
          final absolute = LudoEngine.getAbsolutePosition(
            newPosition,
            color,
          );

          final safe =
              LudoEngine.safeAbsoluteSpots.contains(absolute);

          if (!safe) {
            for (final entry in allTokens.entries) {
              if (entry.key == color) continue;

              for (final enemy in entry.value) {
                if (enemy.position >= 0 &&
                    enemy.position < 52) {
                  final enemyAbsolute =
                      LudoEngine.getAbsolutePosition(
                    enemy.position,
                    entry.key,
                  );

                  if (enemyAbsolute == absolute) {
                    score += 500;
                  }
                }
              }
            }
          }

          if (LudoEngine.isSafePosition(newPosition, color)) {
            score += 80;
          }
        }

        // Leave base
        if (token.position == -1) {
          score += 120;
        }

        // Progress
        if (token.position >= 0 && token.position < 58) {
          score += newPosition - token.position;
        }

        if (diceValue == 6) score += 10;

        score += _random.nextInt(5);

        if (score > bestScore) {
          bestScore = score;
          selected = index;
        }
      }

      selectToken(color, selected);
    });
  }

  void _scheduleAITurnIfNeeded() {
    if (!widget.isVsAI ||
        currentTurnColor == PlayerColor.green ||
        isGameOver) {
      return;
    }

    _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 900), () {
      if (mounted && !isGameOver) rollDice();
    });
  }

  // --------------------------------------------------------------------------
  // TURN MANAGEMENT
  // --------------------------------------------------------------------------

  void _nextTurn() {
    if (!mounted || isGameOver) return;

    setState(() {
      currentTurnIndex =
          (currentTurnIndex + 1) % turnOrder.length;

      hasRolled = false;
      isRolling = false;
      isAnimatingMove = false;
    });

    _scheduleAITurnIfNeeded();
  }

  void _setStatus(String message) {
    if (!mounted) return;

    setState(() {
      _statusMessage = message;
    });
  }

  String _statusMessage = 'دور اللاعب الأخضر - ارمِ النرد';

  void _declareWinner(PlayerColor color) {
    setState(() {
      isGameOver = true;
      hasRolled = false;
      isAnimatingMove = false;
      _statusMessage = 'فاز ${playerNames[color]} بالمعركة!';
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xff111B24),
          title: const Text(
            '🏆 CYBER VICTORY',
            style: TextStyle(
              color: Color(0xff00E5FF),
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            'الفائز هو ${playerNames[color]}!',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('القائمة الرئيسية'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                resetGame();
              },
              child: const Text('إعادة اللعب'),
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------------------------------
  // BOARD TOKEN COORDINATES
  // --------------------------------------------------------------------------

  Offset _tokenCoordinate(
    TokenModel token,
    int index,
    double cell,
  ) {
    if (token.position == -1) {
      return LudoBoardGeometry.basePosition(
        token.color,
        index,
        cell,
      );
    }

    if (token.position == LudoEngine.targetWin) {
      return Offset(
        cell * (6.8 + (index % 2) * 0.4),
        cell * (6.8 + (index ~/ 2) * 0.4),
      );
    }

    if (token.position >= 52 && token.position <= 57) {
      return LudoBoardGeometry.homePosition(
        token.color,
        token.position - 52,
        cell,
      );
    }

    final absolute = LudoEngine.getAbsolutePosition(
      token.position,
      token.color,
    );

    final base = LudoBoardGeometry.track[absolute];

    return Offset(
      (base.dx + 0.5) * cell,
      (base.dy + 0.5) * cell,
    );
  }

  // --------------------------------------------------------------------------
  // MAIN UI
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final activeColor = playerColors[currentTurnColor]!;

    return Scaffold(
      backgroundColor: const Color(0xff080D12),
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
                      color: const Color(0xff080B12),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xff00E5FF),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff00E5FF)
                              .withOpacity(0.18),
                          blurRadius: 22,
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
                              child: CustomPaint(
                                painter: CyberBoardPainter(
                                  LudoBoardGeometry.track,
                                ),
                              ),
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
        color: Color(0xff05090D),
        border: Border(
          bottom: BorderSide(
            color: Color(0xff00E5FF),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.sports_esports,
            color: Color(0xff00E676),
          ),
          const Text(
            'RAYID CYBER ARENA',
            style: TextStyle(
              color: Color(0xff00E5FF),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              fontSize: 13,
            ),
          ),
          IconButton(
            onPressed: resetGame,
            icon: const Icon(
              Icons.refresh,
              color: Color(0xff00E676),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorial() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff12221D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xff00E676),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: Color(0xff00E676),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'ارمِ النرد، ثم اختر أحد أحجارك المسموح بتحريكها.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() => showTutorial = false);
            },
            child: const Text(
              'إغلاق',
              style: TextStyle(
                color: Color(0xff00E5FF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff111923),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xff00E5FF).withOpacity(0.3),
        ),
      ),
      child: Text(
        _statusMessage,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  List<Widget> _buildTokens(double boardSize, double cell) {
    final widgets = <Widget>[];

    for (final color in PlayerColor.values) {
      final tokens = allTokens[color]!;

      for (int i = 0; i < tokens.length; i++) {
        final token = tokens[i];
        final coordinate = _tokenCoordinate(token, i, cell);
        final colorValue = playerColors[color]!;

        final isSelectable =
            hasRolled &&
            currentTurnColor == color &&
            !isAnimatingMove &&
            !isGameOver &&
            LudoEngine.getLegalMoves(
              tokens,
              diceValue,
            ).contains(i);

        widgets.add(
          Positioned(
            left: coordinate.dx - 12,
            top: coordinate.dy - 12,
            child: GestureDetector(
              onTap: () => selectToken(color, i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white,
                      colorValue,
                      colorValue.withOpacity(0.65),
                    ],
                  ),
                  border: Border.all(
                    color: isSelectable
                        ? Colors.white
                        : Colors.white70,
                    width: isSelectable ? 2.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorValue.withOpacity(
                        isSelectable ? 0.9 : 0.5,
                      ),
                      blurRadius: isSelectable ? 13 : 6,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    token.position == -1
                        ? 'H'
                        : token.position == 58
                            ? '★'
                            : '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
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

  Widget _buildBottomControls(Color activeColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 12, 15, 16),
      decoration: const BoxDecoration(
        color: Color(0xff05090D),
        border: Border(
          top: BorderSide(
            color: Color(0xff00E5FF),
            width: 0.8,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activeColor.withOpacity(0.15),
                  border: Border.all(
                    color: activeColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.person,
                  color: activeColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'دور ${playerNames[currentTurnColor]}',
                  style: TextStyle(
                    color: activeColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isMicActive = !isMicActive;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isMicActive
                            ? 'تم تفعيل مؤشر الميكروفون المحلي'
                            : 'تم إيقاف مؤشر الميكروفون المحلي',
                      ),
                      duration: const Duration(milliseconds: 700),
                    ),
                  );
                },
                icon: Icon(
                  isMicActive ? Icons.mic : Icons.mic_off,
                  color: isMicActive
                      ? const Color(0xff00E676)
                      : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xff111923),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: activeColor,
                    width: 2,
                  ),
                ),
                child: Text(
                  '$diceValue',
                  style: TextStyle(
                    color: activeColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ScaleTransition(
                  scale: _diceAnimation,
                  child: ElevatedButton(
                    onPressed: (
                      !isRolling &&
                      !hasRolled &&
                      !isAnimatingMove &&
                      !isGameOver &&
                      (!widget.isVsAI ||
                          currentTurnColor == PlayerColor.green)
                    )
                        ? rollDice
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeColor,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Text(
                      isRolling
                          ? 'جاري رمي النرد...'
                          : hasRolled
                              ? 'اختر الحجر المناسب'
                              : '🎲 ارمِ النرد',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
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
// CYBERPUNK BOARD PAINTER
// ============================================================================

class CyberBoardPainter extends CustomPainter {
  final List<Offset> path;

  CyberBoardPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / 15;

    final background = Paint()
      ..color = const Color(0xff080D14);

    canvas.drawRect(
      Offset.zero & size,
      background,
    );

    // Futuristic grid
    final gridPaint = Paint()
      ..color = const Color(0xff00E5FF).withOpacity(0.10)
      ..strokeWidth = 0.7;

    for (int i = 0; i <= 15; i++) {
      canvas.drawLine(
        Offset(i * cell, 0),
        Offset(i * cell, size.height),
        gridPaint,
      );

      canvas.drawLine(
        Offset(0, i * cell),
        Offset(size.width, i * cell),
        gridPaint,
      );
    }

    _drawBase(
      canvas,
      Rect.fromLTWH(0, 0, cell * 6, cell * 6),
      const Color(0xff00E676),
    );

    _drawBase(
      canvas,
      Rect.fromLTWH(cell * 9, 0, cell * 6, cell * 6),
      const Color(0xffFFD740),
    );

    _drawBase(
      canvas,
      Rect.fromLTWH(cell * 9, cell * 9, cell * 6, cell * 6),
      const Color(0xffFF5252),
    );

    _drawBase(
      canvas,
      Rect.fromLTWH(0, cell * 9, cell * 6, cell * 6),
      const Color(0xff448AFF),
    );

    // Shared track
    final trackPaint = Paint()
      ..color = const Color(0xff15232D)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xff00E5FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    for (int i = 0; i < path.length; i++) {
      final point = path[i];

      final rect = Rect.fromLTWH(
        point.dx * cell + 1,
        point.dy * cell + 1,
        cell - 2,
        cell - 2,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect,
          const Radius.circular(3),
        ),
        trackPaint,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect,
          const Radius.circular(3),
        ),
        borderPaint,
      );

      if (LudoEngine.safeAbsoluteSpots.contains(i)) {
        final safePaint = Paint()
          ..color = const Color(0xff00E676).withOpacity(0.55);

        canvas.drawCircle(
          rect.center,
          cell * 0.15,
          safePaint,
        );
      }
    }

    // Home lanes
    _drawHomeLane(
      canvas,
      cell,
      const Color(0xff00E676),
      true,
    );

    _drawHomeLane(
      canvas,
      cell,
      const Color(0xffFFD740),
      false,
    );

    // Center arena
    final centerRect = Rect.fromLTWH(
      cell * 6,
      cell * 6,
      cell * 3,
      cell * 3,
    );

    final centerPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xff00E676),
          Color(0xff00E5FF),
          Color(0xff7C4DFF),
          Color(0xffFF5252),
        ],
      ).createShader(centerRect);

    canvas.drawRect(centerRect, centerPaint);

    final centerBorder = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRect(centerRect, centerBorder);

    final centerText = TextPainter(
      text: const TextSpan(
        text: 'RAYID',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    centerText.layout();
    centerText.paint(
      canvas,
      Offset(
        centerRect.center.dx - centerText.width / 2,
        centerRect.center.dy - centerText.height / 2,
      ),
    );
  }

  void _drawBase(
    Canvas canvas,
    Rect rect,
    Color color,
  ) {
    final fill = Paint()
      ..color = color.withOpacity(0.18);

    final border = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.deflate(2),
        const Radius.circular(9),
      ),
      fill,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.deflate(2),
        const Radius.circular(9),
      ),
      border,
    );

    final inner = Paint()
      ..color = color.withOpacity(0.12);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.deflate(rect.width * 0.17),
        const Radius.circular(12),
      ),
      inner,
    );
  }

  void _drawHomeLane(
    Canvas canvas,
    double cell,
    Color color,
    bool vertical,
  ) {
    final paint = Paint()
      ..color = color.withOpacity(0.30);

    for (int i = 0; i < 6; i++) {
      final rect = vertical
          ? Rect.fromLTWH(
              cell * 6.5,
              cell * (i + 1),
              cell,
              cell,
            )
          : Rect.fromLTWH(
              cell * (i + 1),
              cell * 6.5,
              cell,
              cell,
            );

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CyberBoardPainter oldDelegate) {
    return false;
  }
}
