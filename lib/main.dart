// ================= 7. شاشة الإعدادات والتحكم بالحساب =================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات الحساب'), backgroundColor: const Color(0xff0b1017), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xff00ff88), width: 2)),
                  child: const CircleAvatar(radius: 40, backgroundColor: Color(0xff121b26), child: Icon(Icons.person, size: 40, color: Color(0xff00ff88))),
                ),
                const SizedBox(height: 12),
                const Text('لاعب_570575', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                const Text('ID: #RAYID-9924', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSettingTile(context, Icons.person_outline, 'تعديل الملف الشخصي', const EditProfileScreen()),
          _buildSettingTile(context, Icons.security, 'الأمان وحماية الحساب', const SecurityScreen()),
          _buildSettingTile(context, Icons.notifications_none, 'إعدادات الإشعارات', const NotificationsSettingsScreen()),
          _buildSettingTile(context, Icons.language, 'لغة التطبيق (العربية)', const LanguageScreen()),
          _buildSettingTile(context, Icons.help_outline, 'الدعم الفني والمساعدة', const SupportScreen()),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.15),
              foregroundColor: Colors.redAccent,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.redAccent, width: 1)),
            ),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل الخروج بنجاح')));
            },
            child: const Text('تسجيل الخروج', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, IconData icon, String title, Widget destinationScreen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xff121b26), borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xff00ff88)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => destinationScreen));
        },
      ),
    );
  }
}

// ================= شاشات الإعدادات الفرعية الفخمة =================

// 1. تعديل الملف الشخصي
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل الملف الشخصي'), backgroundColor: const Color(0xff0b1017)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: 'اسم اللاعب', labelStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xff121b26), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)),
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: 'البريد الإلكتروني', labelStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xff121b26), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00ff88), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ التعديلات بنجاح!'), backgroundColor: Colors.green));
              },
              child: const Text('حفظ التغييرات', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. الأمان وحماية الحساب
class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأمان وحماية الحساب'), backgroundColor: const Color(0xff0b1017)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('التحقق بخطوتين (PIN)', style: TextStyle(color: Colors.white)),
            subtitle: const Text('حماية إضافية لمحفظتك وأموالك', style: TextStyle(color: Colors.grey, fontSize: 12)),
            value: true,
            activeColor: const Color(0xff00ff88),
            onChanged: (val) {},
          ),
          const Divider(color: Colors.white12),
          ListTile(
            title: const Text('تغيير كلمة المرور', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال رابط تغيير كلمة المرور لبريدك')));
            },
          ),
        ],
      ),
    );
  }
}

// 3. إعدادات الإشعارات
class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات الإشعارات'), backgroundColor: const Color(0xff0b1017)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('إشعارات المعاملات والأموال', style: TextStyle(color: Colors.white)),
            value: true,
            activeColor: const Color(0xff00ff88),
            onChanged: (val) {},
          ),
          SwitchListTile(
            title: const Text('إشعارات الألعاب والمسابقات', style: TextStyle(color: Colors.white)),
            value: true,
            activeColor: const Color(0xff00ff88),
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
}

// 4. لغة التطبيق
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لغة التطبيق'), backgroundColor: const Color(0xff0b1017)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RadioListTile(
            title: const Text('العربية', style: TextStyle(color: Colors.white)),
            value: true,
            groupValue: true,
            activeColor: const Color(0xff00ff88),
            onChanged: (val) {},
          ),
          RadioListTile(
            title: const Text('English', style: TextStyle(color: Colors.white)),
            value: false,
            groupValue: true,
            activeColor: const Color(0xff00ff88),
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
}

// 5. الدعم الفني
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: constText('الدعم الفني والمساعدة'), backgroundColor: const Color(0xff0b1017)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('هل تواجه مشكلة؟ فريق الدعم متواجد لمساعدتك على مدار الساعة.', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff00ff88), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.chat),
              label: const Text('مراسلة الدعم المباشر', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري فتح محادثة الدعم الفني...')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
