import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final BGColor;
  final TextColor;
  final IconColor;

  CustomAppbar({
    required this.text,
    this.BGColor = const Color(0xFF157283),
    this.TextColor = Colors.white,
    this.IconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: BGColor,
      iconTheme: IconThemeData(
        size: 40,
        color: IconColor,
      ),
      title: Center(
        child: Text(
          text,
          style: TextStyle(
            color: TextColor, // ✅ Apply the passed text color here
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
