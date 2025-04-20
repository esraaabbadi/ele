import 'package:equapp/pages/Maintenance%20Request%20pages/Show_Maininance_Request.dart';
import 'package:equapp/pages/Maintenance%20Request%20pages/regester_maintenance_request.dart';
import 'package:equapp/widget/CustomGridItem.dart';
import 'package:equapp/widget/custom_appbar.dart';
import 'package:flutter/material.dart';

class MaintainRequestPage extends StatelessWidget {
  final String EName;
  final String EMPID;

  MaintainRequestPage({
    required this.EName,
    required this.EMPID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        BGColor: Color.fromARGB(255, 6, 79, 92),
        IconColor: Colors.white,
        TextColor: Colors.white,
        text: "طلبات الصيانة",
      ),
      body: Stack(
        children: [
          // GridView
          Positioned(
            top: 250, // Adjust the value to control the vertical position
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                padding: EdgeInsets.all(20),
                children: [
                  CustomGridItem(
                    image: 'assets/images/Viewopenrequests.png',
                    label: "عرض طلبات الصيانة",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              ShowMainRequestPage(
                            EMPID: EMPID,
                            EName: EName,
                          ),
                        ),
                      );
                    },
                  ),
                  CustomGridItem(
                    image: 'assets/images/Registermaintena.png',
                    label: "تسجيل طلب صيانة",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              MaintenanceRequestPage(
                            EMPID: EMPID,
                            EName: EName,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
