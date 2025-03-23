import 'package:flutter/material.dart';
import 'package:music_app/ChucNang/rate.dart';
import 'package:music_app/ChucNang/tems.dart';
import 'package:music_app/ChucNang/temsss.dart';
import 'helper.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildSettingItem(Icons.info, "Phiên bản", context, version: "25.02"),
          _buildSettingItem(Icons.help, "Trợ giúp và báo lỗi", context, onTap: () {
            _navigateToHelpAndReport(context);
          }),
          _buildSettingItem(Icons.star, "Bình chọn cho Zing MP5", context, onTap: (){
            showRatingDialog(context);
          }),
          _buildSettingItem(Icons.description, "Điều khoản dịch vụ", context, onTap: () {
            _navigateToTermsOfService(context);
          }),
          _buildSettingItem(Icons.security, "Chính sách bảo mật", context, onTap: () {
            _navigateToPrivacyPolicy(context);
          }),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, BuildContext context,
      {bool isNew = false, String? version, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Row(
        children: [
          Text(title),
          if (isNew)
            Container(
              margin: EdgeInsets.only(left: 5),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("MỚI", style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
        ],
      ),
      trailing: version != null ? Text(version) : Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _navigateToHelpAndReport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Helper()),
    );
  }

  void _navigateToTermsOfService(BuildContext context) {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TermsOfServiceScreen()),
    );
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TermsOfServiceScreenss()),
    );
  }
}

