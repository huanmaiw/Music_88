import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/model/favoriteM.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  _AccountTabState createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  bool isLoggedIn = false; // Trạng thái đăng nhập
  String userName = "Cao Hồi";
  String userEmail = "caominhchien@gmail.com";
  String avatarUrl =
      "https://sohanews.sohacdn.com/160588918557773824/2022/2/18/eimi-fukada-khoe-nhan-cuoi-khien-nhieu-anh-em-vun-vo-1-16451569810551833965014.jpg";

  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _userNameController.text = userName;
    _userEmailController.text = userEmail;
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Chỉnh sửa thông tin"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _userNameController,
                decoration: InputDecoration(labelText: "Tên"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _userEmailController,
                decoration: InputDecoration(labelText: "ID"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  userName = _userNameController.text;
                  userEmail = _userEmailController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Thông tin đã được cập nhật!")));
              },
              child: Text("Lưu"),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    setState(() {
      isLoggedIn = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Bạn đã đăng xuất!")));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
        avatarUrl = pickedFile.path;
      });
    }
  }

  void _showLoginBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/zing.jpg', height: 150),
              SizedBox(height: 16),
              Text(
                'Đăng nhập',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoggedIn = true;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.account_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Đăng nhập qua Zalo', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Bằng cách đăng nhập, bạn đã đồng ý với Điều khoản sử dụng của Zing MP3',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tài khoản"), centerTitle: true),
      body: isLoggedIn
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _imageFile != null
                  ? FileImage(File(_imageFile!.path))
                  : NetworkImage(avatarUrl) as ImageProvider,
            ),
          ),
          SizedBox(height: 10),
          Text(
            userName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(userEmail, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: _editProfile,
            icon: Icon(Icons.edit, color: Colors.white),
            label: Text("Chỉnh sửa thông tin"),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.favorite, color: Colors.red),
                  title: Text("Bài hát yêu thích"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => FavoritesScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text("Đăng xuất"),
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ],
      )
          : Center(
        child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          onPressed: _showLoginBottomSheet,
          child: Text("Đăng nhập ngay"),
        ),
      ),
    );
  }
}
