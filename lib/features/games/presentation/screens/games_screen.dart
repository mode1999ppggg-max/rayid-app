
import 'package:flutter/material.dart';
import '../../../../core/localization/app_strings.dart';
import '../widgets/game_card.dart';
import '../../../../games/ludo/ludo_screen.dart';

class GamesScreen extends StatelessWidget {
  final String lang;

  const GamesScreen({
    super.key,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get(lang, 'cyberGames')),
        backgroundColor: const Color(0xff090711),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GameCard(
            title: AppStrings.get(lang, 'gameLudo'),
            icon: Icons.casino,
            color: const Color(0xffFFD166),
            lang: lang,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LudoLobbyScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

