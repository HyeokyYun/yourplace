import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:yourplace/controller/chat_controller.dart';
import 'package:yourplace/controller/chat_list.dart';
import 'package:yourplace/screen/chat/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  final String user;
  final String kind;

  const ChatScreen(this.user, this.kind, {super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure ChatController is provided
    return ChangeNotifierProvider(
      create: (_) => ChatController()..initializeChatList(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("캐릭터 생성"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.read<ChatController>().focusNode.unfocus();
                },
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Selector<ChatController, List<Chat>>(
                    selector: (context, controller) =>
                        controller.chatList.reversed.toList(),
                    builder: (context, chatList, child) {
                      return ListView.separated(
                        shrinkWrap: true,
                        reverse: true,
                        padding: const EdgeInsets.only(top: 12, bottom: 20) +
                            const EdgeInsets.symmetric(horizontal: 12),
                        separatorBuilder: (_, __) => const SizedBox(
                          height: 12,
                        ),
                        controller:
                            context.read<ChatController>().scrollController,
                        itemCount: chatList.length,
                        itemBuilder: (context, index) {
                          return ChatBubble(chat: chatList[index]);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            _BottomInputField(user: user),
          ],
        ),
      ),
    );
  }
}

/// Bottom Fixed Field
class _BottomInputField extends StatelessWidget {
  final String addr = "http://127.0.0.1:8000";
  final String router = "local_test";

  final String user;

  const _BottomInputField({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Selector<ChatController, int>(
          selector: (context, controller) => controller.question,
          builder: (context, question, child) {
            if (question == 4) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final chatController = context.read<ChatController>();
                    final answers = chatController.answers;
                    _generateCharacter(user, answers);
                    // print(response);
                  },
                  child: const Text("Generate Character"),
                ),
              );
            }
            return Container();
          },
        ),
        SafeArea(
          bottom: true,
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFE5E5EA),
                ),
              ),
            ),
            child: Stack(
              children: [
                Selector<ChatController, bool>(
                  selector: (context, controller) => controller.question != 4,
                  builder: (context, isEnabled, child) {
                    return TextField(
                      focusNode: context.read<ChatController>().focusNode,
                      onChanged: context.read<ChatController>().onFieldChanged,
                      controller:
                          context.read<ChatController>().textEditingController,
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                          right: 42,
                          left: 16,
                          top: 18,
                        ),
                        hintText: 'message',
                        enabled: isEnabled,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    );
                  },
                ),
                // custom suffix btn
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: context.read<ChatController>().onFieldSubmitted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<String?> _generateCharacter(String name, List<String> answers) async {
    String url = '$addr/$router/begin';
    final Map<String, dynamic> data = {
      'nickname': name,
      'answers': answers,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Failed to get response from server: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while sending message: $e');
      return null;
    }
  }
}
