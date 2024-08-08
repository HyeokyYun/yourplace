import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:yourplace/controller/chat_controller.dart';
import 'package:yourplace/controller/chat_list.dart';
import 'package:yourplace/screen/chat/chat_bubble.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:yourplace/screen/home.dart';

class ChatScreen extends StatefulWidget {
  final String user;
  final String kind;
  final String characterStyle;

  const ChatScreen(this.user, this.kind, this.characterStyle, {super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    print('Character Style: ${widget.characterStyle}');
  }

  bool isLoading = false;

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatController()..initializeChatList(),
      child: Stack(
        children: [
          Scaffold(
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
                            padding:
                                const EdgeInsets.only(top: 12, bottom: 20) +
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
                _BottomInputField(
                  user: widget.user,
                  setLoading: setLoading,
                  characterStyle: widget.characterStyle,
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

class _BottomInputField extends StatefulWidget {
  // final String addr = "http://127.0.0.1:8000";
  final String addr = "http://10.0.2.2:8000";
  final String router = "local_test";

  final String user;
  final Function(bool) setLoading;
  final String characterStyle;

  const _BottomInputField({
    required this.user,
    required this.setLoading,
    required this.characterStyle,
    super.key,
  });

  @override
  State<_BottomInputField> createState() => _BottomInputFieldState();
}

class _BottomInputFieldState extends State<_BottomInputField> {
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
                    widget.setLoading(true);
                    final chatController = context.read<ChatController>();
                    final answers = chatController.answers;
                    final style = widget.characterStyle;
                    final response =
                        await _generateCharacter(widget.user, answers, style);
                    widget.setLoading(false);
                    if (response != null) {
                      final characterResponse =
                          await _getCharacter(widget.user);
                      final characterResponseJson =
                          jsonDecode(characterResponse!);
                      final imagePath = await _saveImageToLocal(
                          characterResponseJson['image']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(imagePath: imagePath)),
                      );
                    } else {
                      // Handle error
                    }
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

  Future<String?> _generateCharacter(
      String name, List<String> answers, String characterStyle) async {
    String url = '${widget.addr}/${widget.router}/begin';
    final Map<String, dynamic> data = {
      'nickname': name,
      'answers': answers,
      'style': characterStyle,
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

  Future<String?> _getCharacter(String name) async {
    String url = '${widget.addr}/${widget.router}/character?nickname=$name';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
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

  Future<String> _saveImageToLocal(String base64Image) async {
    final bytes = base64Decode(base64Image);
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/character_image.png';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }
}
