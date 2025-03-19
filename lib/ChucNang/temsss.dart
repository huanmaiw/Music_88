import 'package:flutter/material.dart';

class TermsOfServiceScreenss extends StatelessWidget {
  const TermsOfServiceScreenss({super.key});

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
              _buildSectionTitle("1. Giới thiệu"),
              _buildParagraph(
                "1. Các Dữ liệu cá nhân của Khách hàng có thể được VNG thu thập và xử lý bao gồm và/hoặc không giới hạn các loại dữ liệu cá nhân sau: ...",
              ),
              _buildSubTitle("Thu thập các dữ liệu khác:"),
              _buildParagraph(
                  "Như với hầu hết các Trang Web/Ứng Dụng và các ứng dụng di động khác, thiết bị của Bạn gửi thông tin có thể gồm có: dữ liệu về Bạn, được một máy chủ ghi lại khi Bạn sử dụng Các Dịch Vụ của VNG. Thông tin này thường bao gồm nhưng không giới hạn địa chỉ IP, hệ điều hành của máy tính/thiết bị di động, loại trình duyệt, loại thiết bị di động, các đặc điểm của thiết bị di động, mã định danh thiết bị duy nhất (UDID) hoặc mã định danh thiết bị di động (MEID) của thiết bị di động của Bạn, địa chỉ tham chiếu của Trang Web/Ứng Dụng (nếu có), các trang mà Bạn đã truy cập đến trên Trang Web/Ứng Dụng hoặc ứng dụng di động của VNG và thời gian truy cập và đôi khi là \"cookie\" (có thể vô hiệu hóa bằng cách sử dụng tùy chọn trình duyệt của Bạn) để giúp Trang Web/Ứng Dụng ghi nhớ lần truy cập cuối cùng của Bạn. Nếu Bạn đăng nhập, thông tin này được liên kết với tài khoản cá nhân của Bạn. Thông tin này cũng được đưa vào các số liệu thống kê ẩn danh để giúp Chúng tôi hiểu được khách hàng đã truy cập sử dụng Dịch vụ và Trang Web/Ứng Dụng của Chúng tôi như thế nào."),
              _buildParagraph(
                  "Các Dịch Vụ của VNG có thể sử dụng các công nghệ như ARKit (Agumented Reality hay gọi tắt là AR – Công nghệ thực tế ảo), Camera API, TrueDepth API … hoặc các công nghệ tương tự được cung cấp bởi hệ điều hành của thiết bị di động; các công nghệ này được sử dụng để ghi nhận thông tin biểu hiện trên khuôn mặt của người dùng và dùng cho tính năng trong ứng dụng. Đối với các thông tin này, Chúng tôi không sử dụng cho bất kỳ mục đích nào khác ngoài các tính năng được cung cấp trong ứng dụng; Bạn có quyền từ chối cấp quyền truy cập camera cho các tính năng này bất kỳ lúc nào (nhưng Bạn cần lưu ý rằng, khi Bạn ngưng cấp quyền truy cập camera cho ứng dụng thì một số tính năng của ứng dụng sẽ không thể hoạt động được); và Chúng tôi không lưu trữ cũng như không chia sẻ các thông tin này cho bất kỳ bên thứ ba nào."),
              _buildParagraph("Đôi khi Chúng tôi có thể sử dụng \"cookie\" hoặc các tính năng khác để cho phép Chúng tôi hoặc các bên thứ ba thu thập hoặc chia sẻ thông tin sẽ giúp Chúng tôi cải thiện Trang Web/Ứng Dụng, Dịch vụ của mình và Các Dịch Vụ mà Chúng tôi cung cấp, hoặc giúp Chúng tôi đưa ra các dịch vụ và tính năng mới. \"Cookie\" là các mã định danh Chúng tôi gửi đến máy tính hoặc thiết bị di động của Bạn, cho phép Chúng tôi nhận dạng máy tính hoặc thiết bị của Bạn và cho Chúng tôi biết khi nào Các Dịch Vụ hoặc Trang Web/Ứng Dụng được sử dụng hay truy cập, bởi bao nhiêu người và để theo dõi những hoạt động trong Trang Web/Ứng Dụng hoặc Các Dịch vụ của Chúng tôi. Chúng tôi có thể liên kết thông tin cookie với Dữ Liệu Cá Nhân. Cookie cũng liên kết với thông tin về những nội dung Bạn đã chọn đối với các trang mua sắm bạn đã xem, hoặc các Dịch vụ điện tử mà Bạn đã chơi. Thông tin này được sử dụng để ví dụ như theo dõi giỏ hàng. Cookie cũng được sử dụng để cung cấp nội dung dựa trên quan tâm của Bạn và để theo dõi việc sử dụng của các Dịch Vụ. Bạn có thể từ chối sử dụng cookie bằng cách chọn các thiết lập thích hợp trên trình duyệt của Bạn. Tuy nhiên, vui lòng lưu ý rằng nếu Bạn thực hiện thao tác này Bạn có thể không sử dụng được các chức năng đầy đủ của Trang Web/Ứng Dụng, Dịch vụ hoặc Các Dịch Vụ của Chúng tôi."),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSubTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(text),
    );
  }
}