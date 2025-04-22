import 'package:flutter/material.dart';
import 'redaction_screen.dart';
import 'profil_screen.dart';
import 'views/taskList.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({Key? key}) : super(key: key);
  @override
  _HomeScaffoldState createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _currentIndex = 1;
  final _pages = [
    ProfileScreen(),
    RedactionScreen(),
    TaskList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.edit, size: 28),
        onPressed: () => setState(() => _currentIndex = 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _currentIndex == 0 ? Colors.deepPurple : Colors.black54,
                ),
                onPressed: () => setState(() => _currentIndex = 0),
              ),

              IconButton(
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
