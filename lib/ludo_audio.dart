import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as Math;

class LudoAudio {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playCyberSound() async {
    try {
      await _player.stop();
      
      // توليد تردد نغمة سيبرانية رقمياً بالكامل برمجياً بدون ملفات خارجية
      int sampleRate = 8000;
      double frequency = 880.0;
      double durationInSeconds = 0.08;
      int numSamples = (sampleRate * durationInSeconds).toInt();
      
      var buffer = ByteData(44 + numSamples * 2);
      
      buffer.setUint32(0, 0x52494646, Endian.big);
      buffer.setUint32(4, 36 + numSamples * 2, Endian.little);
      buffer.setUint32(8, 0x57415645, Endian.big);
      buffer.setUint32(12, 0x666d7420, Endian.big);
      buffer.setUint32(16, 16, Endian.little);
      buffer.setUint16(20, 1, Endian.little);
      buffer.setUint16(22, 1, Endian.little);
      buffer.setUint32(24, sampleRate, Endian.little);
      buffer.setUint32(28, sampleRate * 2, Endian.little);
      buffer.setUint32(32, 2, Endian.little);
      buffer.setUint16(34, 16, Endian.little);
      buffer.setUint32(36, 0x64617461, Endian.big);
      buffer.setUint32(40, numSamples * 2, Endian.little);

      for (int i = 0; i < numSamples; i++) {
        double t = i / sampleRate;
        double sample = 32767 * 0.5 * Math.sin(2 * 3.1415926535 * frequency * t) * (1 - (i / numSamples));
        buffer.setInt16(44 + i * 2, sample.toInt(), Endian.little);
      }

      await _player.play(BytesSource(buffer.buffer.asUint8List()));
    } catch (e) {
      // تفادي أي أخطاء لكي تستمر اللعبة بسلاسة
    }
  }
}
