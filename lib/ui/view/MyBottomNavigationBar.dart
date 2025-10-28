import 'package:flutter/material.dart';

class BottomNavItem {
  final String label;
  final IconData icon;
  final String route;

  BottomNavItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Function() onFabTap;

  MyBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.onFabTap,
  });

  final List<BottomNavItem> items = [
    BottomNavItem(label: "Home", icon: Icons.home, route: "/home"),
    BottomNavItem(label: "Percorsi", icon: Icons.map, route: "/percorsi"),
    BottomNavItem(label: "Classifiche", icon: Icons.emoji_events, route: "/classifiche"),
    BottomNavItem(label: "Profilo", icon: Icons.person, route: "/profilo"),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.yellow[700],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Sinistra del FAB
          IconButton(
            icon: Icon(
              items[0].icon,
              color: currentIndex == 0 ? Colors.green[800] : Colors.black54,
            ),
            tooltip: items[0].label,
            onPressed: () => onTap(0),
          ),
          IconButton(
            icon: Icon(
              items[1].icon,
              color: currentIndex == 1 ? Colors.green[800] : Colors.black54,
            ),
            tooltip: items[1].label,
            onPressed: () => onTap(1),
          ),

          const SizedBox(width: 48), // spazio per FAB centrale

          // Destra del FAB
          IconButton(
            icon: Icon(
              items[2].icon,
              color: currentIndex == 2 ? Colors.green[800] : Colors.black54,
            ),
            tooltip: items[2].label,
            onPressed: () => onTap(2),
          ),
          IconButton(
            icon: Icon(
              items[3].icon,
              color: currentIndex == 3 ? Colors.green[800] : Colors.black54,
            ),
            tooltip: items[3].label,
            onPressed: () => onTap(3),
          ),
        ],
      ),
    );
  }
}
