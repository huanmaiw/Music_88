import 'package:flutter/material.dart';

class Helper extends StatefulWidget {
  const Helper({super.key});

  @override
  State<Helper> createState() => _HelperState();
}

class _HelperState extends State<Helper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trợ giúp và báo lỗi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Zing MP3",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Zing MP3 là nền tảng âm nhạc trực tuyến với nhiều tính năng nổi bật giúp bạn có trải nghiệm nghe nhạc tuyệt vời nhất trên nhiều thiết bị."

              ),
              SizedBox(height: 16),
              Text(
                "Tôi có thể sử dụng trên thiết bị nào ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Bạn có thể sử dụng Zing MP3 trên:\n"
                    "- Các thiết bị Android/iOS: điện thoại, máy tính bảng\n - Máy tính (hệ điều hành Windows và MacOS) thông qua website hoặc ứng dụng dành riêng cho Windows"
              ),
              SizedBox(height: 16),
              Text(
                "Các kênh hỗ trợ của Zing MP3",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Để được hỗ trợ, vui lòng liên hệ với chúng tôi qua đường link này hoặc gửi tin nhắn đến số điện thoại Zalo 0934118443",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
