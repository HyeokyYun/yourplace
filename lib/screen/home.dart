import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to Home Screen!'),
      ),
    );
  }

  void _logout(BuildContext context) async {
    String? email = FirebaseAuth.instance.currentUser?.email;
    // Firebase 로그아웃
    await FirebaseAuth.instance.signOut();
    // Google 로그아웃
    await GoogleSignIn().signOut();
    // Kakao 로그아웃
    try {
      await UserApi.instance.logout();
    } catch (error) {
      print('Kakao logout failed: $error');
    }
    // 로그 기록

    print('User $email logged out');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }
}
