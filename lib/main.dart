import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rayid Points',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PointsHomePage(),
    );
  }
}

class PointsHomePage extends StatefulWidget {
  const PointsHomePage({super.key});

  @override
  State<PointsHomePage> createState() => _PointsHomePageState();
}

class _PointsHomePageState extends State<PointsHomePage> {
  int _points = 0;

  void _incrementPoints() {
    setState(() {
      _points += 10; // كل ضغطة تزيد 10 نقاط
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق الأرباح والنقاط'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'رصيدك الحالي من النقاط:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text(
              '$_points نقطة',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _incrementPoints,
              icon: const Icon(Icons.add_circle),
              label: const Text('اضغط لربح 10 نقاط', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
