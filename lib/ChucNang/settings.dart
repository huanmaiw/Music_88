import 'package:flutter/material.dart';


class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Điều khoản sử dụng'),
            onTap: () => _showDialog(context, 'Điều khoản sử dụng', 'MB Bank 482602092003'),
          ),
          ListTile(
            title: const Text('Chính sách bảo mật'),
            onTap: () => _showDialog(context, 'Chính sách bảo mật', 'Nạp tiền vào đi còn làm tay'),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}
