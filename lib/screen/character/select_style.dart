import 'package:flutter/material.dart';
import 'package:yourplace/screen/chat/chat_screen.dart';
import 'package:yourplace/screen/character/user_info.dart';

class SelectStylePage extends StatelessWidget {
  final String user;
  const SelectStylePage(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    print('Nickname: ${user}');
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("스타일 선택"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            0, screenSize.width * 0.05, 0, screenSize.width * 0.1),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SelectStyleButton(
                    title: "Diseny",
                    screenSize: screenSize,
                    onTap: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                user: user,
                                kind: 'Create',
                                characterStyle: '3D pixar style')),
                      );
                    },
                    imageAddr: "assets/style/disney.png"),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                SelectStyleButton(
                    title: "Dong Soup",
                    screenSize: screenSize,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                user: user,
                                kind: 'Create',
                                characterStyle: '3D Animal Crossing')),
                      );
                    },
                    imageAddr: "assets/style/dongsoup.png"),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                SelectStyleButton(
                    title: "2D",
                    screenSize: screenSize,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                user: user,
                                kind: 'Create',
                                characterStyle: '2D Ghibli style')),
                      );
                    },
                    imageAddr: "assets/style/2D.png"),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                SelectStyleButton(
                    title: "3D",
                    screenSize: screenSize,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                user: user,
                                kind: 'Create',
                                characterStyle: '3D')),
                      );
                    },
                    imageAddr: "assets/style/3D.png"),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                SelectStyleButton(
                    title: "COMING SOON",
                    screenSize: screenSize,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UserInfoPage()),
                      );
                    },
                    imageAddr: "assets/style/white.png"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectStyleButton extends StatelessWidget {
  final Size screenSize;
  final VoidCallback onTap;
  final String imageAddr;
  final String title;

  SelectStyleButton(
      {required this.title,
      required this.screenSize,
      required this.onTap,
      required this.imageAddr});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenSize.width * 0.8,
        height: screenSize.height * 0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imageAddr),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: "Noto",
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
