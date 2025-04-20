import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

dynamic showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(
            "تسجيل الخروج",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: Text(
          "هل أنت متأكد من تسجيل الخروج؟",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity, // Make button full width
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF157283), // Background color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 12), // Button padding
                  ),
                  onPressed: () async {
                    await logoutUser(context);
                  },
                  child: Text(
                    "تأكيد",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 8), // Add space between buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 13, 74, 85), // Background color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    "إلغاء",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<void> logoutUser(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Keep the username but remove authentication data
  String? savedUsername = prefs.getString('savedUsername');
  await prefs.clear(); // Clear all data
  if (savedUsername != null) {
    await prefs.setString('savedUsername', savedUsername); // Restore username
  }

  debugPrint("Logout successful. Username retained: $savedUsername");

  // Navigate to login page
  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}

// Future<void> logoutUser(BuildContext context) async {
//   Navigator.of(context).pop();
//   debugPrint("Logout pressed. Clearing session...");

//   // Navigate immediately after closing the dialog
 
// }
