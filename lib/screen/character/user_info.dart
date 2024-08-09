import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:yourplace/providers/user_provider.dart';
import 'dart:convert';

import 'package:yourplace/screen/home/my_character.dart';
import 'package:yourplace/screen/character/select_style.dart';

List<String> userList = [];

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    var response = await getUsers('', '');
    if (response != null) {
      setState(() {
        userList = (json.decode(response) as List<dynamic>).cast<String>();
        if (userList.isNotEmpty) {
          dropdownValue = userList.first;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    String user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('유저 정보 입력'),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            screenSize.width * 0.08,
            screenSize.width * 0.05,
            screenSize.width * 0.08,
            screenSize.width * 0.1),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenSize.width * 0.08,
                      screenSize.width * 0.05,
                      screenSize.width * 0.08,
                      screenSize.width * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: userNameController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: "닉네임을 입력하세요",
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (userNameContrller) {
                          setState(() {
                            user = userNameContrller;
                            context.read<UserProvider>().changeUser(user);
                          });
                        },
                      ),
                      SizedBox(
                        height: screenSize.height * 0.05,
                      ),
                      TextField(
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: "성별",
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: screenSize.height * 0.05,
                      ),
                      TextField(
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: "나이",
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: screenSize.height * 0.05,
                      ),
                      Image.asset(
                        'assets/logos/logo.png',
                        width: screenSize.width * 0.7, // 원하는 크기로 조정
                        height: screenSize.height * 0.3, // 원하는 크기로 조정
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: screenSize.width * 0.8,
              height: screenSize.height * 0.05,
              child: ElevatedButton(
                child: Text(
                  "캐릭터 생성",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, elevation: 2),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SelectStylePage(userNameController.text)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<String?> getUsers(String userName, String password) async {
// const String addr = "http://127.0.0.1:8000";
  const String addr = "http://10.0.2.2:8000";
  const String router = "local_test";

  String url = '$addr/$router/users';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      return responseBody;
    } else {
      print('Failed to get response from server: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error occurred while sending message: $e');
    return null;
  }
}

void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: Colors.black,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
