// ================= 5. شاشة لعبة Neon Cyber Run (الكرة المتغيرة الألوان والمنظور الحيوي) =================
class NeonCyberRunGameScreen extends StatefulWidget {
  const NeonCyberRunGameScreen({super.key});

  @override
  State<NeonCyberRunGameScreen> createState() => _NeonCyberRunGameScreenState();
}

class _NeonCyberRunGameScreenState extends State<NeonCyberRunGameScreen> with SingleTickerProviderStateMixin {
  int _score = 120;
  int _coins = 12;
  int _distance = 45;
  int _level = 1;
  bool _isPlaying = false;
  Timer? _timer;
  int _playerLane = 1; // 0: يسار, 1: وسط, 2: يمين

  late AnimationController _colorController;
  final List<Color> _neonColors = [
    const Color(0xFF00FF88),
    const Color(0xFF00E5FF),
    const Color(0xFFFF007F),
    const Color(0xFFFFB703),
  ];
  int _colorIndex = 0;

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _colorController.addListener(() {
      if (_isPlaying) {
        setState(() {
          _colorIndex = (_colorController.value * _neonColors.length).floor() % _neonColors.length;
        });
      }
    });
  }

  void _startGame() {
    setState(() {
      _isPlaying = true;
      _score = 120;
      _distance = 45;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        _distance += 5; // حركة واقعية محسوبة وليست سريعة بشكل مزعج
        _score += 10;
        if (_distance % 100 == 0) {
          _coins += 1;
          _level = (_distance / 200).floor() + 1;
        }
      });
    });
  }

  void _stopGame() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('نهاية الجولة! جمعت $_score نقطة و $_coins عملة')),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color currentColor = _neonColors[_colorIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF050811),
      appBar: AppBar(
        title: const Text('NEON CYBER RUN', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
        backgroundColor: const Color(0xFF0D1B2A),
      ),
      body: Stack(
        children: [
          // رسم الطريق والمنظور الثلاثي الأبعاد المتحرك
          Positioned.fill(
            child: CustomPaint(
              painter: NeonRoadPainter(isMoving: _isPlaying),
            ),
          ),

          // العدادات والواجهة في الزوايا
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('SCORE', style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1)),
                        Text('$_score', style: const TextStyle(color: Color(0xFFFFB703), fontSize: 22, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        const Text('COINS', style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1)),
                        Row(
                          children: [
                            const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text('$_coins', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('LEVEL', style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1)),
                        Text('$_level', style: const TextStyle(color: Color(0xFF00FF88), fontSize: 22, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        const Text('DISTANCE', style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1)),
                        Text('${_distance}m', style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 16, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),

                // أزرار التحكم والبدء
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('BOOST 95%', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('ACTIVE BALL', style: TextStyle(color: currentColor, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (!_isPlaying)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00FF88),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: _startGame,
                          child: const Text('اضغط هنا لبدء لعبة الكرة المضيئة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), foregroundColor: Colors.black),
                            onPressed: () => setState(() => _playerLane = 0),
                            child: const Icon(Icons.arrow_left_rounded, size: 30),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                            onPressed: _stopGame,
                            child: const Text('إيقاف', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF88), foregroundColor: Colors.black),
                            onPressed: () => setState(() => _playerLane = 2),
                            child: const Icon(Icons.arrow_right_rounded, size: 30),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),

          // كرة النيون المتوهجة التي تتغير ألوانها بسلاسة وتتحرك بين المسارات
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            bottom: 120,
            left: _playerLane == 0 
                ? MediaQuery.of(context).size.width * 0.28 
                : (_playerLane == 1 ? MediaQuery.of(context).size.width * 0.44 : MediaQuery.of(context).size.width * 0.60),
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentColor,
                boxShadow: [
                  BoxShadow(color: currentColor.withOpacity(0.9), blurRadius: 25, spreadRadius: 5),
                  const BoxShadow(color: Colors.white, blurRadius: 5, spreadRadius: 1),
                ],
              ),
              child: const Center(
                child: Icon(Icons.bolt, color: Colors.black, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// رسم الطريق بالمنظور الفخم
class NeonRoadPainter extends CustomPainter {
  final bool isMoving;
  NeonRoadPainter({required this.isMoving});

  @override
  void paint(Canvas canvas, Size size) {
    final paintRoad = Paint()
      ..color = const Color(0xFF0B132B)
      ..style = PaintingStyle.fill;

    final paintLines = Paint()
      ..color = const Color(0xFF00E5FF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final paintGlow = Paint()
      ..color = const Color(0xFF00FF88).withOpacity(0.4)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    // مسار الطريق المنظوري الواسع والمريح
    Path roadPath = Path();
    roadPath.moveTo(size.width * 0.15, size.height);
    roadPath.lineTo(size.width * 0.85, size.height);
    roadPath.lineTo(size.width * 0.58, size.height * 0.35);
    roadPath.lineTo(size.width * 0.42, size.height * 0.35);
    roadPath.close();

    canvas.drawPath(roadPath, paintRoad);

    // خطوط النيون الجانبية المتوهجة
    canvas.drawLine(Offset(size.width * 0.15, size.height), Offset(size.width * 0.42, size.height * 0.35), paintGlow);
    canvas.drawLine(Offset(size.width * 0.85, size.height), Offset(size.width * 0.58, size.height * 0.35), paintGlow);

    canvas.drawLine(Offset(size.width * 0.15, size.height), Offset(size.width * 0.42, size.height * 0.35), paintLines);
    canvas.drawLine(Offset(size.width * 0.85, size.height), Offset(size.width * 0.58, size.height * 0.35), paintLines);
  }

  @override
  bool shouldRepaint(covariant NeonRoadPainter oldDelegate) => oldDelegate.isMoving != isMoving;
}
