import 'package:academic_activities_mobile/cores/widgets/appbar.dart';
import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBarWidget(
        title: "Cài Đặt",
        action: IconButton(
          icon: const Icon(Icons.home_rounded, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigation.changeTab(0);  
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildSettingsSection(
              title: 'Tài khoản',
              items: [
                _SettingItem(
                  icon: FontAwesomeIcons.user,
                  title: 'Thông tin cá nhân',
                  onTap: () {},
                ),
                _SettingItem(
                  icon: FontAwesomeIcons.lock,
                  title: 'Đổi mật khẩu',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsSection(
              title: 'Thông báo',
              items: [
                _SettingItem(
                  icon: FontAwesomeIcons.bell,
                  title: 'Thông báo hoạt động',
                  trailing: Switch(value: true, onChanged: (v) {}),
                ),
                _SettingItem(
                  icon: FontAwesomeIcons.envelope,
                  title: 'Thông báo qua email',
                  trailing: Switch(value: false, onChanged: (v) {}),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsSection(
              title: 'Khác',
              items: [
                _SettingItem(
                  icon: FontAwesomeIcons.circleInfo,
                  title: 'Về ứng dụng',
                  onTap: () {},
                ),
                _SettingItem(
                  icon: FontAwesomeIcons.fileContract,
                  title: 'Điều khoản sử dụng',
                  onTap: () {},
                ),
                _SettingItem(
                  icon: FontAwesomeIcons.shield,
                  title: 'Chính sách bảo mật',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<_SettingItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                _buildSettingItem(items[i]),
                if (i != items.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(_SettingItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FaIcon(
                  item.icon,
                  size: 16,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              item.trailing ??
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Color(0xFFCBD5E1),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  _SettingItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
  });
}