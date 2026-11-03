// ================= شاشة طرق السحب بالدولار (مفعلة وتفاعلية) =================
class RedeemScreen extends StatefulWidget {
  const RedeemScreen({super.key});

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  
  void _showRedeemDialog(BuildContext context, String methodTitle, String minAmount) {
    final accountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2A27),
        title: Text('سحب الأرباح عبر $methodTitle', style: const TextStyle(color: Colors.greenAccent, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الحد الأدنى للسحب: $minAmount', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: accountController,
              decoration: InputDecoration(
                labelText: methodTitle.contains('PayPal') || methodTitle.contains('MasterCard') 
                    ? 'أدخل البريد أو رقم البطاقة' 
                    : 'أدخل رقم الهاتف / المحفظة',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF121816),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
            onPressed: () {
              if (accountController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الرجاء إدخال رقم الحساب أو المحفظة')),
                );
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم تقديم طلب السحب عبر $methodTitle بنجاح!')),
              );
            },
            child: const Text('تأكيد الطلب'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طرق سحب الأرباح (\$ USD)'),
        backgroundColor: const Color(0xFF1A2321),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'اختر طريقة السحب المناسبة (العملة بالدولار الأمريكي):',
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          _buildRedeemOption(context, 'AsiaCell Cash (آسياسيل)', '\$5 USD الحد الأدنى', Icons.sim_card, Colors.red, () {
            _showRedeemDialog(context, 'آسياسيل', '\$5 USD');
          }),
          _buildRedeemOption(context, 'ZainCash (زين كاش)', '\$5 USD الحد الأدنى', Icons.phone_android, Colors.orange, () {
            _showRedeemDialog(context, 'زين كاش', '\$5 USD');
          }),
          _buildRedeemOption(context, 'MasterCard (ماستر كارد)', '\$10 USD الحد الأدنى', Icons.credit_card, Colors.blue, () {
            _showRedeemDialog(context, 'ماستر كارد', '\$10 USD');
          }),
          _buildRedeemOption(context, 'PayPal (بايبال)', '\$10 USD الحد الأدنى', Icons.account_balance_wallet, Colors.indigo, () {
            _showRedeemDialog(context, 'بايبال', '\$10 USD');
          }),
        ],
      ),
    );
  }

  Widget _buildRedeemOption(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      color: const Color(0xFF1E2A27),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green),
        onTap: onTap,
      ),
    );
  }
}
