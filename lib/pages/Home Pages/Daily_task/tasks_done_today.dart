import 'package:equapp/widget/custom_Appbar.dart';
import 'package:equapp/widget/custom_DataTable.dart';
import 'package:equapp/widget/custom_SearchBar.dart';
import 'package:equapp/widget/loading_mark.dart';
import 'package:equapp/widget/no_data.dart';
import 'package:equapp/widget/subappbar.dart';
import 'package:flutter/material.dart';
import '../../../controller/apiservices.dart';
import '../../../models/form.dart';

class TasksDoneTodayPage extends StatefulWidget {
  final String EMPID;
  final String RelatedGroup;
  final String EName;

  TasksDoneTodayPage(
      {required this.EMPID, required this.RelatedGroup, required this.EName});
  @override
  State<TasksDoneTodayPage> createState() => _TasksDoneTodayPageState();
}

class _TasksDoneTodayPageState extends State<TasksDoneTodayPage> {
  final ApiService apiService = ApiService();
  List<FormData> allData = [];
  TextEditingController searchController = TextEditingController();
  List<FormData> filteredData = [];
  bool isloding = true;
  int _selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    fetchFormData();
  }

  Future fetchFormData() async {
    try {
      List<FormData> fetchedData =
          await apiService.getSubmittedFormInDate(widget.EMPID, "16/10/2024");
      setState(() {
        allData = fetchedData; // Store the fetched data in allData
        filteredData = fetchedData;
        isloding = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      isloding = false;
    }
  }

  void updateSearchQuery(String enteredKeyword) {
    List<FormData> results = [];
    if (enteredKeyword.isEmpty) {
      results = allData;
    } else {
      results = allData.where((formData) {
        final equpIDMatch = formData.EqupID.toString()
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase());
        final formIDMatch = formData.FormID.toString()
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase());
        final formIDISOMatch = formData.FormIDISO.toString()
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase());
        return equpIDMatch || formIDMatch || formIDISOMatch;
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
      appBar: CustomAppbar(
        BGColor: Colors.white,
        IconColor: Colors.black,
        TextColor: Colors.black,
        text: "الأعمال التي تمت اليوم",
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          if (allData.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: CustomSearchBar(
                searchController: searchController,
                onSearchChanged: updateSearchQuery,
              ),
            ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: isloding
                ? Center(child: LoadingPage())
                : filteredData.isEmpty
                    ? NoDataWidget()
                    : CustomDataTable(
                        title: "جدول البيانات",
                        headers: [
                          "التفاصيل",
                          "المجموعة",
                          "النموذج",
                          "رقم المعدة"
                        ],
                        rows: filteredData.map((data) {
                          return [
                            data.EqupID.toString(),
                            "${data.FormID} - ${data.FormIDISO}",
                            widget.RelatedGroup.toString(),
                            data.FormEntryIDName.toString(),
                          ];
                        }).toList(),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
