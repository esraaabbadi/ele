import 'package:equapp/util/date.dart';
import 'package:flutter/material.dart';

class UserData extends StatelessWidget {
  final EName;
  final EMPID;
  final RelatedGroup;
  final CurrentUserLoginRole;
  const UserData({
    Key? key,
    required this.EName,
    required this.EMPID,
    this.RelatedGroup,
    this.CurrentUserLoginRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Adds shadow for a modern effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      child: Container(
        width: double.infinity,
        height: 270,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Color(0xFF064F5C), Color(0xFF0A6B75)], // Modern gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 10,
                ),
                Icon(Icons.person, color: Colors.white, size: 28),
                SizedBox(width: 10),
                Text(
                  'أهلاً ' + '${EName} - ${EMPID}',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(color: Colors.white30, thickness: 1), // Subtle separator
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.white, size: 24),
                SizedBox(width: 10),
                Text(
                  getCurrentDateTime(),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.groups, color: Colors.white, size: 24),
                SizedBox(width: 10),
                Text(
                  'مجموعة: ${RelatedGroup}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.security, color: Colors.white, size: 24),
                SizedBox(width: 10),
                Text(
                  'الصلاحية: ${CurrentUserLoginRole}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
