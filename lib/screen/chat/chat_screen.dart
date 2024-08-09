import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:yourplace/controller/chat_controller.dart';
import 'package:yourplace/controller/chat_list.dart';
import 'package:yourplace/controller/fairytale_controller.dart';
import 'package:yourplace/providers/user_provider.dart';
import 'package:yourplace/screen/character/character_%08chat_input.dart';
import 'package:yourplace/screen/chat/chat_bubble.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:yourplace/screen/fairytale/fairytale_chat_input.dart';
import 'package:yourplace/screen/home/main_page.dart';

class ChatScreen extends StatefulWidget {
  final String user;
  final String kind;
  final String characterStyle;

  const ChatScreen(
      {required this.user,
      required this.kind,
      required this.characterStyle,
      super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    print('Character Style: ${widget.characterStyle}');
    print('Story Kind: ${widget.kind}');
  }

  bool isLoading = false;

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.kind == 'Create') {
      return ChangeNotifierProvider(
        create: (_) => ChatController()..initializeChatList(),
        child: Stack(
          children: [
            Scaffold(
              // resizeToAvoidBottomInset: true,
              appBar: AppBar(
                // sautomaticallyImplyLeading: false,
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
                              padding: const EdgeInsets.only(
                                      top: 12, bottom: 20) +
                                  const EdgeInsets.symmetric(horizontal: 12),
                              separatorBuilder: (_, __) => const SizedBox(
                                height: 12,
                              ),
                              controller: context
                                  .read<ChatController>()
                                  .scrollController,
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
                  CharacterChatInput(
                    user: widget.user,
                    setLoading: setLoading,
                    characterStyle: widget.characterStyle,
                  ),
                  SizedBox(
                    height: 30,
                  )
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
    } else if (widget.kind == 'Fairytale') {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      return ChangeNotifierProvider(
        create: (_) => FairytaleController(userProvider)..initializeChatList(),
        child: Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: const Text("동화 생성"),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<FairytaleController>().focusNode.unfocus();
                      },
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Selector<FairytaleController, List<Chat>>(
                          selector: (context, controller) =>
                              controller.chatList.reversed.toList(),
                          builder: (context, chatList, child) {
                            return ListView.separated(
                              shrinkWrap: true,
                              reverse: true,
                              padding: const EdgeInsets.only(
                                      top: 12, bottom: 20) +
                                  const EdgeInsets.symmetric(horizontal: 12),
                              separatorBuilder: (_, __) => const SizedBox(
                                height: 12,
                              ),
                              controller: context
                                  .read<FairytaleController>()
                                  .scrollController,
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
                  FairytaleChatInput(
                      user: widget.user,
                      setLoading: setLoading,
                      characterStyle: widget.characterStyle),
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
    } else {
      return ChangeNotifierProvider(
        create: (_) => ChatController()..initializeChatList(),
        child: Stack(
          children: [
            Scaffold(
              // resizeToAvoidBottomInset: true,
              appBar: AppBar(
                // sautomaticallyImplyLeading: false,
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
                              padding: const EdgeInsets.only(
                                      top: 12, bottom: 20) +
                                  const EdgeInsets.symmetric(horizontal: 12),
                              separatorBuilder: (_, __) => const SizedBox(
                                height: 12,
                              ),
                              controller: context
                                  .read<ChatController>()
                                  .scrollController,
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
                  CharacterChatInput(
                    user: widget.user,
                    setLoading: setLoading,
                    characterStyle: widget.characterStyle,
                  ),
                  SizedBox(
                    height: 30,
                  )
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
}
