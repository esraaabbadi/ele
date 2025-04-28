import 'dart:async';

import 'package:equapp/Pages/login.dart';
import 'package:equapp/pages/Home%20Pages/daily_task.dart';
import 'package:equapp/pages/Home%20Pages/search_via_qr.dart';
import 'package:equapp/pages/equ_page/equipmets.dart';
import 'package:equapp/pages/Home%20Pages/group_members.dart';
import 'package:equapp/widget/CustomGridItem.dart';
import 'package:equapp/widget/cutom_nav_bar.dart' as NavBarWidget;
import 'package:equapp/widget/home_appbar.dart';
import 'package:equapp/widget/logout.dart';
import 'package:equapp/widget/user_data.dart';
import 'package:flutter/material.dart';
import 'maintain_request.dart';
import 'notification.dart';

class HomePage extends StatefulWidget {
  final String EMPID;
  final String EName;
  final String RelatedGroup;
  final String CurrentUserLoginRole;

  HomePage(
      this.EName, this.EMPID, this.RelatedGroup, this.CurrentUserLoginRole);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Timer? _inactivityTimer;
  late List<Widget> _pages;
  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
    Navigator.pop(context, widget.EMPID);
  }

  @override
  @override
  void initState() {
    super.initState();
    _resetInactivityTimer();
    _pages = [
      HomeContentPage(widget.EName, widget.EMPID, widget.RelatedGroup,
          widget.CurrentUserLoginRole),
      MaintainRequestPage(
        EName: widget.EName,
        EMPID: widget.EMPID,
      ),
      NotificationPage(
        EMPID: widget.EMPID,
        EName: widget.EName,
      ),
      EquipmentsPage(
        Group: widget.RelatedGroup,
        EName: widget.EName,
        EMPID: widget.EMPID,
      ),
      LogPage()
    ];
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer =
        Timer(Duration(seconds: 36000), _handleInactivityTimeout);
  }

  void _handleInactivityTimeout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LogPage()),
      (route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تسجيل الخروج بسبب عدم النشاط')),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetInactivityTimer,
      onPanDown: (_) => _resetInactivityTimer(),
      child: WillPopScope(
        onWillPop: () async {
          bool shouldLogout = showLogoutDialog(context);
          return shouldLogout;
        },
        child: Scaffold(
          appBar: HomeAppbar(),
          body: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: NavBarWidget.BottomNavPage(
            Group: widget.RelatedGroup,
            EMPID: widget.EMPID,
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
            EName: widget.EName,
          ),
        ),
      ),
    );
  }
}

class HomeContentPage extends StatelessWidget {
  final String EMPID;
  final String EName;
  final String RelatedGroup;
  final String CurrentUserLoginRole;

  HomeContentPage(
      this.EName, this.EMPID, this.RelatedGroup, this.CurrentUserLoginRole);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            UserData(
              EMPID: EMPID,
              EName: EName,
              CurrentUserLoginRole: CurrentUserLoginRole,
              RelatedGroup: RelatedGroup,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                padding: EdgeInsets.all(20),
                children: [
                  CustomGridItem(
                    image: 'assets/images/DailyTasksPage.png',
                    label: 'الأعمال اليومية',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => DailyTaskPage(
                            EMPID: EMPID,
                            RelatedGroup: RelatedGroup,
                            EName: EName,
                          ),
                        ),
                      );
                    },
                  ),
                  CustomGridItem(
                    image: 'assets/images/equipment2.png',
                    label: 'المعدات',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => EquipmentsPage(
                                  Group: RelatedGroup,
                                  EName: EName,
                                  EMPID: EMPID,
                                )),
                      );
                    },
                  ),
                  CustomGridItem(
                    image: 'assets/images/Notification1.png',
                    label: 'الأشعارات',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => NotificationPage(
                            EName: EName,
                            EMPID: EMPID,
                          ),
                        ),
                      );
                    },
                  ),
                  CustomGridItem(
                    image: 'assets/images/forms.png',
                    label: 'طلبات الصيانة',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              MaintainRequestPage(
                            EMPID: EMPID,
                            EName: EName,
                          ),
                        ),
                      );
                    },
                  ),
                  CustomGridItem(
                    image: 'assets/images/scanqr1.png',
                    label: 'استعلام عبر الرمز',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => SearchQuery(
                            EMPID: EMPID,
                          ),
                        ),
                      );
                    },
                  ),
                  CustomGridItem(
                    image: 'assets/images/team4.png',
                    label: 'اعضاء المجموعة',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => GroupMembersPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
