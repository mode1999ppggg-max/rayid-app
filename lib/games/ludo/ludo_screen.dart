import 'dart:math';
import 'package:flutter/material.dart';

// ==========================================
// 1. MODELS (النماذج)
// ==========================================

enum TokenState { base, path, home }

class TokenModel {
  final String id;
  final String playerId;
  final Color color;
  TokenState state;
  int position; // -1: القاعدة، 0-51: المسار الرئيسي، 52-56: مسار النهاية، 57: الفوز
  final int baseIndex;

  TokenModel({
    required this.id,
    required this.playerId,
    required this.color,
    this.state = TokenState.base,
    this.position = -1,
    required this.baseIndex,
  });

  TokenModel copyWith({
    TokenState? state,
    int? position,
  }) {
    return TokenModel(
      id: id,
      playerId: playerId,
      color: color,
      state: state ?? this.state,
      position: position ?? this.position,
      baseIndex: baseIndex,
    );
  }
}

enum PlayerType { human, ai }

class PlayerModel {
  final String id;
  final String name;
  final Color color;
  final PlayerType type;
  final List<TokenModel> tokens;
  bool isFinished;

  PlayerModel({
    required this.id,
    required this.name,
    required this.color,
    required this.type,
    required this.tokens,
    this.isFinished = false,
  });

  PlayerModel copyWith({
    List<TokenModel>? tokens,
    bool? isFinished,
  }) {
    return PlayerModel(
      id: id,
      name: name,
      color: color,
      type: type,
      tokens: tokens ?? this.tokens,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

// ==========================================
// 2. LOGIC & VALIDATION (المنطق وقواعد اللعبة)
// ==========================================

class MoveValidator {
  static const int maxHomeStretch = 57;

  static bool canMove({
    required TokenModel token,
    required int diceValue,
  }) {
    if (token.state == TokenState.home) {
      return false;
    }

    if (token.state == TokenState.base) {
      return diceValue == 6; // الخروج يحتاج حصراً إلى رمية 6
    }

    if (token.state == TokenState.path) {
      int nextPos = token.position + diceValue;
      if (nextPos > maxHomeStretch) {
        return false; // يمنع تجاوز نقطة النهاية
      }
      return true;
    }

    return false;
  }
}

// ==========================================
// 3. CONTROLLERS (المتحكمات)
// ==========================================

class DiceController extends ChangeNotifier {
  int _currentValue = 6;
  bool _isRolling = false;

  int get currentValue => _currentValue;
  bool get isRolling => _isRolling;

  Future<int> rollDice() async {
    if (_isRolling) return _currentValue;
    _isRolling = true;
    notifyListeners();

    for (int i = 0; i < 6; i++) {
      _currentValue = Random().nextInt(6) + 1;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 70));
    }

    _isRolling = false;
    notifyListeners();
    return _currentValue;
  }
}

enum GameState { rolling, moving, waitingForMove, gameOver }

class GameController extends ChangeNotifier {
  final DiceController diceController = DiceController();
  
  late List<PlayerModel> players;
  int currentTurnIndex = 0;
  GameState gameState = GameState.rolling;
  String? winnerName;
  String statusMessage = 'اختر رمي النرد لبدء الجولة';

  GameController({int playerModes = 4}) {
    _initializeGame(playerModes);
  }

  void _initializeGame(int count) {
    final colors = [Colors.redAccent, Colors.greenAccent, Colors.amberAccent, Colors.cyanAccent];
    final names = ['الأحمر', 'الأخضر', 'الأصفر', 'الأزرق'];

    players = List.generate(count, (index) {
      List<TokenModel> tokens = List.generate(4, (tIndex) {
        return TokenModel(
          id: 'p${index}_t$tIndex',
          playerId: 'player_$index',
          color: colors[index],
          baseIndex: tIndex,
        );
      });

      return PlayerModel(
        id: 'player_$index',
        name: names[index],
        color: colors[index],
        type: PlayerType.human,
        tokens: tokens,
      );
    });

    currentTurnIndex = 0;
    gameState = GameState.rolling;
    winnerName = null;
    statusMessage = 'دور اللاعب ${players[currentTurnIndex].name} - يرجى رمي النرد';
    notifyListeners();
  }

  PlayerModel get currentPlayer => players[currentTurnIndex];

  Future<void> rollDiceAndPlay() async {
    if (gameState != GameState.rolling) return;

    statusMessage = 'جاري رمي النرد...';
    notifyListeners();

    int diceVal = await diceController.rollDice();

    bool hasValidMoves = currentPlayer.tokens.any((token) => MoveValidator.canMove(token: token, diceValue: diceVal));

    if (!hasValidMoves) {
      statusMessage = 'النرد ($diceVal): لا توجد حركات متاحة! الانتقال للدور التالي.';
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 1000));
      _nextTurn(extraTurn: false);
    } else {
      gameState = GameState.waitingForMove;
      statusMessage = 'النرد ($diceVal): اختر حجراً للتحريك.';
      notifyListeners();
    }
  }

  void playToken(TokenModel token) {
    if (gameState != GameState.waitingForMove) return;
    int diceVal = diceController.currentValue;

    if (!MoveValidator.canMove(token: token, diceValue: diceVal)) {
      statusMessage = 'حركة غير قانونية لهذا الحجر!';
      notifyListeners();
      return;
    }

    List<PlayerModel> updatedPlayers = List.from(players);
    PlayerModel activePlayer = updatedPlayers[currentTurnIndex];

    List<TokenModel> updatedTokens = activePlayer.tokens.map((t) {
      if (t.id == token.id) {
        if (t.state == TokenState.base && diceVal == 6) {
          return t.copyWith(state: TokenState.path, position: 0);
        } else if (t.state == TokenState.path) {
          int newPos = t.position + diceVal;
          if (newPos >= 57) {
            return t.copyWith(state: TokenState.home, position: 57);
          }
          return t.copyWith(position: newPos);
        }
      }
      return t;
    }).toList();

    updatedPlayers[currentTurnIndex] = activePlayer.copyWith(tokens: updatedTokens);
    players = updatedPlayers;

    bool hasWon = updatedTokens.every((t) => t.state == TokenState.home);
    if (hasWon) {
      gameState = GameState.gameOver;
      winnerName = activePlayer.name;
      statusMessage = 'تهانينا! الفائز هو ${activePlayer.name}';
      notifyListeners();
      return;
    }

    bool extraTurn = (diceVal == 6);
    if (extraTurn) {
      statusMessage = 'حصلت على رمية إضافية لاستحقاقك ظهور الرقم 6!';
      notifyListeners();
    } else {
      _nextTurn(extraTurn: false);
    }
  }

  void _nextTurn({required bool extraTurn}) {
    if (extraTurn) {
      gameState = GameState.rolling;
    } else {
      currentTurnIndex = (currentTurnIndex + 1) % players.length;
      gameState = GameState.rolling;
    }
    statusMessage = 'دور اللاعب ${players[currentTurnIndex].name} - يرجى رمي النرد';
    notifyListeners();
  }

  void restartGame() {
    _initializeGame(players.length);
  }
}

// ==========================================
// 4. UI SCREEN (واجهة اللعبة السايبرانية المتكاملة)
// ==========================================

class LudoScreen extends StatefulWidget {
  const LudoScreen({Key? key}) : super(key: key);

  @override
  State<LudoScreen> createState() => _LudoScreenState();
}

class _LudoScreenState extends State<LudoScreen> {
  late GameController _gameController;

  @override
  void initState() {
    super.initState();
    _gameController = GameController(playerModes: 4);
    _gameController.addListener(_onGameStateChanged);
  }

  void _onGameStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _gameController.removeListener(_onGameStateChanged);
    _gameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0E21),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1D1E33),
          elevation: 4,
          shadowColor: Colors.cyanAccent.withOpacity(0.3),
          title: const Text(
            'RAYID PAY – CYBERPUNK LUDO',
            style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.cyanAccent),
              onPressed: () => _gameController.restartGame(),
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // شريط الحالة العلوي المتناسق مع تصميمك
                _buildStatusBanner(),
                // إحصائيات وصول الأحجار للاعبين الأربعة
                _buildPlayersStatsBar(),
                // لوحة اللعب الرئيسية السايبرانية
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111625),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.cyanAccent.withOpacity(0.5), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            _buildBoardLayout(),
                            _buildTokensLayer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // لوحة التحكم السفلية للأزرار والنرد
                _buildControlPanel(),
              ],
            ),
            if (_gameController.gameState == GameState.gameOver)
              _buildWinOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pinkAccent.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.pinkAccent.withOpacity(0.15), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _gameController.currentPlayer.color,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: _gameController.currentPlayer.color, blurRadius: 6)],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _gameController.statusMessage,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersStatsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF151A30),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _gameController.players.map((player) {
          int arrivedCount = player.tokens.where((t) => t.state == TokenState.home).length;
          return Column(
            children: [
              Text(
                player.name,
                style: TextStyle(color: player.color, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                '$arrivedCount/4 وصول',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBoardLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // قواعد اللاعبين الأربعة بتصميم سايبرانك متقن
            Positioned(top: 0, right: 0, width: constraints.maxWidth * 0.4, height: constraints.maxHeight * 0.4, child: _buildBaseContainer(Colors.redAccent)),
            Positioned(top: 0, left: 0, width: constraints.maxWidth * 0.4, height: constraints.maxHeight * 0.4, child: _buildBaseContainer(Colors.greenAccent)),
            Positioned(bottom: 0, left: 0, width: constraints.maxWidth * 0.4, height: constraints.maxHeight * 0.4, child: _buildBaseContainer(Colors.amberAccent)),
            Positioned(bottom: 0, right: 0, width: constraints.maxWidth * 0.4, height: constraints.maxHeight * 0.4, child: _buildBaseContainer(Colors.cyanAccent)),
            
            // المركز (منطقة الفوز / النرد الأوسط)
            Center(
              child: Container(
                width: constraints.maxWidth * 0.2,
                height: constraints.maxHeight * 0.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.purpleAccent.withOpacity(0.8), Colors.transparent],
                  ),
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.6), width: 1.5),
                ),
                child: Center(
                  child: Text(
                    '${_gameController.diceController.currentValue}',
                    style: const TextStyle(color: Colors.amberAccent, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBaseContainer(Color color) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
    );
  }

  Widget _buildTokensLayer() {
    return Stack(
      children: _gameController.players.expand((player) {
        return player.tokens.map((token) {
          Alignment alignment = _getTokenAlignment(token);
          return Align(
            alignment: alignment,
            child: GestureDetector(
              onTap: () => _gameController.playToken(token),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: token.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: token.color.withOpacity(0.8), blurRadius: 8, spreadRadius: 2),
                  ],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    token.id.substring(token.id.length - 1),
                    style: const TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  Alignment _getTokenAlignment(TokenModel token) {
    int pIndex = int.parse(token.playerId.replaceAll('player_', ''));
    if (token.state == TokenState.base) {
      double offsetX = (pIndex == 1 || pIndex == 2) ? -0.7 : 0.7;
      double offsetY = (pIndex == 2 || pIndex == 3) ? 0.7 : -0.7;
      
      // توزيع الأحجار الأربعة داخل القاعدة بانتظام
      double dx = 0.0;
      double dy = 0.0;
      if (token.baseIndex == 0) { dx = -0.1; dy = -0.1; }
      if (token.baseIndex == 1) { dx = 0.1; dy = -0.1; }
      if (token.baseIndex == 2) { dx = -0.1; dy = 0.1; }
      if (token.baseIndex == 3) { dx = 0.1; dy = 0.1; }

      return Alignment(offsetX + dx, offsetY + dy);
    } else if (token.state == TokenState.home) {
      return const Alignment(0.0, 0.0);
    }
    // مسار افتراضي تدريجي للحركة على اللوحة
    return const Alignment(0.0, 0.0);
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1D1E33),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // زر لعبة جديدة
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => _gameController.restartGame(),
            child: const Text('لعبة جديدة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          // زر رمي النرد الرئيسي
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _gameController.gameState == GameState.rolling 
                ? () => _gameController.rollDiceAndPlay() 
                : null,
            icon: const Icon(Icons.casino),
            label: const Text('رمي النرد (ROLL)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildWinOverlay() {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1D1E33),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amberAccent, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amberAccent, size: 64),
              const SizedBox(height: 16),
              Text(
                'فاز المتباري: ${_gameController.winnerName ?? ""}',
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amberAccent, foregroundColor: Colors.black),
                onPressed: () => _gameController.restartGame(),
                child: const Text('لعب من جديد', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
