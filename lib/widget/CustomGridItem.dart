import 'package:flutter/material.dart';

class CustomGridItem extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const CustomGridItem({
    Key? key,
    required this.image,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFFEBF1F6),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(8), // Optional for rounded images
              child: Image.asset(
                image,
                height: 60,
                width: 60,
                fit: BoxFit
                    .fill, // Ensure the image covers the box proportionally
              ),
            ),
            SizedBox(height: 16),
            Text(label, style: Theme.of(context).textTheme.displayMedium),
          ],
        ),
      ),
    );
  }
}

// Widget _buildGridItem(BuildContext context,
//     {required IconData icon,
//     required String label,
//     required VoidCallback onTap}) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       decoration: BoxDecoration(
//         color: Color(0XFFEBF1F6),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 4,
//             offset: Offset(2, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 30,
//             color: Color(0xFF003F54),
//           ),
//           SizedBox(height: 8),
//           Text(label, style: Theme.of(context).textTheme.displayMedium),
//         ],
//       ),
//     ),
//   );
// }
