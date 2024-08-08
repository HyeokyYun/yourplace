import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourplace/providers/character_image_path_provider.dart';

class MyCharacterPage extends StatefulWidget {
  final String imagePath;

  const MyCharacterPage({super.key, required this.imagePath});

  @override
  State<MyCharacterPage> createState() => _MyCharacterPageState();
}

class _MyCharacterPageState extends State<MyCharacterPage> {
  @override
  Widget build(BuildContext context) {
    String path = context.watch<CharacterImagePathProvider>().path;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('나의 캐릭터'),
      ),
      body: Center(
        child: Image.file(File(widget.imagePath)),
      ),
    );
  }
}
