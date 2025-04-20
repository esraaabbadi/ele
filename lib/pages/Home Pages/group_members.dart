import 'package:equapp/controller/apiservices.dart';
import 'package:equapp/models/group_member.dart';
import 'package:equapp/widget/custom_DataTable.dart';
import 'package:equapp/widget/custom_SearchBar.dart';
import 'package:equapp/widget/custom_appbar.dart';
import 'package:equapp/widget/loading_mark.dart';
import 'package:flutter/material.dart';

class GroupMembersPage extends StatefulWidget {
  @override
  State<GroupMembersPage> createState() => _DetailFormsPageState();
}

class _DetailFormsPageState extends State<GroupMembersPage> {
  final ApiService apiService = ApiService();
  List<GroupMemberData> allData = [];
  // String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  List<GroupMemberData> filteredData = [];

  @override
  void initState() {
    super.initState();
    fetchFormData();
  }

  Future fetchFormData() async {
    try {
      List<GroupMemberData> fetchedData =
          await apiService.getUsersList("90016159");
      setState(() {
        allData = fetchedData; // Store the fetched data in allData
        filteredData = fetchedData;
      });
    } catch (e) {
      print("Error fetching data: $e"); // Handle any errors here
    }
  }

  // This function is called whenever the text field changes
  void updateSearchQuery(String enteredKeyword) {
    List<GroupMemberData> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space
      results = allData;
    } else {
      results = allData.where((GroupMemberData) {
        final FormIDMatch = GroupMemberData.EmpID.toString()
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
        text: "اعضاء المجموعة",
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSearchBar(
                  searchController: searchController,
                  onSearchChanged: updateSearchQuery)

              // TextField(
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontSize: 16,
              //   ),
              //   controller: searchController,
              //   cursorColor: Color(0xFF157283),
              //   decoration: InputDecoration(
              //     labelText: 'بحث...',
              //     labelStyle: TextStyle(color: Color(0xFF157283), fontSize: 16),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(16),
              //       borderSide: BorderSide(
              //         color: Color(0xFF157283),
              //         width: 2.0,
              //       ),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16.0),
              //         borderSide: BorderSide(
              //           color: Color(0xFF157283),
              //         )),
              //   ),
              //   onChanged: updateSearchQuery,
              // ),
              ),
          Expanded(
              child: allData.isEmpty
                  ? LoadingPage()
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: 0,
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.8),
                        child: CustomDataTable(
                          title: '',
                          headers: [
                            "رقم الموظف",
                            "اسم الموظف",
                            "المجموعة",
                            "الصلاحية",
                          ],
                          rows: filteredData.map((data) {
                            return [
                              data.EmpID.toString(),
                              data.EmpName.toString(),
                              data.Active.toString(),
                              data.RelatedGroupName.toString(),
                            ];
                          }).toList(),
                        ),
                      ),
                    ))
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: DataTable(
          //     dataRowMinHeight: 50, // الحد الأدنى
          //     dataRowMaxHeight: 50,
          //     columns: [
          //       DataColumn(
          //           label: Text(
          //         "رقم الموظف",
          //         style: TableStyles.headerStyle,
          //       )),
          //       DataColumn(
          //           label: Text(
          //         "اسم الموظف",
          //         style: TableStyles.headerStyle,
          //       )),
          //       DataColumn(
          //           label: Text(
          //         "المجموعة",
          //         style: TableStyles.headerStyle,
          //       )),
          //       DataColumn(
          //           label: Text(
          //         "الصلاحية",
          //         style: TableStyles.headerStyle,
          //       )),
          //     ],
          //     rows: filteredData.map((GroupMemberData) {
          //       return DataRow(cells: [
          //         DataCell(Text(
          //           GroupMemberData.EmpID.toString(),
          //           style: TextStyle(color: Colors.black),
          //         )),
          //         DataCell(Text(
          //           GroupMemberData.EmpName.toString(),
          //           style: TextStyle(color: Colors.black),
          //         )),
          //         DataCell(Text(
          //           GroupMemberData.Active.toString(),
          //           style: TextStyle(color: Colors.black),
          //         )),
          //         DataCell(Text(
          //           GroupMemberData.RelatedGroupName.toString(),
          //           style: TextStyle(color: Colors.black),
          //         )),
          //       ]);
          //     }).toList(),
          //   ),
          // ))
        ],
      ),
    );
  }
}
