
// ================= شاشة الألعاب الترفيهية =================
class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قسم الألعاب والترفيه'),
        backgroundColor: const Color(0xFF111A16),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'استمتع بأوقاتك العب وتحدى أصدقاءك (قسم خاص للترفيه والتسلية):',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          _buildEntertainmentGameCard(
            context,
            'لعبة لودو (Ludo Star)',
            'العب وتحدى الأصدقاء لأوقات ممتعة',
            Icons.casino_rounded,
            Colors.amber,
          ),

          _buildEntertainmentGameCard(
            context,
            'لعبة الشطرنج (Chess)',
            'اختبر ذكاءك الاستراتيجي في مباريات هادئة',
            Icons.sports_esports_rounded,
            Colors.blueAccent,
          ),

          _buildEntertainmentGameCard(
            context,
            'لعبة الدومينو (Dominoes)',
            'أقوى جلسات التحدي والتسلية الجماعية',
            Icons.dashboard_rounded,
            Colors.tealAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildEntertainmentGameCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: const Color(0xFF141F1B),
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),

        leading: CircleAvatar(
          radius: 26,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 28),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),

        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color.withOpacity(0.2),
            foregroundColor: color,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'جاري بدء لعبة $title',
                  textDirection: TextDirection.rtl,
                ),
              ),
            );
          },

          child: const Text(
            'العب للترفيه',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
