import 'package:flutter/material.dart';

void main() => runApp(BottomNav());

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
        BottomNavigationBarItem(icon: Icon(Icons.error), title: Text('Report')),
        BottomNavigationBarItem(icon: Icon(Icons.account_box), title: Text('Profile')),
      ],
      currentIndex: _selectedIndex,
      onTap: _onTapped,
    );
  }

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
