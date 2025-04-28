import 'package:equapp/widget/custom_appbar.dart';
import 'package:equapp/widget/loading_mark.dart';
import 'package:equapp/widget/subappbar.dart';
import 'package:flutter/material.dart';
import '../../controller/apiservices.dart';
import '../../models/notification.dart';

class NotificationPage extends StatefulWidget {
  final String EName;
  final String EMPID;

  const NotificationPage({required this.EName, required this.EMPID, Key? key})
      : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final ApiService apiService = ApiService();
  List<NotificationData> allData = [];
  bool isLoading = true; // Start with loading true
  String errorMessage = '';
  int _selectedIndex = 1;

  @override
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    try {
      List<NotificationData> fetchedData =
          await apiService.getGNFByStatus('${widget.EMPID}');
      print("getGNFByStatus called from: ${StackTrace.current}");
      setState(() {
        allData = fetchedData; // Store the fetched data
        isLoading = false; // Stop loading
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching data: $e";
        isLoading = false;
      });
      print(errorMessage);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        text: "الأشعارات",
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? Center(
                      child: LoadingPage(
                      text: "الأشعارات",
                    ))
                  : errorMessage.isNotEmpty
                      ? Center(child: Text(errorMessage))
                      : allData.isEmpty
                          ? Center(child: Text("لا توجد اشعارات"))
                          : ListView.builder(
                              itemCount: allData.length,
                              itemBuilder: (context, index) {
                                final notification = allData[index];
                                return Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 16.0),
                                    child: Container(
                                      padding: EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.2), // Shadow color with transparency
                                            spreadRadius:
                                                2, // Controls the size of the shadow
                                            blurRadius: 5, // Soften the shadow
                                            offset: Offset(0,
                                                3), // Moves the shadow downwards
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        // mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            notification.message,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          // TextButton.icon(
                                          //   onPressed: () {},
                                          //   icon: Icon(
                                          //     Icons.check_box_rounded,
                                          //     color: Color.fromARGB(
                                          //         255, 6, 79, 92),
                                          //   ),
                                          //   label: Text(
                                          //     "تأكيد الأطلاع",
                                          //     style: TextStyle(
                                          //       fontSize: 16,
                                          //       color: Color.fromARGB(
                                          //           255, 6, 79, 92),
                                          //     ),
                                          //   ),
                                          //   style: TextButton.styleFrom(
                                          //     side: BorderSide(
                                          //         color: Colors.black,
                                          //         width:
                                          //             1), // Border color and thickness
                                          //     shape: RoundedRectangleBorder(
                                          //       borderRadius: BorderRadius.circular(
                                          //           10), // Optional: Rounded corners
                                          //     ),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavBar(
      //   selectedIndex: _selectedIndex,
      //   onItemTapped: _onItemTapped,
      // ),
    );
  }
}
