// ==============================================================================
// ملف اللعبة المتكامل والمطور هندسياً: lib/games/ludo/ludo_screen.dart
// مشروع RAYID PAY – CYBERPUNK LUDO ARENA
// ==============================================================================

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// ------------------------------------------------------------------------------
// 0. شاشة الدخول والتحميل الافتتاحية (Cyberpunk Splash & Loading Screen)
// ------------------------------------------------------------------------------

class LudoSplashLoadingScreen extends StatefulWidget {
  const LudoSplashLoadingScreen({super.key});

  @override
  State<LudoSplashLoadingScreen> createState() => _LudoSplashLoadingScreenState();
}

class _LudoSplashLoadingScreenState extends State<LudoSplashLoadingScreen> with SingleTickerProviderStateMixin {
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
    _fadeAnimation = CurvedParentTween(parent: _animController, curve: Curves.easeInOut);
    _animController.forward();

    _loadTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      setState(() {
        _loadingProgress += 0.025;
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
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.8,
              colors: [
                const Color(0xff131c2e),
                const Color(0xff060911),
              ],
            ),
          ),
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
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
                    child: const Icon(
                      Icons.casino_rounded,
                      size: 64,
                      color: Color(0xffffcc00),
                    ),
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
                    'جاري تحميل الأنظمة السيبرانية... ${(_loadingProgress * 100).toInt()}%',
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

class CurvedParentTween extends Animation<double> {
  final AnimationController parent;
  final Curve curve;
  CurvedParentTween({required this.parent, required this.curve}) : super();
  @override
  double get value => curve.transform(parent.value);
  @override
  AnimationStatus get status => parent.status;
  @override
  void addListener(VoidCallback listener) => parent.addListener(listener);
  @override
  void removeListener(VoidCallback listener) => parent.removeListener(listener);
  @override
  void addStatusListener(AnimationStatusListener listener) => parent.addStatusListener(listener);
  @override
  void removeStatusListener(AnimationStatusListener listener) => parent.removeStatusListener(listener);
}

// ------------------------------------------------------------------------------
// 1. نماذج البيانات وقواعد اللعبة الهندسية (Game Models & Rules)
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
// 2. محرك ولُب اللعبة والتحقق الهندسي الموحد (Game Engine & Controller)
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
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  void rollDice() {
    if (hasRolled || isGameOver || isRolling || isAnimatingMove || _isDisposed) return;

    isRolling = true;
    gameMessage = "جاري رمي النرد وتوليد القيمة العشوائية...";
    notifyListeners();

    int currentSession = gameSessionId;
    int counter = 0;
    _diceTimer?.cancel();
    _diceTimer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
      if (isGameOver || gameSessionId != currentSession || _isDisposed) {
        timer.cancel();
        return;
      }
      diceValue = Random().nextInt(6) + 1;
      counter++;
      notifyListeners();
      if (counter > 14) {
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
      if (currentPos == player.entryBeforeHome) {
        return 52;
      }
      return (currentPos + 1) % 52;
    } else if (currentPos >= 52 && currentPos < 58) {
      return currentPos + 1;
    }

    return currentPos;
  }

  int simulateMovement(int currentPos, int steps, LudoPlayer player) {
    if (currentPos == -1) {
      if (steps == 6) {
        return player.baseStartIndex;
      }
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
      if (steps != remainingStepsToHome) {
        return -1;
      }
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
      gameMessage = "لاعب ${currentTurnPlayer.name} رمى ($diceValue). اختر حجراً مضيئاً لتحريكه خطوة بخطوة.";
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
    gameMessage = "جاري تحريك الحجر السيبراني...";
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
      
      await Future.delayed(const Duration(milliseconds: 350));
      if (gameSessionId != currentSession || _isDisposed) {
        isAnimatingMove = false;
        return;
      }
      isAnimatingMove = false;
      _finalizeMove(extraTurn: extraTurn, currentSession: currentSession);
      return;
    }

    // حركة سلسة خطوة بخطوة عبر مربعات اللعبة
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
      await Future.delayed(const Duration(milliseconds: 180));
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
      gameMessage = "تهانينا! فاز اللاعب ${player.name} بالبطولة الكبرى في السايبر!";
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
          gameMessage = "تم القضاء على حجر اللاعب ${players[p].name} وإرجاعه لقاعدة الشحن!";
        }
      }
    }
    return didCapture;
  }

  void _finalizeMove({bool extraTurn = false, required int currentSession}) {
    if (gameSessionId != currentSession || _isDisposed || isGameOver) return;
    hasRolled = false;
    if (extraTurn) {
      gameMessage += " (تحصل على رمية نرد إضافية استحقاقاً!)";
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
    gameMessage = "بدأت مباراة سايبر جديدة. دور اللاعب ${players[0].name}.";
    notifyListeners();
  }
}

// ------------------------------------------------------------------------------
// 3. إحداثيات ورسام لوحة اللودو سايبربانك الاحترافية المطابقة تماماً
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

class LudoBoardPainter extends CustomPainter {
  final List<LudoPlayer> players;

  LudoBoardPainter({required this.players});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    double w = size.width;
    double h = size.height;
    double cellSize = w / 15;

    // خلفية اللوحة الداكنة
    paint.color = const Color(0xff090d16);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);

    // خطوط الشبكة الإلكترونية الخافتة
    final circuitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xff162032);

    for (double i = 0; i < w; i += cellSize * 2) {
      canvas.drawLine(Offset(i, 0), Offset(i, h), circuitPaint);
      canvas.drawLine(Offset(0, i), Offset(w, i), circuitPaint);
    }

    // قواعد اللاعبين الأربعة بنقاط دائرية نيون مطابقة للصورة الأخيرة
    _drawCyberBaseWithCircles(canvas, paint, cellSize * 9, 0, cellSize * 6, const Color(0xffff3366)); // أحمر
    _drawCyberBaseWithCircles(canvas, paint, 0, 0, cellSize * 6, const Color(0xff00ff66)); // أخضر
    _drawCyberBaseWithCircles(canvas, paint, cellSize * 9, cellSize * 9, cellSize * 6, const Color(0xffffcc00)); // أصفر
    _drawCyberBaseWithCircles(canvas, paint, 0, cellSize * 9, cellSize * 6, const Color(0xff00f3ff)); // أزرق

    // مسارات اللعب المشتركة
    for (int i = 0; i < sharedTrackCoords.length; i++) {
      var pt = sharedTrackCoords[i];
      Color cellColor = const Color(0xff111827);
      Color borderColor = const Color(0xff1f2937);

      if (i == 0) {
        cellColor = const Color(0xffff3366).withOpacity(0.4);
        borderColor = const Color(0xffff3366);
      } else if (i == 13) {
        cellColor = const Color(0xff00ff66).withOpacity(0.4);
        borderColor = const Color(0xff00ff66);
      } else if (i == 26) {
        cellColor = const Color(0xff00f3ff).withOpacity(0.4);
        borderColor = const Color(0xff00f3ff);
      } else if (i == 39) {
        cellColor = const Color(0xffffcc00).withOpacity(0.4);
        borderColor = const Color(0xffffcc00);
      } else if ({0, 8, 13, 21, 26, 34, 39, 47}.contains(i)) {
        cellColor = const Color(0xff1e293b);
        borderColor = const Color(0xff38bdf8);
      }

      paint.style = PaintingStyle.fill;
      paint.color = cellColor;
      canvas.drawRect(Rect.fromLTWH(pt.x * cellSize + 1, pt.y * cellSize + 1, cellSize - 2, cellSize - 2), paint);

      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1.0;
      paint.color = borderColor;
      canvas.drawRect(Rect.fromLTWH(pt.x * cellSize + 1, pt.y * cellSize + 1, cellSize - 2, cellSize - 2), paint);
    }

    // المسارات النهائية (Home Paths)
    for (int step = 0; step < 6; step++) {
      paint.style = PaintingStyle.fill;
      paint.color = const Color(0xffff3366).withOpacity(0.65);
      canvas.drawRect(Rect.fromLTWH((1 + step) * cellSize + 1, 7 * cellSize + 1, cellSize - 2, cellSize - 2), paint);

      paint.color = const Color(0xff00ff66).withOpacity(0.65);
      canvas.drawRect(Rect.fromLTWH(7 * cellSize + 1, (1 + step) * cellSize + 1, cellSize - 2, cellSize - 2), paint);

      paint.color = const Color(0xff00f3ff).withOpacity(0.65);
      canvas.drawRect(Rect.fromLTWH((13 - step) * cellSize + 1, 7 * cellSize + 1, cellSize - 2, cellSize - 2), paint);

      paint.color = const Color(0xffffcc00).withOpacity(0.65);
      canvas.drawRect(Rect.fromLTWH(7 * cellSize + 1, (13 - step) * cellSize + 1, cellSize - 2, cellSize - 2), paint);
    }

    // المركز المضيء
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xff0b101c);
    canvas.drawRect(Rect.fromLTWH(cellSize * 6, cellSize * 6, cellSize * 3, cellSize * 3), paint);

    final centerNeon = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = const Color(0xff00f3ff);

    canvas.drawRect(Rect.fromLTWH(cellSize * 6, cellSize * 6, cellSize * 3, cellSize * 3), centerNeon);
    canvas.drawLine(Offset(cellSize * 6, cellSize * 6), Offset(cellSize * 9, cellSize * 9), centerNeon);
    canvas.drawLine(Offset(cellSize * 9, cellSize * 6), Offset(cellSize * 6, cellSize * 9), centerNeon);
  }

  void _drawCyberBaseWithCircles(Canvas canvas, Paint paint, double x, double y, double size, Color color) {
    // خلفية القاعدة
    paint.style = PaintingStyle.fill;
    paint.color = color.withOpacity(0.12);
    canvas.drawRect(Rect.fromLTWH(x, y, size, size), paint);

    // إطار القاعدة نيون
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0;
    paint.color = color;
    canvas.drawRect(Rect.fromLTWH(x, y, size, size), paint);

    // رسم الدوائر الأربع الداخلية للقاعدة (مطابق للصورة تماماً)
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = color.withOpacity(0.7);

    List<Offset> baseSlots = [
      Offset(x + size * 0.25, y + size * 0.25),
      Offset(x + size * 0.75, y + size * 0.25),
      Offset(x + size * 0.25, y + size * 0.75),
      Offset(x + size * 0.75, y + size * 0.75),
    ];

    for (var slot in baseSlots) {
      canvas.drawCircle(slot, size * 0.16, circlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Offset getTokenPixelPosition(int pos, LudoPlayer player, int tokenIndex, double cellSize, List<LudoPlayer> allPlayers) {
  Point<double> gridPoint;
  int baseIdx = player.baseIndexForCoords;

  if (pos == -1) {
    double baseX = (baseIdx == 0 || baseIdx == 2) ? 0.5 : 9.5;
    double baseY = (baseIdx == 0 || baseIdx == 1) ? 0.5 : 9.5;
    List<Point<double>> baseOffsets = [
      const Point(1.0, 1.0),
      const Point(3.0, 1.0),
      const Point(1.0, 3.0),
      const Point(3.0, 3.0),
    ];
    gridPoint = Point(baseX + baseOffsets[tokenIndex].x, baseY + baseOffsets[tokenIndex].y);
  } else if (pos == 58) {
    gridPoint = const Point(7.0, 7.0);
  } else if (pos >= 52 && pos <= 57) {
    int step = pos - 52;
    if (baseIdx == 0) gridPoint = Point(1.0 + step, 7.0);
    else if (baseIdx == 1) gridPoint = Point(7.0, 1.0 + step);
    else if (baseIdx == 2) gridPoint = Point(13.0 - step, 7.0);
    else gridPoint = Point(7.0, 13.0 - step);
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
        bool shareSameVisualSpace = (otherPos == pos) && (pos < 52 || pos == -1 || pos == 58 || (pos >= 52 && allPlayers[p] == player));
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
        const Offset(-4, -4),
        const Offset(4, -4),
        const Offset(-4, 4),
        const Offset(4, 4),
      ];
      offsetX = offsets[sharingIndex % 4].dx;
      offsetY = offsets[sharingIndex % 4].dy;
    }
  }

  return Offset((gridPoint.x + 0.5) * cellSize + offsetX, (gridPoint.y + 0.5) * cellSize + offsetY);
}

// ------------------------------------------------------------------------------
// 4. واجهة المستخدم الرسومية الاحترافية المتوافقة مع Samsung A16
// ------------------------------------------------------------------------------

class LudoGameScreen extends StatefulWidget {
  const LudoGameScreen({super.key});

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> with SingleTickerProviderStateMixin {
  late final LudoGameController _controller;
  late AnimationController _diceAnimController;

  @override
  void initState() {
    super.initState();
    _controller = LudoGameController(totalPlayersCount: 4);
    _diceAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _diceAnimController.dispose();
    super.dispose();
  }

  void _triggerDiceRoll() {
    if (_controller.hasRolled || _controller.isGameOver || _controller.isRolling || _controller.isAnimatingMove) return;
    _diceAnimController.forward(from: 0.0);
    _controller.rollDice();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xff060911),
            appBar: AppBar(
              backgroundColor: const Color(0xff0b101c),
              elevation: 6,
              shadowColor: const Color(0xff00f3ff).withOpacity(0.3),
              title: const Text(
                'RAYID PAY – CYBERPUNK LUDO ARENA',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                PopupMenuButton<int>(
                  icon: const Icon(Icons.group_rounded, color: Color(0xff00f3ff)),
                  tooltip: 'اختر عدد اللاعبين',
                  onSelected: (val) => _controller.setPlayersCount(val),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 2, child: Text('لاعبان (2 Players)')),
                    const PopupMenuItem(value: 3, child: Text('ثلاثة لاعبين (3 Players)')),
                    const PopupMenuItem(value: 4, child: Text('أربعة لاعبين (4 Players)')),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: Color(0xffffcc00)),
                  tooltip: 'إعادة ضبط اللعبة',
                  onPressed: () => _controller.resetGame(),
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xff0f1626),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _controller.currentTurnPlayer.uiColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: _controller.currentTurnPlayer.uiColor.withOpacity(0.35),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _controller.currentTurnPlayer.uiColor,
                            boxShadow: [
                              BoxShadow(color: _controller.currentTurnPlayer.uiColor, blurRadius: 6)
                            ]
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _controller.gameMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xff0d1320),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _controller.players.map((p) {
                        return Column(
                          children: [
                            Text(p.name, style: TextStyle(color: p.uiColor, fontSize: 11, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text('${p.finishedCount}/4 وصول', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double availableWidth = constraints.maxWidth;
                            double availableHeight = constraints.maxHeight;
                            double boardSize = availableWidth < availableHeight ? availableWidth : availableHeight;
                            double cellSize = boardSize / 15;

                            return Center(
                              child: SizedBox(
                                width: boardSize,
                                height: boardSize,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff060911),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xffff007f), width: 2.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xffff007f).withOpacity(0.5),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Stack(
                                      children: [
                                        CustomPaint(
                                          size: Size(boardSize, boardSize),
                                          painter: LudoBoardPainter(players: _controller.players),
                                        ),
                                        for (int pIndex = 0; pIndex < _controller.players.length; pIndex++) ...{
                                          for (int tIndex = 0; tIndex < _controller.players[pIndex].tokenPositions.length; tIndex++) ...{
                                            () {
                                              var player = _controller.players[pIndex];
                                              int pos = player.tokenPositions[tIndex];
                                              Offset pixelPos = getTokenPixelPosition(pos, player, tIndex, cellSize, _controller.players);
                                              bool isMovable = _controller.isTokenMovable(pIndex, tIndex);
                                              bool isHome = pos == 58;

                                              return Positioned(
                                                left: pixelPos.dx - 11,
                                                top: pixelPos.dy - 11,
                                                child: GestureDetector(
                                                  onTap: () => _controller.moveToken(pIndex, tIndex),
                                                  child: AnimatedContainer(
                                                    duration: const Duration(milliseconds: 300),
                                                    curve: Curves.easeInOut,
                                                    width: 22,
                                                    height: 22,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: isHome 
                                                          ? Colors.amber 
                                                          : (pos != -1 ? player.uiColor : const Color(0xff1b2233)),
                                                      border: Border.all(
                                                        color: isMovable ? Colors.yellowAccent : (pos != -1 ? Colors.white : const Color(0xff556688)), 
                                                        width: isMovable ? 2.5 : 1.5,
                                                      ),
                                                      boxShadow: isMovable ? [
                                                        const BoxShadow(color: Colors.yellowAccent, blurRadius: 10, spreadRadius: 2)
                                                      ] : (pos != -1 ? [BoxShadow(color: player.uiColor.withOpacity(0.7), blurRadius: 8)] : []),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        isHome ? '★' : (pos != -1 ? '$pos' : 'B'),
                                                        style: TextStyle(
                                                          fontSize: 8,
                                                          color: pos != -1 ? Colors.black : const Color(0xff8899aa),
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }()
                                          }
                                        },
                                        Center(
                                          child: GestureDetector(
                                            onTap: _triggerDiceRoll,
                                            child: RotationTransition(
                                              turns: Tween(begin: 0.0, end: 1.0).animate(_diceAnimController),
                                              child: Container(
                                                width: 54,
                                                height: 54,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: const Color(0xff111827),
                                                  border: Border.all(color: const Color(0xffffcc00), width: 2),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(0xffffcc00).withOpacity(0.6),
                                                      blurRadius: 14,
                                                      spreadRadius: 2,
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: _controller.isRolling
                                                      ? const SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: CircularProgressIndicator(
                                                            color: Color(0xffffcc00),
                                                            strokeWidth: 2,
                                                          ),
                                                        )
                                                      : Text(
                                                          _controller.diceValue == 0 ? '🎲' : '${_controller.diceValue}',
                                                          style: const TextStyle(
                                                            fontSize: 22,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xffffcc00),
                                                          ),
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
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xff0f1626),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _controller.hasRolled || _controller.isGameOver || _controller.isAnimatingMove ? Colors.grey.shade800 : const Color(0xff00e676),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _controller.hasRolled || _controller.isGameOver || _controller.isAnimatingMove ? null : _triggerDiceRoll,
                          child: const Text(
                            'رمي النرد (ROLL)',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffff3366),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => _controller.resetGame(),
                          child: const Text(
                            'لعبة جديدة',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
