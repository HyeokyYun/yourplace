import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:yourplace/providers/character_image_path_provider.dart';
import 'package:yourplace/providers/user_provider.dart';
import 'package:yourplace/screen/chat/chat_screen.dart';
import 'package:yourplace/screen/login.dart';

class SelectWriting extends StatefulWidget {
  final String imagePath;
  const SelectWriting({required this.imagePath, super.key});

  @override
  State<SelectWriting> createState() => _SelectWritingState();
}

class _SelectWritingState extends State<SelectWriting> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    String path = context.watch<CharacterImagePathProvider>().path;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('글 작성'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Container(
        width: screenSize.width,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              child: const Text(
                '어떤 글을 써볼까?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF292929),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              height: 250,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(widget.imagePath)),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: ListView(
                shrinkWrap: true,
                children: [
                  writingButton(context, text: '동화 쓰러 가기', content: '동화'),
                  writingButton(context, text: '일기 쓰러 가기', content: '일기'),
                  writingButton(context, text: '수필 쓰러 가기', content: '수필'),
                ],
              ),
            ),
          ],
        ),
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

  Widget writingButton(BuildContext context,
      {String text = '', String content = ''}) {
    var screenSize = MediaQuery.of(context).size;
    String user = context.watch<UserProvider>().user;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            // builder: (BuildContext context) => const ChatScreenPage(),
            builder: (BuildContext context) =>
                ChatScreen(user, 'Fairytale', 'Disney'),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        width: screenSize.width * 0.7,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1.50, color: Color(0xFF009858)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF009858),
              fontSize: 20,
              height: 0.09,
            ),
          ),
        ),
      ),
    );
  }
}
