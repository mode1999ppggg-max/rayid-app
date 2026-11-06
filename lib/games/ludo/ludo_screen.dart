// ==============================================================================
// ملف اللعبة المتكامل والمطور: lib/games/ludo/ludo_screen.dart
// مشروع RAYID PAY – CYBERPUNK LUDO ARENA
// الإصدار المحسّن بصرياً (سايبربانك كامل)
// ==============================================================================

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// ------------------------------------------------------------------------------
// 0. شاشة الدخول والتحميل
// ------------------------------------------------------------------------------

class LudoSplashLoadingScreen extends StatefulWidget {
  const LudoSplashLoadingScreen({super.key});

  @override
  State<LudoSplashLoadingScreen> createState() => _LudoSplashLoadingScreenState();
}

class _LudoSplashLoadingScreenState extends State<LudoSplashLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  double _loadingProgress = 0.0;
  Timer? _loadTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.forward();

    _loadTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        _loadingProgress += 0.03;
        if (_loadingProgress >= 1.0) {
          _loadingProgress = 1.0;
          timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LudoGameScreen()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _loadTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xff060911),
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.8,
              colors: [Color(0xff131c2e), Color(0xff060911)],
            ),
          ),
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xff00f3ff), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff00f3ff).withOpacity(0.6),
                          blurRadius: 25,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.casino_rounded, size: 64, color: Color(0xffffcc00)),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'RAYID PAY',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff00f3ff),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'CYBERPUNK LUDO ARENA',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 220,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _loadingProgress,
                        backgroundColor: const Color(0xff1a263f),
                        color: const Color(0xffff3366),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'جاري مزامنة إحداثيات المسارات بدقة تامة... ${(_loadingProgress * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------------------
// 1. نماذج البيانات
// ------------------------------------------------------------------------------

enum LudoColor { red, green, blue, yellow }

class LudoPlayer {
  final LudoColor color;
  final Color uiColor;
  final String name;
  final int baseStartIndex;
  final int baseIndexForCoords;
  final int entryBeforeHome;

  List<int> tokenPositions = [-1, -1, -1, -1];

  LudoPlayer({
    required this.color,
    required this.uiColor,
    required this.name,
    required this.baseStartIndex,
    required this.baseIndexForCoords,
    required this.entryBeforeHome,
  });

  bool get hasWon => tokenPositions.every((pos) => pos == 58);
  int get finishedCount => tokenPositions.where((pos) => pos == 58).length;
}
// ------------------------------------------------------------------------------
// 2. محرك اللعبة
// ------------------------------------------------------------------------------

class LudoGameController extends ChangeNotifier {
  int totalPlayersCount;
  late List<LudoPlayer> players;

  int currentTurnIndex = 0;
  int diceValue = 0;
  bool hasRolled = false;
  bool isGameOver = false;
  bool isRolling = false;
  bool isAnimatingMove = false;
  bool _isDisposed = false;
  String gameMessage = "مرحباً بك في RAYID PAY LUDO ARENA! دور اللاعب الأحمر.";

  int gameSessionId = 0;

  Timer? _turnTimer;
  Timer? _diceTimer;

  final Set<int> safePositions = {0, 8, 13, 21, 26, 34, 39, 47};

  LudoGameController({this.totalPlayersCount = 4}) {
    _initPlayers();
  }

  void _initPlayers() {
    List<LudoPlayer> allPlayers = [
      LudoPlayer(color: LudoColor.red, uiColor: const Color(0xffff3366), name: 'الأحمر', baseStartIndex: 0, baseIndexForCoords: 0, entryBeforeHome: 50),
      LudoPlayer(color: LudoColor.green, uiColor: const Color(0xff00ff66), name: 'الأخضر', baseStartIndex: 13, baseIndexForCoords: 1, entryBeforeHome: 11),
      LudoPlayer(color: LudoColor.blue, uiColor: const Color(0xff00f3ff), name: 'الأزرق', baseStartIndex: 26, baseIndexForCoords: 2, entryBeforeHome: 24),
      LudoPlayer(color: LudoColor.yellow, uiColor: const Color(0xffffcc00), name: 'الأصفر', baseStartIndex: 39, baseIndexForCoords: 3, entryBeforeHome: 37),
    ];

    if (totalPlayersCount == 2) {
      players = [allPlayers[0], allPlayers[2]];
    } else if (totalPlayersCount == 3) {
      players = [allPlayers[0], allPlayers[1], allPlayers[2]];
    } else {
      players = allPlayers;
    }
  }

  void setPlayersCount(int count) {
    if (count >= 2 && count <= 4) {
      totalPlayersCount = count;
      resetGame();
    }
  }

  LudoPlayer get currentTurnPlayer => players[currentTurnIndex];

  @override
  void dispose() {
    _isDisposed = true;
    _cancelAllTimers();
    super.dispose();
  }

  void _cancelAllTimers() {
    _turnTimer?.cancel();
    _diceTimer?.cancel();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) super.notifyListeners();
  }

  void rollDice() {
    if (hasRolled || isGameOver || isRolling || isAnimatingMove || _isDisposed) return;

    isRolling = true;
    gameMessage = "جاري رمي النرد الإلكتروني...";
    notifyListeners();

    int currentSession = gameSessionId;
    int counter = 0;
    _diceTimer?.cancel();
    _diceTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (isGameOver || gameSessionId != currentSession || _isDisposed) {
        timer.cancel();
        return;
      }
      diceValue = Random().nextInt(6) + 1;
      counter++;
      notifyListeners();
      if (counter > 12) {
        timer.cancel();
        if (gameSessionId != currentSession || _isDisposed) return;
        isRolling = false;
        hasRolled = true;
        _evaluateRolledValue(currentSession);
      }
    });
  }

  int _calculateSingleStep(int currentPos, LudoPlayer player) {
    if (currentPos == -1) return player.baseStartIndex;
    if (currentPos == 58) return 58;

    if (currentPos < 52) {
      if (currentPos == player.entryBeforeHome) return 52;
      return (currentPos + 1) % 52;
    } else if (currentPos >= 52 && currentPos < 58) {
      return currentPos + 1;
    }
    return currentPos;
  }

  int simulateMovement(int currentPos, int steps, LudoPlayer player) {
    if (currentPos == -1) {
      if (steps == 6) return player.baseStartIndex;
      return -1;
    }

    int pos = currentPos;
    for (int s = 0; s < steps; s++) {
      pos = _calculateSingleStep(pos, player);
      if (pos > 58) return -1;
    }

    if (pos == 58) {
      int remainingStepsToHome = 0;
      int tempPos = currentPos;
      while (tempPos != 58 && remainingStepsToHome <= 6) {
        tempPos = _calculateSingleStep(tempPos, player);
        remainingStepsToHome++;
      }
      if (steps != remainingStepsToHome) return -1;
    }
    return pos;
  }

  bool isValidMove(int playerIndex, int tokenIndex, int steps) {
    if (playerIndex < 0 || playerIndex >= players.length || isGameOver) return false;
    LudoPlayer player = players[playerIndex];
    if (tokenIndex < 0 || tokenIndex >= player.tokenPositions.length) return false;
    int pos = player.tokenPositions[tokenIndex];
    if (pos == 58) return false;

    if (pos == -1) {
      if (steps != 6) return false;
      int startPos = player.baseStartIndex;
      for (int p in player.tokenPositions) {
        if (p == startPos) return false;
      }
      return true;
    }

    int targetPos = simulateMovement(pos, steps, player);
    if (targetPos == -1 || targetPos > 58) return false;
    return true;
  }

  void _evaluateRolledValue(int currentSession) {
    if (gameSessionId != currentSession || _isDisposed) return;

    bool canMove = false;
    for (int t = 0; t < currentTurnPlayer.tokenPositions.length; t++) {
      if (isValidMove(currentTurnIndex, t, diceValue)) {
        canMove = true;
        break;
      }
    }

    if (!canMove) {
      gameMessage = "لاعب ${currentTurnPlayer.name}: لا توجد حركات قانونية لهذه النتيجة ($diceValue)! جاري نقل الدور...";
      notifyListeners();
      _turnTimer?.cancel();
      _turnTimer = Timer(const Duration(seconds: 2), () {
        if (!isGameOver && gameSessionId == currentSession && !_isDisposed) {
          _nextTurn();
        }
      });
    } else {
      gameMessage = "لاعب ${currentTurnPlayer.name} رمى ($diceValue). اضغط على الحجر المضيء لتحريكه.";
      notifyListeners();
    }
  }

  bool isTokenMovable(int playerIndex, int tokenIndex) {
    if (!hasRolled || isGameOver || isRolling || isAnimatingMove || _isDisposed) return false;
    if (playerIndex != currentTurnIndex) return false;
    return isValidMove(playerIndex, tokenIndex, diceValue);
  }

  Future<void> moveToken(int playerIndex, int tokenIndex) async {
    if (!isTokenMovable(playerIndex, tokenIndex)) return;

    LudoPlayer player = players[playerIndex];
    int currentPos = player.tokenPositions[tokenIndex];
    int simulatedTarget = simulateMovement(currentPos, diceValue, player);
    if (simulatedTarget == -1) return;

    isAnimatingMove = true;
    gameMessage = "جاري تحريك الحجر خطوة بخطوة...";
    notifyListeners();

    int currentSession = gameSessionId;

    if (currentPos == -1) {
      int startPos = player.baseStartIndex;
      bool captured = _captureCheck(startPos, playerIndex);

      if (gameSessionId != currentSession || _isDisposed) {
        isAnimatingMove = false;
        return;
      }

      player.tokenPositions[tokenIndex] = startPos;
      bool extraTurn = (diceValue == 6) || captured;

      await Future.delayed(const Duration(milliseconds: 300));
      if (gameSessionId != currentSession || _isDisposed) {
        isAnimatingMove = false;
        return;
      }
      isAnimatingMove = false;
      _finalizeMove(extraTurn: extraTurn, currentSession: currentSession);
      return;
    }

    int steps = diceValue;
    for (int s = 0; s < steps; s++) {
      if (gameSessionId != currentSession || _isDisposed) {
        isAnimatingMove = false;
        return;
      }
      if (player.tokenPositions[tokenIndex] == 58) break;

      int nextPos = _calculateSingleStep(player.tokenPositions[tokenIndex], player);
      if (nextPos == -1 || nextPos > 58) break;
      player.tokenPositions[tokenIndex] = nextPos;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 160));
    }

    if (gameSessionId != currentSession || _isDisposed) {
      isAnimatingMove = false;
      return;
    }

    int finalPos = player.tokenPositions[tokenIndex];
    bool captured = false;
    if (finalPos < 52) {
      captured = _captureCheck(finalPos, playerIndex);
    }

    if (gameSessionId != currentSession || _isDisposed) {
      isAnimatingMove = false;
      return;
    }

    if (player.hasWon) {
      isGameOver = true;
      gameMessage = "تهانينا! فاز اللاعب ${player.name} بالبطولة الكبرى!";
      isAnimatingMove = false;
      notifyListeners();
      return;
    }

    bool extraTurn = (diceValue == 6) || captured;
    isAnimatingMove = false;
    _finalizeMove(extraTurn: extraTurn, currentSession: currentSession);
  }

  bool _captureCheck(int targetPos, int moverPlayerIndex) {
    if (targetPos >= 52 || safePositions.contains(targetPos)) return false;

    bool didCapture = false;
    for (int p = 0; p < players.length; p++) {
      if (p == moverPlayerIndex) continue;
      for (int t = 0; t < players[p].tokenPositions.length; t++) {
        int enemyPos = players[p].tokenPositions[t];
        if (enemyPos == targetPos && enemyPos < 52) {
          players[p].tokenPositions[t] = -1;
          didCapture = true;
          gameMessage = "تم القضاء على حجر اللاعب ${players[p].name} وإرجاعه لقاعدته!";
        }
      }
    }
    return didCapture;
  }

  void _finalizeMove({bool extraTurn = false, required int currentSession}) {
    if (gameSessionId != currentSession || _isDisposed || isGameOver) return;
    hasRolled = false;
    if (extraTurn) {
      gameMessage += " (حصلت على رمية إضافية استحقاقاً!)";
      notifyListeners();
    } else {
      _nextTurn();
    }
  }

  void _nextTurn() {
    if (_isDisposed || isGameOver) return;
    currentTurnIndex = (currentTurnIndex + 1) % players.length;
    diceValue = 0;
    hasRolled = false;
    gameMessage = "دور اللاعب: ${currentTurnPlayer.name} - اضغط لرمي النرد.";
    notifyListeners();
  }

  void resetGame() {
    gameSessionId++;
    _cancelAllTimers();
    isAnimatingMove = false;
    _initPlayers();
    currentTurnIndex = 0;
    diceValue = 0;
    hasRolled = false;
    isGameOver = false;
    isRolling = false;
    gameMessage = "بدأت مباراة جديدة. دور اللاعب ${players[0].name}.";
    notifyListeners();
  }
}
// ------------------------------------------------------------------------------
// 3. إحداثيات اللوحة
// ------------------------------------------------------------------------------

final List<Point<int>> sharedTrackCoords = [
  const Point(1, 6), const Point(2, 6), const Point(3, 6), const Point(4, 6), const Point(5, 6),
  const Point(6, 5), const Point(6, 4), const Point(6, 3), const Point(6, 2), const Point(6, 1), const Point(6, 0),
  const Point(7, 0),
  const Point(8, 0), const Point(8, 1), const Point(8, 2), const Point(8, 3), const Point(8, 4), const Point(8, 5),
  const Point(9, 6), const Point(10, 6), const Point(11, 6), const Point(12, 6), const Point(13, 6), const Point(14, 6),
  const Point(14, 7),
  const Point(14, 8), const Point(13, 8), const Point(12, 8), const Point(11, 8), const Point(10, 8), const Point(9, 8),
  const Point(8, 9), const Point(8, 10), const Point(8, 11), const Point(8, 12), const Point(8, 13), const Point(8, 14),
  const Point(7, 14),
  const Point(6, 14), const Point(6, 13), const Point(6, 12), const Point(6, 11), const Point(6, 10), const Point(6, 9),
  const Point(5, 8), const Point(4, 8), const Point(3, 8), const Point(2, 8), const Point(1, 8), const Point(0, 8),
  const Point(0, 7),
  const Point(0, 6),
];

// ------------------------------------------------------------------------------
// 4. رسام اللوحة السايبربانك المتطور
// ------------------------------------------------------------------------------

class LudoBoardPainter extends CustomPainter {
  final List<LudoPlayer> players;

  LudoBoardPainter({required this.players});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    double w = size.width;
    double h = size.height;
    double cellSize = w / 15;

    // خلفية
    paint.color = const Color(0xff05080f);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);

    // شبكة دوائر كهربائية
    final circuitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = const Color(0xff0a1a2f);

    for (double i = 0; i < w; i += cellSize * 1.5) {
      canvas.drawLine(Offset(i, 0), Offset(i, h), circuitPaint);
      canvas.drawLine(Offset(0, i), Offset(w, i), circuitPaint);
    }

    final neonCircuit = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = const Color(0xff00f3ff).withOpacity(0.13);

    for (int i = 0; i < 9; i++) {
      double pos = cellSize * (1.5 + i * 1.4);
      canvas.drawLine(Offset(0, pos), Offset(w, pos), neonCircuit);
      canvas.drawLine(Offset(pos, 0), Offset(pos, h), neonCircuit);
    }

    // القواعد الأربع
    _drawCyberPanel(canvas, 0, 0, cellSize * 6, const Color(0xff00ff66), const Color(0xff00ffaa)); // أخضر
    _drawCyberPanel(canvas, cellSize * 9, 0, cellSize * 6, const Color(0xffff3366), const Color(0xffff6699)); // أحمر
    _drawCyberPanel(canvas, 0, cellSize * 9, cellSize * 6, const Color(0xff00f3ff), const Color(0xff66f0ff)); // أزرق
    _drawCyberPanel(canvas, cellSize * 9, cellSize * 9, cellSize * 6, const Color(0xffffcc00), const Color(0xffffee55)); // أصفر

    // المسار المشترك
    for (int i = 0; i < sharedTrackCoords.length; i++) {
      var pt = sharedTrackCoords[i];
      Color cellColor = const Color(0xff0c1220);
      Color borderColor = const Color(0xff1a253a);

      if (i == 0) {
        cellColor = const Color(0xffff3366).withOpacity(0.45);
        borderColor = const Color(0xffff3366);
      } else if (i == 13) {
        cellColor = const Color(0xff00ff66).withOpacity(0.45);
        borderColor = const Color(0xff00ff66);
      } else if (i == 26) {
        cellColor = const Color(0xff00f3ff).withOpacity(0.45);
        borderColor = const Color(0xff00f3ff);
      } else if (i == 39) {
        cellColor = const Color(0xffffcc00).withOpacity(0.45);
        borderColor = const Color(0xffffcc00);
      } else if ({8, 21, 34, 47}.contains(i)) {
        cellColor = const Color(0xff152238);
        borderColor = const Color(0xff38bdf8);
      }

      paint.style = PaintingStyle.fill;
      paint.color = cellColor;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(pt.x * cellSize + 1.5, pt.y * cellSize + 1.5, cellSize - 3, cellSize - 3),
          const Radius.circular(3),
        ),
        paint,
      );

      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1.3;
      paint.color = borderColor;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(pt.x * cellSize + 1.5, pt.y * cellSize + 1.5, cellSize - 3, cellSize - 3),
          const Radius.circular(3),
        ),
        paint,
      );
    }

    // ممرات البيت
    for (int step = 0; step < 5; step++) {
      _drawNeonCell(canvas, (1 + step) * cellSize, 7 * cellSize, cellSize, const Color(0xffff3366));
      _drawNeonCell(canvas, 7 * cellSize, (1 + step) * cellSize, cellSize, const Color(0xff00ff66));
      _drawNeonCell(canvas, (13 - step) * cellSize, 7 * cellSize, cellSize, const Color(0xff00f3ff));
      _drawNeonCell(canvas, 7 * cellSize, (13 - step) * cellSize, cellSize, const Color(0xffffcc00));
    }

    // المركز المتوهج
    final centerRect = Rect.fromLTWH(cellSize * 6, cellSize * 6, cellSize * 3, cellSize * 3);

    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xff080c16);
    canvas.drawRRect(RRect.fromRectAndRadius(centerRect, const Radius.circular(6)), paint);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = const Color(0xff00f3ff).withOpacity(0.65)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawRRect(RRect.fromRectAndRadius(centerRect.deflate(1), const Radius.circular(5)), glowPaint);

    final xPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..color = const Color(0xff00f3ff);

    canvas.drawLine(Offset(cellSize * 6.3, cellSize * 6.3), Offset(cellSize * 8.7, cellSize * 8.7), xPaint);
    canvas.drawLine(Offset(cellSize * 8.7, cellSize * 6.3), Offset(cellSize * 6.3, cellSize * 8.7), xPaint);

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..color = const Color(0xffff00aa).withOpacity(0.7);
    canvas.drawRRect(RRect.fromRectAndRadius(centerRect, const Radius.circular(6)), borderPaint);

    // النجوم
    _drawStar(canvas, cellSize * 7.5, cellSize * 0.7, cellSize * 0.32, const Color(0xff00f3ff));
    _drawStar(canvas, cellSize * 0.7, cellSize * 7.5, cellSize * 0.32, const Color(0xff00ff66));
    _drawStar(canvas, cellSize * 14.3, cellSize * 7.5, cellSize * 0.32, const Color(0xffff3366));
    _drawStar(canvas, cellSize * 7.5, cellSize * 14.3, cellSize * 0.32, const Color(0xffffcc00));
  }

  void _drawCyberPanel(Canvas canvas, double x, double y, double size, Color mainColor, Color accentColor) {
    final paint = Paint();

    paint.style = PaintingStyle.fill;
    paint.color = mainColor.withOpacity(0.13);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x, y, size, size), const Radius.circular(10)),
      paint,
    );

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.8;
    paint.color = mainColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x + 1, y + 1, size - 2, size - 2), const Radius.circular(9)),
      paint,
    );

    paint.strokeWidth = 1.5;
    paint.color = accentColor.withOpacity(0.65);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x + 9, y + 9, size - 18, size - 18), const Radius.circular(6)),
      paint,
    );

    final dotPaint = Paint()..style = PaintingStyle.fill;
    List<Offset> dots = [
      Offset(x + size * 0.28, y + size * 0.28),
      Offset(x + size * 0.72, y + size * 0.28),
      Offset(x + size * 0.28, y + size * 0.72),
      Offset(x + size * 0.72, y + size * 0.72),
    ];

    for (var dot in dots) {
      dotPaint.color = accentColor.withOpacity(0.4);
      canvas.drawCircle(dot, size * 0.09, dotPaint);
      dotPaint.color = accentColor;
      canvas.drawCircle(dot, size * 0.055, dotPaint);
    }
  }

  void _drawNeonCell(Canvas canvas, double x, double y, double size, Color color) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = color.withOpacity(0.55);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x + 1.5, y + 1.5, size - 3, size - 3), const Radius.circular(3)),
      paint,
    );

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.5;
    paint.color = color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x + 1.5, y + 1.5, size - 3, size - 3), const Radius.circular(3)),
      paint,
    );
  }

  void _drawStar(Canvas canvas, double cx, double cy, double radius, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withOpacity(0.9);

    final path = Path();
    for (int i = 0; i < 5; i++) {
      double angle = (i * 72 - 90) * pi / 180;
      double x = cx + radius * cos(angle);
      double y = cy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      angle = ((i * 72 + 36) - 90) * pi / 180;
      x = cx + radius * 0.4 * cos(angle);
      y = cy + radius * 0.4 * sin(angle);
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);

    paint.color = color.withOpacity(0.25);
    canvas.drawCircle(Offset(cx, cy), radius * 1.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ------------------------------------------------------------------------------
// 5. حساب موقع الحجر
// ------------------------------------------------------------------------------

Offset getTokenPixelPosition(int pos, LudoPlayer player, int tokenIndex, double cellSize, List<LudoPlayer> allPlayers) {
  Point<double> gridPoint;
  int baseIdx = player.baseIndexForCoords;

  if (pos == -1) {
    double baseX = (baseIdx == 0 || baseIdx == 3) ? 9.0 : 0.0;
    double baseY = (baseIdx == 0 || baseIdx == 1) ? 0.0 : 9.0;

    List<Point<double>> baseOffsets = [
      const Point(1.25, 1.25),
      const Point(3.75, 1.25),
      const Point(1.25, 3.75),
      const Point(3.75, 3.75),
    ];
    gridPoint = Point(baseX + baseOffsets[tokenIndex].x, baseY + baseOffsets[tokenIndex].y);
  } else if (pos == 58) {
    gridPoint = const Point(7.0, 7.0);
  } else if (pos >= 52 && pos <= 57) {
    int step = pos - 52;
    if (baseIdx == 0) {
      gridPoint = Point(1.0 + step, 7.0);
    } else if (baseIdx == 1) {
      gridPoint = Point(7.0, 1.0 + step);
    } else if (baseIdx == 2) {
      gridPoint = Point(13.0 - step, 7.0);
    } else {
      gridPoint = Point(7.0, 13.0 - step);
    }
  } else {
    Point<int> pt = sharedTrackCoords[pos % 52];
    gridPoint = Point(pt.x.toDouble(), pt.y.toDouble());
  }

  double offsetX = 0;
  double offsetY = 0;
  if (pos != -1) {
    int sharingCount = 0;
    int sharingIndex = 0;
    for (int p = 0; p < allPlayers.length; p++) {
      for (int t = 0; t < allPlayers[p].tokenPositions.length; t++) {
        int otherPos = allPlayers[p].tokenPositions[t];
        bool shareSameVisualSpace = (otherPos == pos) &&
            (pos < 52 || pos == -1 || pos == 58 || (pos >= 52 && allPlayers[p] == player));
        if (shareSameVisualSpace) {
          if (allPlayers[p] == player && t == tokenIndex) {
            sharingIndex = sharingCount;
          }
          sharingCount++;
        }
      }
    }
    if (sharingCount > 1) {
      List<Offset> offsets = [
        const Offset(-5, -5),
        const Offset(5, -5),
        const Offset(-5, 5),
        const Offset(5, 5),
      ];
      offsetX = offsets[sharingIndex % 4].dx;
      offsetY = offsets[sharingIndex % 4].dy;
    }
  }

  return Offset((gridPoint.x + 0.5) * cellSize + offsetX, (gridPoint.y + 0.5) * cellSize + offsetY);
}






