// ==============================================================================
// ملف اللعبة المتكامل والمطور هندسياً: lib/games/ludo_game.dart
// مشروع RAYID PAY – CYBERPUNK LUDO ARENA
// ==============================================================================

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// ------------------------------------------------------------------------------
// 1. نماذج البيانات وقواعد اللعبة الهندسية (Game Models & Rules)
// ------------------------------------------------------------------------------

enum LudoColor { red, green, blue, yellow }

class LudoPlayer {
  final LudoColor color;
  final Color uiColor;
  final String name;
  final int baseStartIndex; // نقطة البداية العالمية على المسار المشترك (0 إلى 51)
  final int baseIndexForCoords; // مؤشر مرجعي لتحديد موقع القاعدة على اللوحة (0:أحمر، 1:أخضر، 2:أزرق، 3:أصفر)
  final int entryBeforeHome; // خانة الدخول الدقيقة المحددة لكل لون (الأحمر: 50، الأخضر: 11، الأزرق: 24، الأصفر: 37)

  // مواقع القطع الأربعة:
  // -1: داخل القاعدة.
  // 0 إلى 51: المسار العام المشترك.
  // 52 إلى 57: المسار النهائي الخاص (Home Stretch - 6 خانات).
  // 58: البيت النهائي (الهدف المكتمل).
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
  int totalPlayersCount; // عدد اللاعبين (2، 3، أو 4)
  late List<LudoPlayer> players;

  int currentTurnIndex = 0;
  int diceValue = 0;
  bool hasRolled = false;
  bool isGameOver = false;
  bool isRolling = false;
  bool isAnimatingMove = false; // لمنع النقر المتكرر أثناء الحركة التدريجية
  bool _isDisposed = false;
  String gameMessage = "مرحباً بك في RAYID PAY LUDO ARENA! دور اللاعب الأحمر.";

  // معرّف الجلسة لمنع أي مهام أو مؤقتات أو حركات قديمة من تعديل الحالة الجديدة
  int gameSessionId = 0;

  Timer? _turnTimer;
  Timer? _diceTimer;

  // المربعات الآمنة على المسار العام المشترك (0 إلى 51)
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
      players = [allPlayers[0], allPlayers[2]]; // أحمر وأزرق
    } else if (totalPlayersCount == 3) {
      players = [allPlayers[0], allPlayers[1], allPlayers[2]]; // أحمر، أخضر، أزرق
    } else {
      players = allPlayers; // الأربعة لاعبين
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

  // رمي النرد مع حماية كاملة للجلسة وتجنب النقر المتكرر
  void rollDice() {
    if (hasRolled || isGameOver || isRolling || isAnimatingMove || _isDisposed) return;

    isRolling = true;
    gameMessage = "جاري رمي النرد...";
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

  // المحرك الموحد الحقيقي والوحيد لحساب خطوة واحدة للأمام لكل لاعب
  int _calculateSingleStep(int currentPos, LudoPlayer player) {
    if (currentPos == -1) return player.baseStartIndex; // الخروج من القاعدة لنقطة البداية مباشرة
    if (currentPos == 58) return 58; // وصل للهدف النهائي مسبقاً

    // إذا كان الحجر في المسار العام المشترك (0 إلى 51)
    if (currentPos < 52) {
      if (currentPos == player.entryBeforeHome) {
        return 52; // الانتقال الدقيق لأول خانة في المسار النهائي (52)
      }
      return (currentPos + 1) % 52;
    } 
    // إذا كان الحجر داخل المسار النهائي (52 إلى 57)
    else if (currentPos >= 52 && currentPos < 58) {
      return currentPos + 1;
    }

    return currentPos;
  }

  // توحيد حساب الخروج والحركة تماماً بين simulateMovement و isValidMove و moveToken
  int simulateMovement(int currentPos, int steps, LudoPlayer player) {
    if (currentPos == -1) {
      if (steps == 6) {
        return player.baseStartIndex; // الخروج برمية 6 ينقل مباشرة لنقطة البداية دون استهلاك خطوات إضافية
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

  // التحقق من قانونية الحركة بناءً على المحرك الموحد
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
        if (p == startPos) return false; // نقطة البداية مشغولة بحجر لنفس اللاعب
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
      gameMessage = "لاعب ${currentTurnPlayer.name} رمى ($diceValue). اختر حجراً قانونياً لتحريكه.";
      notifyListeners();
    }
  }

  bool isTokenMovable(int playerIndex, int tokenIndex) {
    if (!hasRolled || isGameOver || isRolling || isAnimatingMove || _isDisposed) return false;
    if (playerIndex != currentTurnIndex) return false;
    return isValidMove(playerIndex, tokenIndex, diceValue);
  }

  // تنفيذ الحركة مع التحقق المسبق عبر simulateMovement وحماية مسارات إلغاء الحركة عند تغيّر gameSessionId
  Future<void> moveToken(int playerIndex, int tokenIndex) async {
    if (!isTokenMovable(playerIndex, tokenIndex)) return;

    LudoPlayer player = players[playerIndex];
    int currentPos = player.tokenPositions[tokenIndex];
    int simulatedTarget = simulateMovement(currentPos, diceValue, player);
    if (simulatedTarget == -1) return; // رفض الحركة إذا لم تكن قانونية تماماً

    isAnimatingMove = true;
    notifyListeners();

    int currentSession = gameSessionId;

    if (currentPos == -1) {
      int startPos = player.baseStartIndex;
      bool captured = _captureCheck(startPos, playerIndex);
      
      // التأكد أن الجلسة لم تتغير أثناء التأخير
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

    // التنفيذ التدريجي خطوة بخطوة مع التوقف الفوري عند بلوغ 58
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
      await Future.delayed(const Duration(milliseconds: 150));
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

    // فحص الفوز الموحد وإيقاف اللعبة تماماً عند وصول الأحجار الأربعة للهدف 58
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

  // قواعد أكل الخصم مع حماية المربعات الآمنة وحماية المسارات النهائية (من 52 إلى 58) تماماً
  bool _captureCheck(int targetPos, int moverPlayerIndex) {
    if (targetPos >= 52 || safePositions.contains(targetPos)) return false;

    bool didCapture = false;
    for (int p = 0; p < players.length; p++) {
      if (p == moverPlayerIndex) continue;
      for (int t = 0; t < players[p].tokenPositions.length; t++) {
        int enemyPos = players[p].tokenPositions[t];
        if (enemyPos == targetPos && enemyPos < 52) {
          players[p].tokenPositions[t] = -1; // إرجاع حجر الخصم للقاعدة
          didCapture = true;
          gameMessage = "تم أكل حجر اللاعب ${players[p].name} وإرجاعه للقاعدة!";
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
    gameSessionId++; // زيادة معرّف الجلسة لإبطال وتجاهل أي حركات أو مؤقتات جارية من الجلسة القديمة فوراً
    _cancelAllTimers();
    isAnimatingMove = false; // تصفير آمن ومباشر لحالة الحركة للجلسة الجديدة
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
// 3. إحداثيات ورسام لوحة اللودو الحقيقية 15×15 باستخدام CustomPainter
// ------------------------------------------------------------------------------

final List<Point<int>> sharedTrackCoords = [
  const Point(1, 6), const Point(2, 6), const Point(3, 6), const Point(4, 6), const Point(5, 6), // 0-4
  const Point(6, 5), const Point(6, 4), const Point(6, 3), const Point(6, 2), const Point(6, 1), const Point(6, 0), // 5-10
  const Point(7, 0), // 11
  const Point(8, 0), const Point(8, 1), const Point(8, 2), const Point(8, 3), const Point(8, 4), const Point(8, 5), // 12-17
  const Point(9, 6), const Point(10, 6), const Point(11, 6), const Point(12, 6), const Point(13, 6), const Point(14, 6), // 18-23
  const Point(14, 7), // 24
  const Point(14, 8), const Point(13, 8), const Point(12, 8), const Point(11, 8), const Point(10, 8), const Point(9, 8), // 25-30
  const Point(8, 9), const Point(8, 10), const Point(8, 11), const Point(8, 12), const Point(8, 13), const Point(8, 14), // 31-36
  const Point(7, 14), // 37
  const Point(6, 14), const Point(6, 13), const Point(6, 12), const Point(6, 11), const Point(6, 10), const Point(6, 9), // 38-43
  const Point(5, 8), const Point(4, 8), const Point(3, 8), const Point(2, 8), const Point(1, 8), const Point(0, 8), // 44-49
  const Point(0, 7), // 50
  const Point(0, 6), // 51
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

    paint.color = const Color(0xff0a0e17);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);

    // القاعدة الحمراء
    paint.color = const Color(0xffff3366).withOpacity(0.18);
    canvas.drawRect(Rect.fromLTWH(0, 0, cellSize * 6, cellSize * 6), paint);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.color = const Color(0xffff3366);
    canvas.drawRect(Rect.fromLTWH(0, 0, cellSize * 6, cellSize * 6), paint);

    // القاعدة الخضراء
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xff00ff66).withOpacity(0.18);
    canvas.drawRect(Rect.fromLTWH(cellSize * 9, 0, cellSize * 6, cellSize * 6), paint);
    paint.style = PaintingStyle.stroke;
    paint.color = const Color(0xff00ff66);
    canvas.drawRect(Rect.fromLTWH(cellSize * 9, 0, cellSize * 6, cellSize * 6), paint);

    // القاعدة الصفراء
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xffffcc00).withOpacity(0.18);
    canvas.drawRect(Rect.fromLTWH(cellSize * 9, cellSize * 9, cellSize * 6, cellSize * 6), paint);
    paint.style = PaintingStyle.stroke;
    paint.color = const Color(0xffffcc00);
    canvas.drawRect(Rect.fromLTWH(cellSize * 9, cellSize * 9, cellSize * 6, cellSize * 6), paint);

    // القاعدة الزرقاء
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xff00f3ff).withOpacity(0.18);
    canvas.drawRect(Rect.fromLTWH(0, cellSize * 9, cellSize * 6, cellSize * 6), paint);
    paint.style = PaintingStyle.stroke;
    paint.color = const Color(0xff00f3ff);
    canvas.drawRect(Rect.fromLTWH(0, cellSize * 9, cellSize * 6, cellSize * 6), paint);

    // المسار المشترك 52 خانة
    paint.style = PaintingStyle.fill;
    for (int i = 0; i < sharedTrackCoords.length; i++) {
      var pt = sharedTrackCoords[i];
      if (i == 0) {
        paint.color = const Color(0xffff3366);
      } else if (i == 13) {
        paint.color = const Color(0xff00ff66);
      } else if (i == 26) {
        paint.color = const Color(0xff00f3ff);
      } else if (i == 39) {
        paint.color = const Color(0xffffcc00);
      } else if ({0, 8, 13, 21, 26, 34, 39, 47}.contains(i)) {
        paint.color = const Color(0xff334466);
      } else {
        paint.color = const Color(0xff131c2e);
      }
      canvas.drawRect(Rect.fromLTWH(pt.x * cellSize + 1, pt.y * cellSize + 1, cellSize - 2, cellSize - 2), paint);
    }

    // المسارات النهائية (Home Stretches) لكل لون
    for (int step = 0; step < 6; step++) {
      paint.color = const Color(0xffff3366).withOpacity(0.6);
      canvas.drawRect(Rect.fromLTWH((1 + step) * cellSize + 1, 7 * cellSize + 1, cellSize - 2, cellSize - 2), paint);
    }
    for (int step = 0; step < 6; step++) {
      paint.color = const Color(0xff00ff66).withOpacity(0.6);
      canvas.drawRect(Rect.fromLTWH(7 * cellSize + 1, (1 + step) * cellSize + 1, cellSize - 2, cellSize - 2), paint);
    }
    for (int step = 0; step < 6; step++) {
      paint.color = const Color(0xff00f3ff).withOpacity(0.6);
      canvas.drawRect(Rect.fromLTWH((13 - step) * cellSize + 1, 7 * cellSize + 1, cellSize - 2, cellSize - 2), paint);
    }
    for (int step = 0; step < 6; step++) {
      paint.color = const Color(0xffffcc00).withOpacity(0.6);
      canvas.drawRect(Rect.fromLTWH(7 * cellSize + 1, (13 - step) * cellSize + 1, cellSize - 2, cellSize - 2), paint);
    }

    // مركز الهدف النهائي
    paint.color = const Color(0xff1a263f);
    canvas.drawRect(Rect.fromLTWH(cellSize * 6, cellSize * 6, cellSize * 3, cellSize * 3), paint);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.color = const Color(0xffffcc00);
    canvas.drawRect(Rect.fromLTWH(cellSize * 6, cellSize * 6, cellSize * 3, cellSize * 3), paint);
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

class _LudoGameScreenState extends State<LudoGameScreen> {
  late final LudoGameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LudoGameController(totalPlayersCount: 4);
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
                                    color: const Color(0xff0a0e17),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xff00f3ff), width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xff00f3ff).withOpacity(0.35),
                                        blurRadius: 15,
                                        spreadRadius: 1,
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
                                                        const BoxShadow(color: Colors.yellowAccent, blurRadius: 8, spreadRadius: 1)
                                                      ] : (pos != -1 ? [BoxShadow(color: player.uiColor.withOpacity(0.6), blurRadius: 6)] : []),
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
                                            onTap: () => _controller.rollDice(),
                                            child: Container(
                                              width: 54,
                                              height: 54,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color(0xff111827),
                                                border: Border.all(color: const Color(0xffffcc00), width: 2),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(0xffffcc00).withOpacity(0.55),
                                                    blurRadius: 12,
                                                    spreadRadius: 1,
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
                            backgroundColor: _controller.hasRolled ? Colors.grey.shade800 : const Color(0xff00e676),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _controller.hasRolled || _controller.isGameOver || _controller.isAnimatingMove ? null : () => _controller.rollDice(),
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
