import 'package:equapp/controller/apiservices.dart';
import 'package:equapp/models/equ_id.dart';
import 'package:equapp/widget/custom_DataTable.dart';
import 'package:equapp/widget/custom_SearchBar.dart';
import 'package:equapp/widget/custom_appbar.dart';
import 'package:equapp/widget/loading_mark.dart';
import 'package:equapp/widget/subappbar.dart';
import 'package:flutter/material.dart';

class EquListPage extends StatefulWidget {
  const EquListPage({super.key});

  @override
  State<EquListPage> createState() => _RequiredDailyChecksPage();
}

class _RequiredDailyChecksPage extends State<EquListPage> {
  final ApiService apiService = ApiService();
  List<EquipmentID> allData = [];
  // String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  List<EquipmentID> filteredData = [];
  bool isloding = true;
  int _selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    fetchFormData();
  }

  Future fetchFormData() async {
    try {
      List<EquipmentID> fetchedData = await apiService.getFireFighEqp(
        "90013234",
      );
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

  void updateSearchQuery(String enteredKeyword) {
    List<EquipmentID> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space
      results = allData;
    } else {
      results = allData.where((EquipmentID) {
        final FormIDMatch = EquipmentID.id
            .toString()
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase());

        return FormIDMatch;
      }).toList();
    }
    setState(() {
      filteredData = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
          BGColor: Colors.white,
          IconColor: Colors.black,
          TextColor: Colors.black,
          text: "جميع المعدات"),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSearchBar(
                searchController: searchController,
                onSearchChanged: updateSearchQuery,
                labelText: 'بحث...',
              )),
          Expanded(
            child: isloding
                ? Center(
                    child: LoadingPage(
                    text: "المعدات",
                  ))
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
                    : CustomDataTable(
                        title: '',
                        headers: [
                          "رقم المعدة",
                          "اسم المعدة",
                          "المفتش",
                          "تاريخ اخر فحص  ",
                        ],
                        rows: filteredData.map((data) {
                          return [
                            data.id.toString(),
                            data.EqpDesc.toString(),
                            data.CheckerName.toString(),
                            data.LastCheckDate.toString(),
                          ];
                        }).toList(),
                      ),

            //  SingleChildScrollView(
            //     scrollDirection: Axis.vertical,
            //     child: SingleChildScrollView(
            //       scrollDirection: Axis.horizontal,
            //       child: DataTable(
            //         columns: [
            //           DataColumn(
            //             label: ConstrainedBox(
            //               constraints: BoxConstraints(
            //                 minWidth: 50, // Minimum width
            //                 maxWidth:
            //                     110, // Prevents it from being too wide
            //               ),
            //               child: Text(
            //                 "رقم المعدة",
            //                 style: TableStyles.headerStyle,
            //                 overflow: TextOverflow.ellipsis,
            //               ),
            //             ),
            //           ),
            //           DataColumn(
            //             label: Container(
            //               width: 1, // Adjust width as needed
            //               color: Colors.black,
            //             ),
            //           ),
            //           DataColumn(
            //               label: Text(
            //             "اسم المعدة",
            //             style: TableStyles.headerStyle,
            //           )),
            //           DataColumn(
            //               label: Text(
            //             "المفتش",
            //             style: TableStyles.headerStyle,
            //           )),
            //           DataColumn(
            //               label: Text(
            //             "تاريخ اخر فحص  ",
            //             style: TableStyles.headerStyle,
            //           )),
            //         ],
            //         rows: filteredData.map((equipment) {
            //           return DataRow(cells: [
            //             DataCell(Text(
            //               equipment.id.toString(),
            //               style: TableStyles.cellStyle,
            //             )),
            //             DataCell(
            //                 Container(width: 1, color: Colors.black)),
            //             DataCell(Text(
            //               equipment.EqpDesc.toString(),
            //               style: TableStyles.cellStyle,
            //             )),
            //             DataCell(Text(
            //               equipment.CheckerName.toString(),
            //               style: TableStyles.cellStyle,
            //             )),
            //             DataCell(Text(
            //               equipment.LastCheckDate.toString(),
            //               style: TableStyles.cellStyle,
            //             )),
            //           ]);
            //         }).toList(),
            //       ),
            //     ),
            //   ),
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
