import 'package:equapp/controller/apiservices.dart';
import 'package:equapp/models/equipment.dart';
import 'package:equapp/pages/equ_page/equibment_form.dart';
import 'package:equapp/widget/data_table.dart';
import 'package:equapp/widget/loading_mark.dart';
import 'package:equapp/widget/subappbar.dart';
import 'package:flutter/material.dart';

class RequiredDailyChecksPage extends StatefulWidget {
  final String EMPID;
  final String Group;

  RequiredDailyChecksPage({
    required this.EMPID,
    required this.Group,
  });
  @override
  State<RequiredDailyChecksPage> createState() => _RequiredDailyChecksPage();
}

class _RequiredDailyChecksPage extends State<RequiredDailyChecksPage> {
  final ApiService apiService = ApiService();
  List<EquipmentCheckesData> allData = [];
  // String searchQuery = '';
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
              widget.EMPID, "Today");
      setState(() {
        allData = fetchedData;
        filteredData = fetchedData;
        isloding = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isloding = false;
      });
    }
  }

  // This function is called whenever the text field changes
  void updateSearchQuery(String enteredKeyword) {
    List<EquipmentCheckesData> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space
      results = allData;
    } else {
      results = allData.where((EquipmentCheckesData) {
        final FormIDMatch = EquipmentCheckesData.EqpID.toString()
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase());
        // final formIDMatch = FormsDetailsData.FormItemText.toString()
        //     .toLowerCase()
        //     .contains(enteredKeyword.toLowerCase());
        // final formIDISOMatch = FormsDetailsData.FormItemValue.toString()
        //     .toLowerCase()
        //     .contains(enteredKeyword.toLowerCase());
        // final FormEntryIDNameMatch = FormsDetailsData.FormEntryIDName.toString()
        //     .toLowerCase()
        //     .contains(enteredKeyword.toLowerCase());
        return FormIDMatch;
        // ||
        //     formIDMatch ||
        //     formIDISOMatch ||
        //     FormEntryIDNameMatch;
      }).toList();
      // we use the toLowerCase() method to make it case-insensitive
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
        title: Text("المعدات التي تتطلب فحص اليوم"),
      ),
      body: Column(
        children: [
          if (allData.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                controller: searchController,
                cursorColor: Color(0xFF157283),
                decoration: InputDecoration(
                  labelText: 'بحث...',
                  labelStyle: TextStyle(color: Color(0xFF157283), fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Color(0xFF157283),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(
                        color: Color(0xFF157283),
                      )),
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
                                            Group: widget.Group,
                                            EMPID: widget.EMPID,
                                            FormType: "Daily",
                                            formID: equipment.RealtedFormID
                                                .toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(
                                          0xFF157283), // Button background color
                                      foregroundColor:
                                          Colors.white, // Text color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8), // Rounded corners
                                        side: BorderSide(
                                            color: Color(0xFF157283),
                                            width: 2), // Border color and width
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8), // Button padding
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
