import 'package:flutter/material.dart';
import 'package:yourplace/screen/login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isButtonEnabled = false;
  Color _buttonColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isButtonEnabled = true;
        _buttonColor = Colors.green;
      });
    });
    // _navigateToLogin();
  }

  // _navigateToLogin() async {
  //   await Future.delayed(const Duration(seconds: 4), () {});
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => Login()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logos/logo.png',
              width: screenSize.width * 0.7, // 원하는 크기로 조정
              height: screenSize.height * 0.3, // 원하는 크기로 조정
            ),
            SizedBox(height: screenSize.height * 0.03),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    '나를 가장 잘 아는\n나를 잘 표현하는',
                    textAlign: TextAlign.center,
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
            ElevatedButton.icon(
              onPressed: _isButtonEnabled
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    }
                  : null,
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text(
                '시작하기',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.height * 0.1,
                  vertical: screenSize.width * 0.03,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
