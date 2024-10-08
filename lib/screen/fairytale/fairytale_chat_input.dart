import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:yourplace/controller/fairytale_controller.dart';
import 'package:yourplace/providers/character_image_path_provider.dart';

class FairytaleChatInput extends StatefulWidget {
  // final String addr = "http://127.0.0.1:8000";
  final String addr = "http://10.0.2.2:8000";
  final String router = "local_test";

  final String user;
  final Function(bool) setLoading;
  final String characterStyle;

  const FairytaleChatInput({
    required this.user,
    required this.setLoading,
    required this.characterStyle,
    super.key,
  });

  @override
  State<FairytaleChatInput> createState() => _FairytaleChatInputState();
}

class _FairytaleChatInputState extends State<FairytaleChatInput> {
  @override
  void initState() {
    super.initState();
    print("User Name: ${widget.user}");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Selector<FairytaleController, int>(
            selector: (context, controller) => controller.question,
            builder: (context, question, child) {
              if (question == 3) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      widget.setLoading(true);
                      final response = await _generateImage(widget.user);
                      widget.setLoading(false);
                    },
                    child: Text(
                      "동화 그리기",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 2,
                      minimumSize: Size(80, 50),
                    ),
                  ),
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
                  Selector<FairytaleController, bool>(
                    selector: (context, controller) => controller.question != 4,
                    builder: (context, isEnabled, child) {
                      return TextField(
                        focusNode:
                            context.read<FairytaleController>().focusNode,
                        onChanged:
                            context.read<FairytaleController>().onFieldChanged,
                        controller: context
                            .read<FairytaleController>()
                            .textEditingController,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
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
                          context.read<FairytaleController>().onFieldSubmitted,
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

  Future<String?> _generateImage(String name) async {
    String url = '${widget.addr}/${widget.router}/illustration?nickname=$name';

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
