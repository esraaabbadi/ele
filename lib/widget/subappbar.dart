import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  OverlayEntry? _overlayEntry;

  void _showSubMenu(BuildContext context, String category, GlobalKey key) {
    // Get the position of the selected BottomNavigationBar item
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset.zero);
    double itemWidth = renderBox.size.width;
    double screenWidth = MediaQuery.of(context).size.width;

    List<Widget> menuItems = _buildMenuItems(context, category);
    double maxHeight =
        (menuItems.length > 3) ? 220 : (menuItems.length * 55).toDouble();
    double menuWidth = itemWidth * 7;
    double leftPosition = position.dx - 50;
    if (leftPosition + menuWidth > screenWidth) {
      leftPosition =
          screenWidth - menuWidth - 10; // Adjust to fit within the screen
    }
    if (leftPosition < 10) {
      leftPosition = 10; // Prevent menu from going off the left edge
    }
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Tap anywhere to close the overlay
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideSubMenu,
                behavior: HitTestBehavior.opaque,
              ),
            ),
            // Submenu positioned above the tapped BottomNavigationBar item
            Positioned(
              left: position.dx - 100, // Adjust left to center the menu
              // top: position.dy - 100,
              top: position.dy -
                  maxHeight -
                  10, // Adjust height to position above
              // width: 280, // Set fixed width
              // left: position.dx,
              // top: position.dy - 200, // Adjust height to position above
              width: itemWidth * 7,

              // Make it wider for better appearance
              child: Material(
                color: Colors.white,
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _buildMenuItems(context, category),
                ),
              ),
            ),
          ],
        );
      },
    );

    // Insert the overlay into the widget tree
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideSubMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  List<Widget> _buildMenuItems(BuildContext context, String category) {
    List<Map<String, String>> menuItems = [];

    if (category == "maintenance") {
      menuItems = [
        {"label": "عرض طلبات الصيانة", "route": "/maintenance_requests"},
        {"label": "تسجيل طلب صيانة", "route": "/register_maintenance"},
      ];
    } else if (category == "equipment") {
      menuItems = [
        {"label": "معدات تتطلب الفحص اليوم", "route": "/Required_Daily_Checks"},
        {"label": "نماذج الفحص الأسبوعية", "route": "/Required_Weekly_Checks"},
        {"label": "نماذج فحص خلال الشهر", "route": "/Required_Monthly_Checks"},
        {"label": "قائمة بجميع المعدات الكهرباء", "route": "/Equ_List_Checks"},
        {"label": "الأعمال التي تمت اليوم", "route": "/Equ_Tasks_Done_Today"},
      ];
    } else if (category == "notification") {
      menuItems = [
        {"label": "قائمة بجميع الإشعارات", "route": "/notification"},
      ];
    }

    return menuItems
        .map((item) => ListTile(
              title: Text(item["label"]!, textAlign: TextAlign.center),
              onTap: () {
                _hideSubMenu();
                Navigator.pushNamed(context, item["route"]!);
              },
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<GlobalKey> itemKeys = [
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
    ];

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0XFFEBF1F6),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      selectedLabelStyle: const TextStyle(fontSize: 18),
      unselectedLabelStyle:
          const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      currentIndex: widget.selectedIndex,
      onTap: (index) {
        if (index == 0) {
          _showSubMenu(context, "maintenance", itemKeys[index]);
        } else if (index == 1) {
          _showSubMenu(context, "equipment", itemKeys[index]);
        } else if (index == 2) {
          _showSubMenu(context, "notification", itemKeys[index]);
        } else {
          widget.onItemTapped(index);
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Container(
            key: itemKeys[0],
            child:
                Image.asset('assets/images/forms.png', width: 40, height: 40),
          ),
          label: 'طلبات الصيانة',
        ),
        BottomNavigationBarItem(
          icon: Container(
            key: itemKeys[1],
            child: Image.asset('assets/images/equ.png', width: 40, height: 40),
          ),
          label: 'المعدات',
        ),
        BottomNavigationBarItem(
          icon: Container(
            key: itemKeys[2],
            child:
                Image.asset('assets/images/notifiy.png', width: 45, height: 45),
          ),
          label: 'الإشعارات',
        ),
      ],
    );
  }
}
