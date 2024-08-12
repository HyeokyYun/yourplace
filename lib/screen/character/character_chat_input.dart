import 'package:flutter/material.dart';
import 'package:yourplace/providers/character_image_path_provider.dart';
import 'package:yourplace/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:yourplace/controller/chat_controller.dart';
import 'package:yourplace/screen/home/main_page.dart';

class CharacterChatInput extends StatefulWidget {
  // final String addr = "http://127.0.0.1:8000";
  final String addr = "http://10.0.2.2:8000";
  final String router = "local_test";

  final String user;
  final Function(bool) setLoading;
  final String characterStyle;

  const CharacterChatInput(
      {required this.user,
      required this.setLoading,
      required this.characterStyle,
      super.key});

  @override
  State<CharacterChatInput> createState() => _CharacterChatInputState();
}

class _CharacterChatInputState extends State<CharacterChatInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Selector<ChatController, int>(
            selector: (context, controller) => controller.question,
            builder: (context, question, child) {
              if (question == 4) {
                return ElevatedButton(
                  onPressed: () async {
                    widget.setLoading(true);
                    final chatController = context.read<ChatController>();
                    final answers = chatController.answers;
                    const style = '';
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
                            builder: (context) => MyHomePage(
                                  imagePath: imagePath,
                                  characterStyle: widget.characterStyle,
                                )),
                      );
                    } else {
                      // Handle error
                    }
                  },
                  child: Text(
                    "캐릭터 생성",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      elevation: 2,
                      minimumSize: Size(80, 50)),
                );
              }
              return Container();
            },
          ),
          SafeArea(
            bottom: true,
            child: Container(
              margin: EdgeInsets.all(12),
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
                        onChanged:
                            context.read<ChatController>().onFieldChanged,
                        controller: context
                            .read<ChatController>()
                            .textEditingController,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                            right: 42,
                            left: 16,
                          ),
                          hintText: '작성하기',
                          enabled: isEnabled,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.green),
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
                      onPressed:
                          context.read<ChatController>().onFieldSubmitted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _generateCharacter(
      String name, List<String> answers, String style) async {
    String url = '${widget.addr}/${widget.router}/begin';
    final Map<String, dynamic> data = {
      'nickname': name,
      'answers': answers,
      'style': style,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        context.read<UserProvider>().changeUser(name);
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
    context.read<CharacterImagePathProvider>().changePath(filePath);
    // const directory = 'assets/images';
    // const filePath = '$directory/character_image.png';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }
}
