import 'package:flutter_test/flutter_test.dart';
import 'package:rayid_app/games/ludo/ludo_screen.dart'; // تأكد من مطابقة مسار الاستيراد لمشروعك

void main() {
  group('RAYID CYBER LUDO - Formal Engineering Tests', () {
    
    test('1. Track contains exactly 52 unique cells', () {
      final track = LudoBoardGeometry.track;
      expect(track.length, equals(52));
      expect(track.toSet().length, equals(52));
    });

    test('2. All track cells are strictly adjacent horizontally or vertically', () {
      final track = LudoBoardGeometry.track;
      for (int i = 0; i < track.length; i++) {
        final current = track[i];
        final next = track[(i + 1) % 52];
        final manhattanDist = (current.dx - next.dx).abs() + (current.dy - next.dy).abs();
        expect(manhattanDist, equals(1), reason: 'Gap or diagonal transition found at index $i');
      }
    });

    test('3. Base exit rules require exact roll of 6', () {
      expect(LudoEngine.calculateNewPosition(-1, 5, PlayerColor.green), equals(LudoEngine.invalidMove));
      expect(LudoEngine.calculateNewPosition(-1, 6, PlayerColor.green), equals(0));
    });

    test('4. Overshooting win target (58) is strictly rejected', () {
      expect(LudoEngine.calculateNewPosition(57, 2, PlayerColor.green), equals(LudoEngine.invalidMove));
      expect(LudoEngine.calculateNewPosition(57, 1, PlayerColor.green), equals(LudoEngine.targetWin));
    });

    test('5. Safe positions prevent captures', () {
  final allTokens = {
    PlayerColor.green: [
      TokenModel(id: 0, color: PlayerColor.green, position: 0),
    ],
    PlayerColor.yellow: [
      TokenModel(id: 0, color: PlayerColor.yellow, position: 11),
    ],
  };

  final captured = LudoEngine.processCaptures(
    PlayerColor.green,
    0,
    allTokens,
  );

  expect(captured, isFalse);
});

test('6. Unsafe positions allow captures', () {
  final allTokens = {
    PlayerColor.green: [
      TokenModel(id: 0, color: PlayerColor.green, position: 1),
    ],
    PlayerColor.yellow: [
      TokenModel(id: 0, color: PlayerColor.yellow, position: 12),
    ],
  };

  final captured = LudoEngine.processCaptures(
    PlayerColor.green,
    0,
    allTokens,
  );

  expect(captured, isTrue);
  expect(allTokens[PlayerColor.yellow]![0].position, equals(-1));
});
    test('6. Winning condition detection works correctly', () {
      final winningTokens = List.generate(4, (i) => TokenModel(id: i, color: PlayerColor.green, position: LudoEngine.targetWin));
      expect(LudoEngine.hasWon(winningTokens), isTrue);

      final incompleteTokens = [
        TokenModel(id: 0, color: PlayerColor.green, position: 58),
        TokenModel(id: 1, color: PlayerColor.green, position: 50),
      ];
      expect(LudoEngine.hasWon(incompleteTokens), isFalse);
    });

  });
}
