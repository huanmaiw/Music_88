import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_app/ChucNang/recently_played.dart';

import '../Account/login.dart';
import '../data/model/favoriteM.dart';
import 'my_listplay.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  _AccountTabState createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  bool isLoggedIn = false;
  String userName = "Cao Hồi";
  String userEmail = "caominhchien@gmail.com";
  String avatarUrl = "https://s3.ap-southeast-1.amazonaws.com/cdn.vntre.vn/default/avatar-facebook-01-1724577427.jpg";
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  XFile? _imageFile;
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }
  void _checkLoginStatus() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        isLoggedIn = true;
        userName = user.displayName ?? "Người dùng";
        userEmail = user.email ?? "Không có email";
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: Scaffold(
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
                    leading: Icon(Icons.playlist_play, color: Colors.blue),
                    title: Text("Tạo listplay của tôi"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MyListPlay()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite, color: Colors.red),
                    title: Text("Bài hát yêu thích"),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => FavoritesScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.history, color: Colors.blue),
                    title: Text("Các bài hát nghe gần đây"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RecentlyPlayedScreen()),
                      );
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
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );

              if (result == true) {
                _checkLoginStatus();
              }
            },
            child: Text("Đăng nhập ngay"),
          ),

        ),
      ),
    );
  }

}
