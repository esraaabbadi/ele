import 'package:equapp/controller/apiservices.dart';
import 'package:equapp/models/equipment.dart';
import 'package:equapp/pages/equ_page/equibment_form.dart';
import 'package:equapp/widget/data_table.dart';
import 'package:equapp/widget/loading_mark.dart';
import 'package:equapp/widget/subappbar.dart';
import 'package:flutter/material.dart';

class RequiredWeeklyChecksPage extends StatefulWidget {
  final String EMPID;
  final String Group;

  RequiredWeeklyChecksPage({
    required this.EMPID,
    required this.Group,
  });
  @override
  State<RequiredWeeklyChecksPage> createState() => _RequiredWeeklyChecksPage();
}

class _RequiredWeeklyChecksPage extends State<RequiredWeeklyChecksPage> {
  final ApiService apiService = ApiService();
  List<EquipmentCheckesData> allData = [];
  TextEditingController searchController = TextEditingController();
  List<EquipmentCheckesData> filteredData = [];
  bool isloding = true;
  int _selectedIndex = 1; // Set the initial index for navigation

  @override
  void initState() {
    super.initState();
    fetchFormData();
  }

  Future fetchFormData() async {
    try {
      List<EquipmentCheckesData> fetchedData = await apiService
          .getUserRelatedEquipmentsToCheckTodayOrThisweekOrThisMonth(
              "90013234", "Week");
      setState(() {
        allData = fetchedData;
        filteredData = fetchedData;
        isloding = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      isloding = false;
    }
  }

  void updateSearchQuery(String enteredKeyword) {
    List<EquipmentCheckesData> results = [];
    if (enteredKeyword.isEmpty) {
      results = allData;
    } else {
      results = allData.where((equipment) {
        return equipment.EqpID.toString()
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase());
      }).toList();
    }
    setState(() {
      filteredData = results;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, "/maintenance_requests");
      } else if (index == 1) {
        Navigator.pushNamed(context, "/Required_Weekly_Checks");
      } else if (index == 2) {
        Navigator.pushNamed(context, "/notification");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(size: 40, color: Colors.black),
        title: Text("تتطلب فحص اسبوع"),
      ),
      body: Column(
        children: [
          if (allData.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 16),
                controller: searchController,
                cursorColor: Color(0xFF157283),
                decoration: InputDecoration(
                  labelText: 'بحث...',
                  labelStyle: TextStyle(color: Color(0xFF157283), fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(color: Color(0xFF157283), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(color: Color(0xFF157283)),
                  ),
                ),
                onChanged: updateSearchQuery,
              ),
            ),
          Expanded(
            child: isloding
                ? Center(child: LoadingPage())
                : allData.isEmpty
                    ? Center(
                        child: Text(
                          "  لا توجد بيانات",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Text("اسم المعدة",
                                      style: TableStyles.headerStyle)),
                              DataColumn(
                                  label: Text("رقم المعدة",
                                      style: TableStyles.headerStyle)),
                              DataColumn(
                                  label: Text("تاريخ الفحص",
                                      style: TableStyles.headerStyle)),
                              DataColumn(
                                  label: Text("اسم النموذج",
                                      style: TableStyles.headerStyle)),
                            ],
                            rows: filteredData.map((equipment) {
                              return DataRow(cells: [
                                DataCell(Text(
                                  equipment.EqpDesc.toString(),
                                  style: TableStyles.cellStyle,
                                )),
                                DataCell(Text(
                                  equipment.EqpID.toString(),
                                  style: TableStyles.cellStyle,
                                )),
                                DataCell(Text(
                                  equipment.ScheduledCheckDate.toString(),
                                  style: TableStyles.cellStyle,
                                )),
                                DataCell(
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FormTemplatePage(
                                            EMPID: widget.EMPID,
                                            Group: widget.Group,
                                            FormType: "Month",
                                            formID: equipment.RealtedFormID
                                                .toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF157283),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                            color: Color(0xFF157283), width: 2),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                    child: Text(
                                      equipment.RealtedFormID.toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ), // Add the navigation bar
    );
  }
}
