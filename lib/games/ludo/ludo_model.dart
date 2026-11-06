import 'package:flutter/material.dart';

enum LudoColor { red, green, yellow, blue }

class LudoPlayer {
  final LudoColor color;
  final Color uiColor;
  List<int> tokenPositions; // -1 = Base, 0-56 = Track, 57 = Home
  int homeCount;

  LudoPlayer({required this.color, required this.uiColor})
      : tokenPositions = [-1, -1, -1, -1],
        homeCount = 0;
}

class LudoGameController extends ChangeNotifier {
  List<LudoPlayer> players = [
        LudoPlayer(color: PlayerColor.green, ...),
    LudoPlayer(color: PlayerColor.yellow, ...),
    LudoPlayer(color: PlayerColor.red, ...),
    LudoPlayer(color: PlayerColor.blue, ...),


  int currentTurnIndex = 0;
  int diceValue = 0;
  bool hasRolled = false;
  bool isGameOver = false;
  String gameMessage = 'ابدأ اللعبة برمي النرد!';

  LudoPlayer get currentTurnPlayer => players[currentTurnIndex];

  void rollDice() {
    if (hasRolled || isGameOver) return;
    
    diceValue = 1 + DateTime.now().millisecondsSinceEpoch % 6;
    hasRolled = true;
    gameMessage = 'لاعب ${currentTurnPlayer.color.name} رمى الرقم: $diceValue';
    notifyListeners();
  }

  void moveToken(int playerIndex, int tokenIndex) {
    if (!hasRolled || playerIndex != currentTurnIndex || isGameOver) return;

    var player = players[playerIndex];
    int pos = player.tokenPositions[tokenIndex];

    if (pos == -1) {
      if (diceValue == 6) {
        player.tokenPositions[tokenIndex] = 0; 
        gameMessage = 'خرج القطع إلى المسار!';
      } else {
        gameMessage = 'تحتاج إلى رمي 6 لإخراج القطع من القاعدة!';
        notifyListeners();
        return;
      }
    } else {
      int newPos = pos + diceValue;
      if (newPos <= 57) {
        player.tokenPositions[tokenIndex] = newPos;
        if (newPos == 57) {
          player.homeCount++;
          gameMessage = 'دخلت قطعة إلى البيت النهائي!';
          if (player.homeCount == 4) {
            isGameOver = true;
            gameMessage = '🎉 الفائز هو اللاعب ${player.color.name}!';
          }
        }
      } else {
        gameMessage = 'الرقم أكبر من المتبقي للوصول للبيت!';
        notifyListeners();
        return;
      }
    }

    hasRolled = false;
    if (!isGameOver && diceValue != 6) {
      currentTurnIndex = (currentTurnIndex + 1) % players.length;
    }
    notifyListeners();
  }

  void resetGame() {
    for (var p in players) {
      p.tokenPositions = [-1, -1, -1, -1];
      p.homeCount = 0;
    }
    currentTurnIndex = 0;
    diceValue = 0;
    hasRolled = false;
    isGameOver = false;
    gameMessage = 'بدأت لعبة جديدة. دور اللاعب الأحمر';
    notifyListeners();
  }
}
