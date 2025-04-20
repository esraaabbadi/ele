import 'dart:io';
import 'package:equapp/controller/apiservices.dart';
import 'package:equapp/models/show_m_reuest.dart';
import 'package:equapp/widget/loading_mark.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowMainRequestPage extends StatefulWidget {
  final String EName;
  final String EMPID;

  ShowMainRequestPage({required this.EName, required this.EMPID});

  @override
  State<ShowMainRequestPage> createState() => _ShowMainRequestPageState();
}

class _ShowMainRequestPageState extends State<ShowMainRequestPage> {
  final ApiService apiService = ApiService();
  List<ShowMaintenanceRequestDetails> allData = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    try {
      List<ShowMaintenanceRequestDetails> fetchedData =
          await apiService.getSRQByStatus(widget.EMPID);
      print('Fetched Data: $fetchedData');
      setState(() {
        allData = fetchedData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching data: $e";
        isLoading = false;
      });
      print('error: $errorMessage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(size: 40, color: Colors.white),
        backgroundColor: Color(0xFF157283),
        title: Center(
            child: Text(
          "طلبات الصيانة المفتوحه",
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: isLoading
          ? Center(child: LoadingPage())
          : Container(
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      errorMessage.isNotEmpty
                          ? Center(child: Text(errorMessage))
                          : allData.isEmpty
                              ? Center(
                                  child: Text(
                                    "لا يوجد طلبات ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Color(0xFF157283),
                                        ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: allData.length,
                                  itemBuilder: (context, index) {
                                    final desc = allData[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16.0),
                                      child: Container(
                                        padding: EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                if (desc.AttID.isNotEmpty) {
                                                  // Show loading dialog first
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible:
                                                        false, // Prevents dialog from being closed outside
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "يرجى الانتظار"), // "Please wait" in Arabic
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            // Show loading indicator until the image is loaded
                                                            Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                                "جارٍ تحميل الصورة..."), // "Loading image..." in Arabic
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );

                                                  // Simulate a small delay to keep the loading dialog visible
                                                  await Future.delayed(
                                                      Duration(seconds: 1));

                                                  // Wait for the image to load
                                                  bool imageLoaded = false;
                                                  File imageFile =
                                                      File(desc.AttID);
                                                  if (await imageFile
                                                      .exists()) {
                                                    imageLoaded = true;
                                                  }

                                                  // Close the loading dialog
                                                  Navigator.of(context).pop();

                                                  if (imageLoaded) {
                                                    // Show the image in a new dialog, with full size handling
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.9, // Adjust size
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.7, // Adjust size
                                                            child: Image.file(
                                                                imageFile,
                                                                fit: BoxFit
                                                                    .contain), // Display the image
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // Close the image dialog
                                                              },
                                                              child:
                                                                  Text('Close'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "لم يتم العثور على الصورة"); // "Image not found" in Arabic
                                                  }
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "No valid image path provided.");
                                                }
                                              },
                                              icon: Icon(
                                                Icons.image,
                                                color: Color(0xFF157283),
                                                size: 40,
                                              ),
                                            ),
                                            SizedBox(width: 16.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    ' التاريخ : ${desc.EntryDate}\n'
                                                    ' الوقت: ${desc.EntryTime}\n'
                                                    ' المعدة رقم : ${desc.EqupID}\n'
                                                    ' من قبل : ${desc.EntryName}',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                    ),
                                                  ),
                                                  // ElevatedButton(
                                                  //   onPressed: () {
                                                  //     // Action for the button
                                                  //   },
                                                  //   style: ElevatedButton
                                                  //       .styleFrom(
                                                  //     backgroundColor: Color(
                                                  //         0xFF157283), // Button background color
                                                  //     foregroundColor: Colors
                                                  //         .white, // Text color
                                                  //     shape:
                                                  //         RoundedRectangleBorder(
                                                  //       borderRadius:
                                                  //           BorderRadius.circular(
                                                  //               8), // Rounded corners
                                                  //       side: BorderSide(
                                                  //           color: Color(
                                                  //               0xFF157283),
                                                  //           width:
                                                  //               2), // Border color and width
                                                  //     ),
                                                  //     padding: EdgeInsets.symmetric(
                                                  //         horizontal: 12,
                                                  //         vertical:
                                                  //             8), // Button padding
                                                  //   ),
                                                  //   child: Container(
                                                  //     width: 170,
                                                  //     child: Row(
                                                  //       children: [
                                                  //         Icon(
                                                  //           Icons
                                                  //               .check_box_rounded,
                                                  //         ),
                                                  //         SizedBox(
                                                  //           width: 5,
                                                  //         ),
                                                  //         // Text(
                                                  //         //   "تأكيد الأطلاع",
                                                  //         //   style: TextStyle(
                                                  //         //       fontSize: 14,
                                                  //         //       fontWeight:
                                                  //         //           FontWeight
                                                  //         //               .bold),
                                                  //         // ),
                                                  //       ],
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
