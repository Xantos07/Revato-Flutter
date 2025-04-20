import 'package:flutter/material.dart';
import 'redaction_screen.dart';
import 'profil_screen.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({Key? key}) : super(key: key);
  @override
  _HomeScaffoldState createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _currentIndex = 1;
  final _pages = [
    ProfileScreen(),
    CreationReveScreen(),
    CreationReveScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      // Le FloatingActionButton (ton bouton “crayon” au milieu)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.edit, size: 28),
        onPressed: () => setState(() => _currentIndex = 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Le BottomAppBar qui accueille les autres icônes
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icône Profil
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _currentIndex == 0 ? Colors.deepPurple : Colors.black54,
                ),
                onPressed: () => setState(() => _currentIndex = 0),
              ),
              // Icône Journal (à droite du FAB)
              IconButton(
                icon: Icon(
                  Icons.book,
                  color: _currentIndex == 2 ? Colors.deepPurple : Colors.black54,
                ),
                onPressed: () => setState(() => _currentIndex = 2),
              ),

              // Si tu veux un 4e bouton, ajoute-le ici + ajuste spaceBetween
              // IconButton(...),
            ],
          ),
        ),
      ),
    );
  }
}
