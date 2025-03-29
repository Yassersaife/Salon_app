import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/providers/user_provider.dart';
import 'package:salon_booking_app/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return CustomScrollView(
            slivers: [
              // شريط التطبيق مع معلومات المستخدم
              SliverAppBar(
                expandedHeight: 200.0,
                pinned: true,
                backgroundColor: AppColors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // خلفية متدرجة
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              AppColors.primary,
                              AppColors.darkPurple,
                            ],
                          ),
                        ),
                      ),
                      // معلومات المستخدم
                      Positioned(
                        bottom: 20,
                        right: 20,
                        left: 20,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              backgroundImage: userProvider.currentUser?.imageUrl != null
                                  ? AssetImage(userProvider.currentUser!.imageUrl!)
                                  : null,
                              child: userProvider.currentUser?.imageUrl == null
                                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    userProvider.currentUser?.name ?? 'مستخدم الريلاكس',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    userProvider.currentUser?.email ?? 'user@example.com',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    userProvider.currentUser?.phone ?? '055xxxxxxx',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // قائمة الخيارات
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // قسم الحساب
                    _buildSectionTitle(context, 'الحساب'),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.person_outline,
                      title: 'تعديل الملف الشخصي',
                      onTap: () {
                        // انتقال إلى صفحة تعديل الملف الشخصي
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.favorite_border,
                      title: 'الصالونات المفضلة',
                      onTap: () {
                        // انتقال إلى صفحة المفضلة
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.notifications_outlined,
                      title: 'الإشعارات',
                      onTap: () {
                        // انتقال إلى صفحة الإشعارات
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.location_on_outlined,
                      title: 'العناوين المحفوظة',
                      onTap: () {
                        // انتقال إلى صفحة العناوين
                      },
                    ),

                    const Divider(),

                    // قسم المساعدة والدعم
                    _buildSectionTitle(context, 'المساعدة والدعم'),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.help_outline,
                      title: 'الأسئلة الشائعة',
                      onTap: () {
                        _showFAQDialog(context);
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.headset_mic_outlined,
                      title: 'اتصل بنا',
                      onTap: () {
                        _showContactDialog(context);
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.policy_outlined,
                      title: 'سياسة الخصوصية',
                      onTap: () {
                        // عرض سياسة الخصوصية
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.description_outlined,
                      title: 'شروط الاستخدام',
                      onTap: () {
                        // عرض شروط الاستخدام
                      },
                    ),

                    const Divider(),

                    // قسم حول التطبيق
                    _buildSectionTitle(context, 'حول التطبيق'),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.info_outline,
                      title: 'عن التطبيق',
                      onTap: () {
                        _showAboutAppDialog(context);
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.star_border,
                      title: 'تقييم التطبيق',
                      onTap: () {
                        // فتح صفحة التقييم في متجر التطبيقات
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.share_outlined,
                      title: 'مشاركة التطبيق',
                      onTap: () {
                        // مشاركة رابط التطبيق
                      },
                    ),

                    const Divider(),

                    // زر تسجيل الخروج
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showLogoutDialog(context, userProvider);
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('تسجيل الخروج'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),

                    // معلومات الإصدار
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        'الإصدار 1.0.0',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 8, top: 16),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, color: AppColors.primary),

      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 16),
    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
        ],
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
        textAlign: TextAlign.right,
      )
          : null,
    );
  }

  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تسجيل الخروج',
          textAlign: TextAlign.right,
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await userProvider.logout();
              // يمكن هنا الانتقال إلى صفحة تسجيل الدخول
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  void _showFAQDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'الأسئلة الشائعة',
          textAlign: TextAlign.right,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFAQItem(
                question: 'كيف يمكنني حجز موعد؟',
                answer: 'يمكنك حجز موعد من خلال اختيار الصالون المناسب، ثم اختيار الخدمة والوقت المناسب، ثم تأكيد الحجز.',
              ),
              _buildFAQItem(
                question: 'كيف يمكنني إلغاء موعد؟',
                answer: 'يمكنك إلغاء موعد من خلال الانتقال إلى صفحة "حجوزاتي"، ثم الضغط على زر "إلغاء الحجز" أسفل الحجز المراد إلغاؤه.',
              ),
              _buildFAQItem(
                question: 'هل يمكنني تعديل موعد محجوز؟',
                answer: 'للأسف، لا يمكن تعديل المواعيد المحجوزة. يمكنك إلغاء الموعد الحالي وحجز موعد جديد.',
              ),
              _buildFAQItem(
                question: 'كيف يمكنني الدفع؟',
                answer: 'يمكنك الدفع في الصالون مباشرة بعد تلقي الخدمة، أو من خلال بطاقات الائتمان/الخصم إذا كان الصالون يدعم ذلك.',
              ),
              _buildFAQItem(
                question: 'هل يمكنني حجز موعد لشخص آخر؟',
                answer: 'نعم، يمكنك حجز موعد لشخص آخر باستخدام حسابك، مع إمكانية تحديد اسم الشخص في ملاحظات الحجز.',
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'اتصل بنا',
          textAlign: TextAlign.right,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildContactItem(
              icon: Icons.email_outlined,
              title: 'البريد الإلكتروني',
              value: 'support@relaxapp.com',
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              icon: Icons.phone_outlined,
              title: 'رقم الهاتف',
              value: '+966 55 123 4567',
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              icon: Icons.access_time_outlined,
              title: 'ساعات العمل',
              value: 'من الأحد إلى الخميس، 9 صباحاً - 5 مساءً',
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              icon: Icons.location_on_outlined,
              title: 'العنوان',
              value: 'طريق الملك فهد، الرياض، المملكة العربية السعودية',
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Icon(icon, color: AppColors.primary),
      ],
    );
  }

  void _showAboutAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'عن التطبيق',
          textAlign: TextAlign.right,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.spa,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'تطبيق ريلاكس',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'الإصدار 1.0.0',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'تطبيق ريلاكس هو منصة متكاملة لحجز مواعيد صالونات التجميل. يتيح التطبيق للمستخدمين البحث عن الصالونات القريبة، واختيار الخدمات المناسبة، وحجز المواعيد بكل سهولة ويسر.',
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              '© 2023 تطبيق ريلاكس. جميع الحقوق محفوظة.',
              style: TextStyle(
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}