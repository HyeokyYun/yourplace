import 'package:flutter/material.dart';
import 'package:yourplace/controller/chat_list.dart';

class ChatController extends ChangeNotifier {
  late final TextEditingController textEditingController =
      TextEditingController();
  late final ScrollController scrollController = ScrollController();
  late final FocusNode focusNode = FocusNode();

  bool get isTextFieldEnable => textEditingController.text.isNotEmpty;
  List<Chat> chatList = <Chat>[Chat(message: '너는 무슨 색을 좋아해?', sent: false)];
  List<String> answers = <String>[];
  var question = 0;

  ChatController() {
    initializeChatList();
  }

  void initializeChatList() {
    chatList = <Chat>[Chat(message: '너는 무슨 색을 좋아해?', sent: false)];
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

    if (question == 1) {
      chatList.add(Chat(message: '너의 꿈은 뭐야?', sent: false));
    } else if (question == 2) {
      chatList.add(Chat(message: '너는 무슨 동물을 좋아해?', sent: false));
    } else if (question == 3) {
      chatList.add(Chat(message: '너의 취미는 뭐야?', sent: false));
    } else if (question == 4) {
      for (Chat message in chatList) {
        answers.add(message.message);
      }
    }

    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );

    textEditingController.text = '';
    notifyListeners();
  }

  void onFieldChanged(String term) {
    notifyListeners();
  }
}
