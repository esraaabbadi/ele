import 'package:equapp/pages/Home%20Pages/Daily_task/detail-forms.dart';
import 'package:equapp/pages/Home%20Pages/Daily_task/tasks_done_today.dart';
import 'package:equapp/widget/CustomGridItem.dart';
import 'package:equapp/widget/cutom_nav_bar.dart';
import 'package:flutter/material.dart';

class DailyTaskPage extends StatefulWidget {
  final String EMPID;
  final String RelatedGroup;
  final String EName;

  DailyTaskPage({
    required this.EMPID,
    required this.RelatedGroup,
    required this.EName,
  });

  @override
  _DailyTaskPageState createState() => _DailyTaskPageState();
}

class _DailyTaskPageState extends State<DailyTaskPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70), // Adjust AppBar height
        child: AppBar(
          iconTheme: IconThemeData(size: 40, color: Colors.white),
          backgroundColor: Color(0xFF157283),
          title: Center(
              child: Text(
            "الأعمال اليومية",
            style: TextStyle(color: Colors.white),
          )),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 250,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                padding: EdgeInsets.all(20),
                children: [
                  CustomGridItem(
                    image: 'assets/images/TodayTasks.png',
                    label: "الأعمال التي تمت اليوم",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => TasksDoneTodayPage(
                            EMPID: widget.EMPID,
                            RelatedGroup: widget.RelatedGroup,
                            EName: widget.EName,
                          ),
                        ),
                      );
                    },
                  ),
                  CustomGridItem(
                    image: 'assets/images/allffreports3.png',
                    label: "تفاصيل الفحوصات",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => DetailFormsPage(
                            EMPID: widget.EMPID,
                            EName: widget.EName,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavPage(
        Group: widget.RelatedGroup,
        EMPID: widget.EMPID,
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        EName: widget.EName,
      ),
    );
  }
}
