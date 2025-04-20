import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final labelText;
  const CustomSearchBar({
    Key? key,
    required this.searchController,
    required this.onSearchChanged,
    this.labelText = ' ادخل للبحث رقم النموذج/رقم المعدة',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        style: TextStyle(color: Colors.black, fontSize: 16),
        controller: searchController,
        cursorColor: Color(0xFF157283),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Color(0xFF157283), fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFF157283), width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: Color(0xFF157283)),
          ),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}
