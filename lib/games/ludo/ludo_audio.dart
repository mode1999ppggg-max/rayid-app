import 'package:audioplayers/audioplayers.dart';

class LudoAudio {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playCyberSound() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/cyber_beep.mp3'));
    } catch (e) {
      // تفادي التوقف في حال عدم وجود ملف خارجي
    }
  }
}
