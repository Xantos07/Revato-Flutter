import 'package:flutter/material.dart';
import 'views/redaction_screen.dart';
import 'views/profil_screen.dart';
import 'views/taskList.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({Key? key}) : super(key: key);
  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
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
        child: const Icon(Icons.edit, size: 28),
        onPressed: () => setState(() => _currentIndex = 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,

        // on ajoute un container pour donner un peu de hauteur + padding
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Profil
              Expanded(
                child: IconButton(
                  iconSize: 28,
                  icon: Icon(
                    Icons.person,
                    color: _currentIndex == 0
                        ? Colors.deepPurple
                        : Colors.black54,
                  ),
                  onPressed: () => setState(() => _currentIndex = 0),
                ),
              ),

              // Espace réservé pour le FAB
              const SizedBox(width: 60),

              // Tâches (ou Journal)
              Expanded(
                child: IconButton(
                  iconSize: 28,
                  icon: Icon(
                    Icons.book,
                    color: _currentIndex == 2
                        ? Colors.deepPurple
                        : Colors.black54,
                  ),
                  onPressed: () => setState(() => _currentIndex = 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
