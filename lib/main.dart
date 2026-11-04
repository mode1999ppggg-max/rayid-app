// ================= 7. شاشة الإعدادات والتحكم بالحساب =================

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b1017),
      appBar: AppBar(
        title: const Text('إعدادات الحساب'),
        backgroundColor: const Color(0xff0b1017),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xff00ff88),
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xff121b26),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xff00ff88),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'لاعب_570575',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'ID: #RAYID-9924',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _buildSettingTile(
            context,
            Icons.person_outline,
            'تعديل الملف الشخصي',
            const EditProfileScreen(),
          ),

          _buildSettingTile(
            context,
            Icons.security,
            'الأمان وحماية الحساب',
            const SecurityScreen(),
          ),

          _buildSettingTile(
            context,
            Icons.notifications_none,
            'إعدادات الإشعارات',
            const NotificationsSettingsScreen(),
          ),

          _buildSettingTile(
            context,
            Icons.language,
            'لغة التطبيق',
            const LanguageScreen(),
          ),

          _buildSettingTile(
            context,
            Icons.help_outline,
            'الدعم الفني والمساعدة',
            const SupportScreen(),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.15),
              foregroundColor: Colors.redAccent,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                  color: Colors.redAccent,
                  width: 1,
                ),
              ),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تسجيل الخروج بنجاح'),
                ),
              );
            },
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    IconData icon,
    String title,
    Widget destinationScreen,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xff121b26),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xff00ff88),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => destinationScreen,
            ),
          );
        },
      ),
    );
  }
}

// ================= تعديل الملف الشخصي =================

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController =
      TextEditingController(text: 'لاعب_570575');

  final TextEditingController emailController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b1017),
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي'),
        backgroundColor: const Color(0xff0b1017),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('اسم اللاعب'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('البريد الإلكتروني'),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff00ff88),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يرجى إدخال اسم اللاعب'),
                    ),
                  );
                  return;
                }

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حفظ التعديلات بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text(
                'حفظ التغييرات',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= الأمان وحماية الحساب =================

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool twoFactorEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b1017),
      appBar: AppBar(
        title: const Text('الأمان وحماية الحساب'),
        backgroundColor: const Color(0xff0b1017),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text(
              'التحقق بخطوتين (PIN)',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'حماية إضافية لمحفظتك وأموالك',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            value: twoFactorEnabled,
            activeColor: const Color(0xff00ff88),
            onChanged: (value) {
              setState(() {
                twoFactorEnabled = value;
              });
            },
          ),
          const Divider(color: Colors.white12),
          ListTile(
            title: const Text(
              'تغيير كلمة المرور',
              style: TextStyle(color: Colors.white),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('خدمة تغيير كلمة المرور تحتاج ربطاً بالخادم'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ================= إعدادات الإشعارات =================

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool moneyNotifications = true;
  bool gameNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b1017),
      appBar: AppBar(
        title: const Text('إعدادات الإشعارات'),
        backgroundColor: const Color(0xff0b1017),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text(
              'إشعارات المعاملات والأموال',
              style: TextStyle(color: Colors.white),
            ),
            value: moneyNotifications,
            activeColor: const Color(0xff00ff88),
            onChanged: (value) {
              setState(() {
                moneyNotifications = value;
              });
            },
          ),
          const Divider(color: Colors.white12),
          SwitchListTile(
            title: const Text(
              'إشعارات الألعاب والمسابقات',
              style: TextStyle(color: Colors.white),
            ),
            value: gameNotifications,
            activeColor: const Color(0xff00ff88),
            onChanged: (value) {
              setState(() {
                gameNotifications = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

// ================= لغة التطبيق =================

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = 'ar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b1017),
      appBar: AppBar(
        title: const Text('لغة التطبيق'),
        backgroundColor: const Color(0xff0b1017),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RadioListTile<String>(
            title: const Text(
              'العربية',
              style: TextStyle(color: Colors.white),
            ),
            value: 'ar',
            groupValue: selectedLanguage,
            activeColor: const Color(0xff00ff88),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedLanguage = value;
                });
              }
            },
          ),
          RadioListTile<String>(
            title: const Text(
              'English',
              style: TextStyle(color: Colors.white),
            ),
            value: 'en',
            groupValue: selectedLanguage,
            activeColor: const Color(0xff00ff88),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedLanguage = value;
                });
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'تغيير الاختيار هنا لا يترجم التطبيق بالكامل بعد؛ يحتاج ربط نظام الترجمة.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= الدعم الفني =================

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b1017),
      appBar: AppBar(
        title: const Text('الدعم الفني والمساعدة'),
        backgroundColor: const Color(0xff0b1017),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.support_agent,
              size: 80,
              color: Color(0xff00ff88),
            ),
            const SizedBox(height: 20),
            const Text(
              'هل تواجه مشكلة؟',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'فريق الدعم متواجد لمساعدتك. يمكنك التواصل معنا عند مواجهة أي مشكلة في حسابك.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff00ff88),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.chat),
              label: const Text(
                'مراسلة الدعم المباشر',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'خدمة المحادثة تحتاج ربطاً بنظام الدعم الفني',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ================= تصميم حقول الإدخال =================

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.grey),
    filled: true,
    fillColor: const Color(0xff121b26),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.white12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xff00ff88),
        width: 1.5,
      ),
    ),
  );
}
