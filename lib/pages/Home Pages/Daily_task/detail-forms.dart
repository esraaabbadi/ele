import 'package:equapp/controller/apiservices.dart';
import 'package:equapp/widget/custom_Appbar.dart';
import 'package:equapp/widget/custom_DataTable.dart';
import 'package:equapp/widget/custom_SearchBar.dart';
import 'package:equapp/widget/loading_mark.dart';
import 'package:equapp/widget/no_data.dart';
import 'package:equapp/widget/subappbar.dart';
import 'package:flutter/material.dart';
import '../../../models/form-details.dart';

class DetailFormsPage extends StatefulWidget {
  final String EName;
  final String EMPID;
  const DetailFormsPage({required this.EName, required this.EMPID});
  @override
  State<DetailFormsPage> createState() => _DetailFormsPageState();
}

class _DetailFormsPageState extends State<DetailFormsPage> {
  final ApiService apiService = ApiService();
  List<FormsDetailsData> allData = [];
  TextEditingController searchController = TextEditingController();
  List<FormsDetailsData> filteredData = [];
  int _selectedIndex = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFormData();
  }

  Future fetchFormData() async {
    try {
      List<FormsDetailsData> fetchedData =
          await apiService.getDetailForms(widget.EMPID);
      setState(() {
        allData = fetchedData;
        filteredData = fetchedData;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateSearchQuery(String enteredKeyword) {
    List<FormsDetailsData> results = [];
    if (enteredKeyword.isEmpty) {
      results = allData;
    } else {
      results = allData.where((data) {
        return data.FormID.toLowerCase().contains(enteredKeyword.toLowerCase());
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
        text: 'تفاصيل الفحوصات',
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          if (allData.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: CustomSearchBar(
                searchController: searchController,
                onSearchChanged: updateSearchQuery,
              ),
            ),
          Expanded(
            child: isLoading
                ? Center(child: LoadingPage())
                : allData.isEmpty
                    ? NoDataWidget()
                    : CustomDataTable(
                        title: "جدول البيانات",
                        headers: ["النموذج", "وصف", "القيمة", "الفاحص"],
                        rows: filteredData.map((data) {
                          return [
                            data.FormID.toString(),
                            data.FormItemText.toString(),
                            data.FormItemValue.toString(),
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
