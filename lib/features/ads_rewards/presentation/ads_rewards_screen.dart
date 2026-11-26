
import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';

class AdsRewardsScreen extends StatelessWidget {
  final String lang;

  const AdsRewardsScreen({
    super.key,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.get(lang, 'adsRewardsCenter'),
        ),
        backgroundColor: const Color(0xff090711),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAdTile(
            context,
            AppStrings.get(lang, 'unlimitedAd'),
            AppStrings.get(lang, 'reward'),
          ),
          _buildAdTile(
            context,
            AppStrings.get(lang, 'featuredAd'),
            AppStrings.get(lang, 'reward'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdTile(
    BuildContext context,
    String title,
    String rewardText,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff171225),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$rewardText: +4 Points (تفاعل تجريبي)',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffFFD166),
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    lang == 'ar'
                        ? 'جاري تجهيز نظام الإعلانات'
                        : 'The ads system is being prepared',
                  ),
                ),
              );
            },
            child: Text(
              AppStrings.get(lang, 'watchNow'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

