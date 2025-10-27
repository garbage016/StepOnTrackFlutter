import 'package:flutter/material.dart';

class BottomNavItem {
  final String label;
  final IconData icon;
  final String route;

  BottomNavItem({required this.label, required this.icon, required this.route});
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
    BottomNavItem(label: "Home", icon: Icons.home, route: "home"),
    BottomNavItem(label: "Percorsi", icon: Icons.search, route: "percorsi"),
    BottomNavItem(label: "Classifiche", icon: Icons.star, route: "classifiche"),
    BottomNavItem(label: "Profilo", icon: Icons.person, route: "profilo"),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: Colors.yellow[700], // GialloBottomBar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...items.asMap().entries.map((entry) {
                int idx = entry.key;
                BottomNavItem item = entry.value;

                // Lasciamo spazio al FAB
                if (idx == 2) {
                  return SizedBox(width: 70);
                }

                return IconButton(
                  icon: Icon(item.icon,
                      color: currentIndex == idx ? Colors.green[800] : Colors.black54),
                  onPressed: () => onTap(idx),
                  tooltip: item.label,
                );
              }).toList()
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              onPressed: onFabTap,
              backgroundColor: Colors.yellow[700], // GialloHeader
              child: Icon(Icons.add, size: 35),
            ),
          ),
        )
      ],
    );
  }
}
