import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yourplace/screen/character_generate.dart';
import 'dart:convert';

import 'package:yourplace/screen/home.dart';
import 'package:yourplace/screen/select_style.dart';

List<String> userList = [];

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController controller = TextEditingController();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.search), onPressed: () {})
        ],
      ),
      body: Center(
        child: SizedBox(
          width: screenSize.width * 0.7,
          height: screenSize.width * 0.5,
          child: Column(
            children: [
              Container(
                width: screenSize.width * 0.7,
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: DropdownButtonFormField<String>(
                  value: dropdownValue,
                  hint: const Text('Select user'),
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'User',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.green,
                        width: 1.0,
                      ),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: userList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              ButtonTheme(
                minWidth: screenSize.width * 0.7,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () async {
                    final response =
                        await getUsers(controller.text, controller2.text);
                    print(response);
                    if (response != null &&
                        response.contains(dropdownValue as Pattern)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } else {
                      String user = dropdownValue!;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectStylePage(user)),
                      );
                      showSnackBar(context, const Text('새 캐릭터 생성으로 이동합니다.'));
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text(
                    '로그인',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          _showDialog(context);
        },
        heroTag: "actionButton",
        backgroundColor: Colors.greenAccent,
        child: const Icon(
          Icons.person,
          size: 50,
        ),
      ),
    );
  }

  Future<dynamic> _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('닉네임을 정해 주세요'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Enter nickname'),
          keyboardType: TextInputType.text,
        ),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectStylePage(controller.text)),
                  ),
              child: const Text('결정')),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소')),
        ],
        elevation: 10.0,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
      ),
    );
  }
}

Future<String?> getUsers(String userName, String password) async {
  const String addr = "http://127.0.0.1:8000";
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
