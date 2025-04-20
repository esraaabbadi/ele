import 'package:equapp/pages/Home%20Pages/maintain_request.dart';
import 'package:equapp/pages/Home%20Pages/notification.dart';
import 'package:equapp/pages/equ_page/equipmets.dart';
import 'package:equapp/widget/logout.dart';
import 'package:flutter/material.dart';

class BottomNavPage extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final String EName;
  final String EMPID;
  final String Group;

  const BottomNavPage({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.EName,
    required this.EMPID,
    required this.Group,
  }) : super(key: key);

  @override
  _BottomNavPageState createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex; // Initialize with the passed index
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0XFFEBF1F6),
      iconSize: 60,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      selectedLabelStyle: TextStyle(
        fontSize: 14,
      ),
      unselectedLabelStyle:
          TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      currentIndex: widget.selectedIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/forms.png',
            width: 40, // Adjust size as needed
            height: 40,
          ),
          label: 'طلبات الصيانة',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/equ.png',
            width: 40, // Adjust size as needed
            height: 40,
          ),
          label: 'المعدات',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/notifiy.png',
            width: 45, // Adjust size as needed
            height: 45,
          ),
          label: 'الإشعارات',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/log-out.png',
            width: 40, // Adjust size as needed
            height: 40,
          ),
          label: 'الخروج',
        ),
      ],
      onTap: (index) {
        if (_currentIndex == index) {
          // If user taps on the same tab, do nothing
          return;
        }

        // setState(() {
        //   _currentIndex = index; // Update the selected index
        // });

        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MaintainRequestPage(
                EMPID: widget.EMPID,
                EName: widget.EName,
              ),
            ),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EquipmentsPage(
                Group: widget.Group,
                EName: widget.EName,
                EMPID: widget.EMPID,
              ),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationPage(
                EName: widget.EName,
                EMPID: widget.EMPID,
              ),
            ),
          );
        } else if (index == 3) {
          showLogoutDialog(context);
        }
      },
    );
  }
}
