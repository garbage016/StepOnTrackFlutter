import 'package:flutter/material.dart';

class MyTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyTopBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.yellow[700], // GialloHeader
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // BlackAlpha
            offset: Offset(5, 5),
            blurRadius: 2,
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 35,
            color: Colors.white, // sandColor
            fontFamily: 'Calsans', // Assicurati di averlo aggiunto correttamente nel pubspec.yaml
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3), // BlackAlpha
                offset: Offset(5, 5),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100); // altezza personalizzata
}
