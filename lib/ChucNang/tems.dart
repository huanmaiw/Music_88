import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Điều khoản dịch vụ"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1. Giới thiệu",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Chào mừng bạn đến với ứng dụng của chúng tôi. Bằng cách sử dụng ứng dụng này, bạn đồng ý với các điều khoản dưới đây.",
              ),
              SizedBox(height: 16),
              Text(
                "2. Quyền và trách nhiệm",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Bạn có trách nhiệm bảo mật thông tin tài khoản của mình. Chúng tôi không chịu trách nhiệm nếu tài khoản của bạn bị xâm nhập do bất cẩn.",
              ),
              SizedBox(height: 16),
              Text(
                "3. Chính sách bảo mật",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Chúng tôi cam kết bảo vệ quyền riêng tư của bạn. Mọi thông tin cá nhân sẽ được bảo mật theo chính sách của chúng tôi.",
              ),
              SizedBox(height: 16),
              Text(
                "4. Liên hệ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Nếu có bất kỳ thắc mắc nào, vui lòng liên hệ với chúng tôi qua email: kieu@gmail.com",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
