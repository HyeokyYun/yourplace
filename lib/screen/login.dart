import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:yourplace/screen/user_info.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  _signInWithGoogle(context);
                },
                child: Text("Google")),
            ElevatedButton(
                onPressed: () {
                  _loginWithKakao(context);
                },
                child: Text("KAKAO")),
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    _showLoadingDialog(context); // 로딩 다이얼로그 표시
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        print(value.user?.email);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserInfoPage()),
        );
      }).onError((error, stackTrace) {
        print("Error $error");
        _hideLoadingDialog(context); // 로딩 다이얼로그 숨기기
      });
    } catch (error) {
      print("Error $error");
      _hideLoadingDialog(context); // 로딩 다이얼로그 숨기기
    }
  }

  Future<void> _loginWithKakao(BuildContext context) async {
    _showLoadingDialog(context); // 로딩 다이얼로그 표시
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token;
      if (isInstalled) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      print('Login success: ${token.accessToken}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserInfoPage()),
      );
    } catch (e) {
      print('Login failed: $e');
      _hideLoadingDialog(context); // 로딩 다이얼로그 숨기기
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.black.withOpacity(0.75), // 배경색을 진하게 설정
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white), // 색상 설정
                  strokeWidth: 5.0, // 크기 설정
                ),
                SizedBox(width: 20),
                Text(
                  "Loading...",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _hideLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
