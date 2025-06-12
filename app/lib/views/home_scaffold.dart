import 'package:flutter/material.dart';
import 'redaction_screen.dart';
import 'profil_screen.dart';
import 'dream_list.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({Key? key}) : super(key: key);
  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _currentIndex = 1;
  final _pages = [
    const ProfileScreen(),
    const RedactionScreen(),
    const DreamList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Profil
              IconButton(
                iconSize: 28,
                icon: Icon(
                  Icons.person,
                  color: _currentIndex == 0 ? Colors.deepPurple : Colors.black54,
                ),
                onPressed: () => setState(() => _currentIndex = 0),
              ),
              // Rédaction
              IconButton(
                iconSize: 32,
                icon: Icon(
                  Icons.edit,
                  color: _currentIndex == 1 ? Colors.deepPurple : Colors.black54,
                ),
                onPressed: () => setState(() => _currentIndex = 1),
              ),
              // Liste
              IconButton(
                iconSize: 28,
                icon: Icon(
                  Icons.book,
                  color: _currentIndex == 2 ? Colors.deepPurple : Colors.black54,
                ),
                onPressed: () => setState(() => _currentIndex = 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
