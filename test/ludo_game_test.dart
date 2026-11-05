// ==============================================================================
// ملف اختبارات الوحدة المستقل والشامل: test/ludo_game_test.dart
// مشروع RAYID PAY – CYBERPUNK LUDO ARENA
// ==============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:rayid_pay/games/ludo_game.dart';

void main() {
  group('Ludo Game Engine Final Unit Tests', () {
    late LudoGameController controller;

    setUp(() {
      controller = LudoGameController(totalPlayersCount: 4);
    });

    test('1. الخروج من القاعدة يتطلب رمية 6 حصراً وينقل الحجر لنقطة البداية فوراً دون خطوات إضافية', () async {
      expect(controller.isValidMove(0, 0, 5), false);
      expect(controller.isValidMove(0, 0, 6), true);

      controller.diceValue = 6;
      controller.hasRolled = true;
      await controller.moveToken(0, 0);
      expect(controller.players[0].tokenPositions[0], controller.players[0].baseStartIndex);
    });

    test('2. رفض تجاوز البيت النهائي وإلغاء الحركة لجميع الحالات (56 بـ 3، 55 بـ 4، 57 بـ 2)', () {
      controller.players[0].tokenPositions[0] = 56;
      expect(controller.isValidMove(0, 0, 3), false);
      expect(controller.simulateMovement(56, 3, controller.players[0]), -1);

      controller.players[0].tokenPositions[0] = 55;
      expect(controller.isValidMove(0, 0, 4), false);
      expect(controller.simulateMovement(55, 4, controller.players[0]), -1);

      controller.players[0].tokenPositions[0] = 57;
      expect(controller.isValidMove(0, 0, 2), false);
      expect(controller.simulateMovement(57, 2, controller.players[0]), -1);
    });

    test('3. تطابق simulateMovement مع النتيجة الفعلية لكل حركة قانونية (القاعدة، المسار، المسار النهائي، والوصول لـ 58)', () async {
      // أ) الخروج من القاعدة
      controller.players[0].tokenPositions[0] = -1;
      int simBase = controller.simulateMovement(-1, 6, controller.players[0]);
      expect(simBase, controller.players[0].baseStartIndex);

      // ب) الحركة على المسار المشترك
      controller.players[0].tokenPositions[0] = 10;
      int simTrack = controller.simulateMovement(10, 4, controller.players[0]);
      expect(simTrack, 14);

      // ج) الدخول والتحرك داخل المسار النهائي
      controller.players[0].tokenPositions[0] = 52;
      int simHomeStretch = controller.simulateMovement(52, 3, controller.players[0]);
      expect(simHomeStretch, 55);

      // د) الوصول الدقيق إلى 58
      controller.players[0].tokenPositions[0] = 57;
      int simWin = controller.simulateMovement(57, 1, controller.players[0]);
      expect(simWin, 58);

      controller.diceValue = 1;
      controller.hasRolled = true;
      controller.currentTurnIndex = 0;
      await controller.moveToken(0, 0);
      expect(controller.players[0].tokenPositions[0], 58);
      expect(controller.players[0].tokenPositions[0], simWin);
    });

    test('4. الحفاظ على نقاط الدخول الدقيقة (الأحمر 50، الأخضر 11، الأزرق 24، الأصفر 37)', () {
      expect(controller.players[0].entryBeforeHome, 50);
      expect(controller.players[1].entryBeforeHome, 11);
      expect(controller.players[2].entryBeforeHome, 24);
      expect(controller.players[3].entryBeforeHome, 37);

      expect(controller.simulateMovement(50, 1, controller.players[0]), 52);
      expect(controller.simulateMovement(11, 1, controller.players[1]), 52);
      expect(controller.simulateMovement(24, 1, controller.players[2]), 52);
      expect(controller.simulateMovement(37, 1, controller.players[3]), 52);
    });

    test('5. حماية الخانات الآمنة وأكل الخصم في خانة غير آمنة', () async {
      // حماية الخانة الآمنة
      controller.players[0].tokenPositions[0] = 8;
      controller.players[1].tokenPositions[0] = 5;
      controller.diceValue = 3;
      controller.currentTurnIndex = 1;
      controller.hasRolled = true;
      await controller.moveToken(1, 0);
      expect(controller.players[0].tokenPositions[0], 8); // لم يُؤكل

      // أكل الخصم في خانة غير آمنة
      controller.players[0].tokenPositions[0] = 5;
      controller.players[1].tokenPositions[0] = 2;
      controller.diceValue = 3;
      controller.currentTurnIndex = 1;
      controller.hasRolled = true;
      await controller.moveToken(1, 0);
      expect(controller.players[0].tokenPositions[0], -1); // عاد للقاعدة
    });

    test('6. اختبار منع أكل أي حجر موجود في المسار النهائي (من 52 إلى 57) عبر وصول فعلي إلى خانة مشتركة', () async {
      controller.players[0].tokenPositions[0] = 54; // حجر في المسار النهائي
      controller.players[1].tokenPositions[0] = 51; // حجر يقف قبل الدخول للمسار النهائي

      controller.diceValue = 3;
      controller.currentTurnIndex = 1;
      controller.hasRolled = true;

      // حجر اللاعب الثاني يتحرك إلى الخانة 54 (التي تتطابق رقمياً مع المسار النهائي للأول)
      await controller.moveToken(1, 0);
      
      // التأكد أن حجر اللاعب الأول داخل المسار النهائي محمي تماماً ولم يُؤكل
      expect(controller.players[0].tokenPositions[0], 54);
    });

    test('7. وصول الأحجار الأربعة إلى 58 يحدد isGameOver = true ويوقف اللعبة تماماً ويمنع رمي النرد والحركة', () async {
      for (int i = 0; i < 3; i++) {
        controller.players[0].tokenPositions[i] = 58;
      }
      controller.players[0].tokenPositions[3] = 57;
      controller.diceValue = 1;
      controller.hasRolled = true;
      controller.currentTurnIndex = 0;

      expect(controller.isGameOver, false);
      await controller.moveToken(0, 3);
      
      expect(controller.players[0].hasWon, true);
      expect(controller.isGameOver, true);

      // محاولة رمي النرد أو الحركة بعد انتهاء اللعبة يجب أن تُرفض تماماً
      int preDice = controller.diceValue;
      controller.rollDice();
      expect(controller.diceValue, preDice);
    });

    test('8. التأكد أن الحركة القديمة بعد resetGame لا تعدّل أي متغير في الجلسة الجديدة وتلغي الأثر تماماً', () async {
      int initialSession = controller.gameSessionId;
      controller.players[0].tokenPositions[0] = 20;
      controller.diceValue = 2;
      controller.hasRolled = true;

      var moveFuture = controller.moveToken(0, 0);
      expect(controller.isAnimatingMove, true);

      controller.resetGame();
      await moveFuture;

      expect(controller.gameSessionId, initialSession + 1);
      expect(controller.players[0].tokenPositions[0], -1);
      expect(controller.isGameOver, false);
      expect(controller.isAnimatingMove, false);
    });
  });
}
