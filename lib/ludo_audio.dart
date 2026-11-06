import 'package:audioplayers/audioplayers.dart';

class LudoAudio {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playCyberSound() async {
    try {
      // تشغيل تأثير صوتي تفاعلي سيبيراني خفيف
      await _player.stop();
      await _player.play(AssetSource('sounds/cyber_beep.mp3'));
    } catch (e) {
      // في حال عدم توفر الملف الخارجي، يتفاعل النظام بدون توقف اللعبة
    }
  }
}
