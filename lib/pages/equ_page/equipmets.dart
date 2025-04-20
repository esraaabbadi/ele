import 'package:equapp/pages/equ_page/all_equ.dart';
import 'package:equapp/pages/equ_page/equibment_form.dart';
import 'package:equapp/pages/equ_page/required_daily_checks.dart';
import 'package:equapp/pages/equ_page/required_monthly_checks.dart';
import 'package:equapp/pages/equ_page/required_weekly_checks.dart';
import 'package:equapp/pages/equ_page/tasks_done_today.dart';
import 'package:equapp/widget/custom_Appbar.dart';
import 'package:equapp/widget/cutom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../../widget/CustomGridItem.dart';

class EquipmentsPage extends StatefulWidget {
  final String EName;
  final String EMPID;
  final String Group;
  const EquipmentsPage(
      {required this.EName, required this.EMPID, required this.Group});

  @override
  State<EquipmentsPage> createState() => _EquipmentsPageState();
}

class _EquipmentsPageState extends State<EquipmentsPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(text: "المعدات"),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: .8,
              crossAxisSpacing: 8, // Horizontal spacing between items
              mainAxisSpacing: 8, // Vertical spacing between items
              padding: const EdgeInsets.all(16), // Padding around the GridView
              children: [
                CustomGridItem(
                  image: 'assets/images/Dailyexamination.png',
                  label: "تتتطلب الفحص اليوم",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            RequiredDailyChecksPage(
                          Group: widget.Group,
                          EMPID: widget.EMPID,
                        ),
                      ),
                    );
                  },
                ),
                CustomGridItem(
                  image: 'assets/images/Weeklyexamination1.png',
                  label: "النماذج الأسبوعية",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            RequiredWeeklyChecksPage(
                          Group: widget.Group,
                          EMPID: widget.EMPID,
                        ),
                      ),
                    );
                  },
                ),
                CustomGridItem(
                  image: 'assets/images/Monthlyexamination.png',
                  label: "خلال الشهر",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            RequiredMonthlyChecksPage(
                          Group: widget.Group,
                          EMPID: widget.EMPID,
                        ),
                      ),
                    );
                  },
                ),
                CustomGridItem(
                  image: 'assets/images/Monthlyexamination.png',
                  label: "نموذج يومي QF-205A",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => FormTemplatePage(
                          Group: widget.Group,
                          EMPID: widget.EMPID,
                          FormType: "Daily",
                          formID: 'QF-205A',
                        ),
                      ),
                    );
                  },
                ),
                CustomGridItem(
                  image: 'assets/images/Equipmentlist.png',
                  label: "قائمة المعدات",
                  onTap: () {
                    // EquListPage
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => EquListPage(),
                      ),
                    );
                  },
                ),
                CustomGridItem(
                  image: 'assets/images/TodayTasks.png',
                  label: "الأعمال التي تمت اليوم",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            EquTasksDoneTodayPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
      // bottomNavigationBar: BottomNavPage(
      //   EMPID: widget.EMPID,
      //   selectedIndex: _selectedIndex,
      //   onItemTapped: _onItemTapped,
      //   EName: widget.EName,
      // ),
    );
  }
}
