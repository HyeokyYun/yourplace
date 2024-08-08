import 'package:flutter/material.dart';
import 'package:yourplace/screen/home/my_character.dart';
import 'package:yourplace/screen/home/user_page.dart';
import 'package:yourplace/screen/home/writing_generate.dart';

class MyHomePage extends StatefulWidget {
  final String imagePath;

  const MyHomePage({super.key, required this.imagePath});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late List<Widget> _navIndex;

  @override
  void initState() {
    super.initState();
    _navIndex = [
      MyCharacterPage(imagePath: widget.imagePath),
      SelectWriting(imagePath: widget.imagePath),
      MyPage(),
    ];
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navIndex.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.blue,
        unselectedItemColor: Colors.blueGrey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '메인',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books_outlined),
            label: '글 쓰기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '내 정보',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
