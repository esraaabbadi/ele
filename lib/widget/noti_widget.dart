import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final String message;
  final VoidCallback onConfirm; // Function for the button action

  const NotificationWidget({
    super.key,
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: onConfirm,
              icon: const Icon(
                Icons.check_box_rounded,
                color: Color.fromARGB(255, 6, 79, 92),
              ),
              label: const Text(
                "تأكيد الأطلاع",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 6, 79, 92),
                ),
              ),
              style: TextButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
