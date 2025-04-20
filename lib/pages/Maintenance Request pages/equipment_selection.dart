import 'package:equapp/controller/apiservices.dart';
import 'package:equapp/widget/custom_Appbar.dart';
import 'package:equapp/widget/loading_mark.dart';
import 'package:equapp/widget/no_data.dart';
import 'package:flutter/material.dart';
import 'package:equapp/models/equ_id.dart';

class EquipmentSelectionPage extends StatefulWidget {
  final List<EquipmentID> equipmentList;

  EquipmentSelectionPage({required this.equipmentList});

  @override
  _EquipmentSelectionPageState createState() => _EquipmentSelectionPageState();
}

class _EquipmentSelectionPageState extends State<EquipmentSelectionPage> {
  TextEditingController searchController = TextEditingController();
  final ApiService apiService = ApiService();
  List<EquipmentID> allData = [];
  List<EquipmentID> filteredData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFormData();
  }

  Future<void> fetchFormData() async {
    try {
      List<EquipmentID> fetchedData =
          await apiService.getFireFighEqp("90013234");
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch data. Please try again.")),
      );
    }
  }

  void updateSearchQuery(String enteredKeyword) {
    setState(() {
      filteredData = enteredKeyword.isEmpty
          ? allData
          : allData
              .where((item) =>
                  item.id.toLowerCase().contains(enteredKeyword.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(text: "اختر المعدة"),
      body: isLoading
          ? Center(child: LoadingPage())
          : allData.isEmpty
              ? NoDataWidget()
              : Container(
                  color: Colors.grey[200],
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          controller: searchController,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          onChanged: updateSearchQuery,
                          decoration: InputDecoration(
                            labelText: "ابحث عن المعدة",
                            labelStyle: TextStyle(
                                color: Color(0xFF157283), fontSize: 16),
                            prefixIcon:
                                Icon(Icons.search, color: Color(0xFF157283)),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Color(0xFF157283), width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Color(0xFF157283), width: 2.0),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 4,
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  leading: Icon(Icons.build,
                                      color: Color(0xFF157283)),
                                  title: Text(
                                    filteredData[index].id, // Fixed issue here
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      color: Color(0xFF157283), size: 18),
                                  onTap: () {
                                    Navigator.pop(context, filteredData[index]);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
