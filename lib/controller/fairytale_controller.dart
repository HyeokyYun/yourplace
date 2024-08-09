import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yourplace/providers/user_provider.dart';
import 'dart:convert';
import 'chat_list.dart';

class FairytaleController extends ChangeNotifier {
  final String addr = "http://10.0.2.2:8000";
  final String router = "local_test";
  var question = 0;

  bool get isTextFieldEnable => textEditingController.text.isNotEmpty;

  List<Chat> chatList = <Chat>[Chat(message: '주인공은 누구야?', sent: false)];
  List<String> answers = <String>[];

  final UserProvider userProvider;

  late final ScrollController scrollController = ScrollController();
  late final TextEditingController textEditingController =
      TextEditingController();
  late final FocusNode focusNode = FocusNode();

  FairytaleController(this.userProvider) {
    initializeChatList();
  }

  void initializeChatList() {
    chatList = <Chat>[Chat(message: '주인공은 누구야?', sent: false)];
    question = 0;
    notifyListeners();
  }

  Future<void> onFieldSubmitted() async {
    if (!isTextFieldEnable) return;

    chatList = [
      ...chatList,
      Chat.sent(message: textEditingController.text),
    ];

    question = question + 1;

    final chatResponse = await _sendMessageToServer(textEditingController.text);
    final chatResponseJson = jsonDecode(chatResponse!);
    String reply = chatResponseJson['content'];

    chatList.add(Chat(message: reply, sent: false));

    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );

    textEditingController.text = '';
    notifyListeners();
  }

  Future<String?> _sendMessageToServer(String message) async {
    String url = '$addr/$router/chat_string'; // FastAPI 서버 URL
    final Map<String, dynamic> data = {
      'nickname': userProvider.user,
      'content': message,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
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

  void onFieldChanged(String term) {
    notifyListeners();
  }
}
