import 'dart:io';
import 'package:equapp/controller/apiservices.dart';
import 'package:equapp/models/equ_id.dart';
import 'package:equapp/pages/Maintenance%20Request%20pages/equipment_selection.dart';
import 'package:equapp/widget/qr.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class MaintenanceRequestPage extends StatefulWidget {
  final String EName;
  final String EMPID;
  MaintenanceRequestPage({required this.EName, required this.EMPID});
  @override
  _MaintenanceRequestPageState createState() => _MaintenanceRequestPageState();
}

class _MaintenanceRequestPageState extends State<MaintenanceRequestPage> {
  // TextEditingController searchController = TextEditingController();
  final TextEditingController requestDetailsController =
      TextEditingController();
  final ApiService apiService = ApiService();
  List<EquipmentID> allData = [];

  // final ImagePicker _imagePicker = ImagePicker();
  XFile? pickedImage;
  EquipmentID? selectedEquipment;
  File? selectedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchFormData();
  }

  void openQRScanner() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRViewExample(
          onScan: (result) {
            final message = selectedEquipment == null
                ? "لا يوجد معده بهذا الاسم"
                : "تم مسح الرقم: ${selectedEquipment!.id}";

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message, textAlign: TextAlign.center),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color.fromARGB(221, 192, 54, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 250),
              ),
            );
          },
        ),
      ),
    );
  }

  Future fetchFormData() async {
    try {
      List<EquipmentID> fetchedData =
          await apiService.getFireFighEqp(widget.EMPID);
      if (fetchedData.isEmpty) {
        Fluttertoast.showToast(msg: "No data available.");
      } else {
        setState(() {
          allData = fetchedData;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      pickedImage = image;
    });
  }

  String getCurrentShift() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour > 6 && hour <= 14) {
      return 'A';
    } else if (hour > 14 && hour <= 22) {
      return 'B';
    } else if (hour > 22 && hour < 6) {
      return 'C';
    } else {
      return 'خطأ في استيراد الوقت';
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from closing it
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Disable back button press
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF157283)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'جارِ تحميل يرجى الانتظار البيانات',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(size: 40, color: Colors.white),
        backgroundColor: Color(0xFF157283),
        title: Center(
            child: Text(
          'تسجيل طلب صيانة للمعدات',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Container(
                width: 520,
                height: 50,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 27, 164, 189),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    'يرجى تعبئة جميع الحقول المطلوبة  * ',
                    style: TextStyle(
                      fontSize: 20.0,
                      // fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 250,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                        ),
                        label: Text(
                          'مسح كود QR',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF157283),
                          side: BorderSide(
                              color: Color(0xFF157283),
                              width: .5), // Border color and thickness
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Optional: Rounded corners
                          ),
                        ),
                        onPressed: openQRScanner,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Dropdown to Select Equipment
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Container(
                            width: 250,
                            height: 55,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.list, color: Colors.white),
                              label: Text('اختر المعدة',
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white)),
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0xFF157283),
                                side: BorderSide(
                                    color: Color(0xFF157283),
                                    width: .5), // Border color and thickness
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Optional: Rounded corners
                                ),
                              ),
                              onPressed: () async {
                                final selected = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EquipmentSelectionPage(
                                            equipmentList: allData),
                                  ),
                                );

                                if (selected != null &&
                                    selected is EquipmentID) {
                                  setState(() {
                                    selectedEquipment = selected;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Text('المعدة: $selectedEquipment',
              //     style: ThemeData().textTheme.titleSmall),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  selectedEquipment != null
                      ? "تم اختيار المعدة رقم:  ${selectedEquipment!.id}"
                      : "يرجى اختيار معدة.",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      backgroundColor: Colors.grey[300]),
                ),
              ),
              SizedBox(height: 16),
              Text(
                ' بيانات الطلب',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(
                      FocusNode()); // This will unfocus all input fields
                },
                child: TextField(
                  controller: requestDetailsController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    focusColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFF157283)), // Default border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFF157283),
                          width: 2.0), // Border when not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFF157283),
                          width: 2.0), // Border when focused
                    ),
                    hintText: 'ادخل بيانات الطلب',
                  ),
                  style: TextStyle(
                      color: Colors.black, backgroundColor: Colors.grey[200]),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'تحميل صورة',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final pickedFile =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      selectedImage = File(pickedFile.path);
                    });
                    Fluttertoast.showToast(msg: "تم التقاط الصورة بنجاح");
                  } else {
                    Fluttertoast.showToast(msg: "لم يتم التقاط الصورة");
                  }
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF157283), width: 2),
                  ),
                  child: selectedImage != null
                      ? Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.camera_alt, color: Colors.grey, size: 50),
                ),
              ),

              SizedBox(height: 150),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: isLoading // Check if loading is already in progress
                        ? null // Disable the button if isLoading is truecontext:context
                        : () async {
                            if (selectedEquipment == null ||
                                selectedImage == null ||
                                requestDetailsController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "يرجى تعبئة جميع الحقول",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 190, 56, 46),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              );
                              return;
                            }
                            // if (selectedImage == null &&
                            //     requestDetailsController.text.isEmpty) {
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //         title: Text(
                            //           "  يرجى تعبئة بيانات الطلب و رفع صورة ",
                            //           style: TextStyle(
                            //             color: Color.fromARGB(255, 190, 56, 46),
                            //             fontWeight: FontWeight.bold,
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   );
                            //   return;
                            // }
                            // if (selectedImage == null) {
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //         title: Text(
                            //           " يرجى رفع صورة",
                            //           style: TextStyle(
                            //             color: Color.fromARGB(255, 190, 56, 46),
                            //             fontWeight: FontWeight.bold,
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   );
                            //   return;
                            // }

                            // setState(() {
                            //   isLoading = true; // Disable button & show loading
                            // });

                            try {
                              // ✅ Show loading dialog before starting API call
                              showLoadingDialog(context);

                              var registerResponse =
                                  await apiService.RegisterSRQ(
                                widget.EMPID,
                                selectedImage!.path,
                                requestDetailsController.text.toString(),
                                selectedEquipment!.id.toString(),
                              );

                              // ✅ Close loading dialog after API call completes
                              Navigator.of(context).pop();

                              if (registerResponse.isNotEmpty) {
                                var successMessage =
                                    registerResponse.first.Success;

                                if (successMessage == "Saved") {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.grey[200],
                                        title: Center(
                                          child: Text(
                                            "تم الحفظ بنجاح",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          Center(
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close success dialog
                                                Navigator.of(context)
                                                    .pop(); // Navigate back one page
                                              },
                                              child: Text(
                                                'موافق',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          "حدث خطأ أثناء الحفظ.",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 190, 56, 46),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "فشل في ارسال الطلب .",
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 190, 56, 46),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            } catch (error) {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // Prevent user from dismissing
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(
                                            color: Colors.blue),
                                        SizedBox(height: 20),
                                        Text(
                                          "حدث خطأ أثناء إرسال الطلب: $error",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } finally {
                              setState(() {
                                isLoading =
                                    false; // ✅ Re-enable button after error
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF157283),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Color(0xFF157283), width: 1),
                      ),
                      elevation: 5,
                    ),
                    child: SizedBox(
                      width: 250,
                      child: Center(
                        child: Text(
                          'إرسال',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 190, 56, 46), // Button background color
                        foregroundColor: Colors.white, // Text color
                        padding: EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                          side: BorderSide(
                              color: Color.fromARGB(255, 190, 56, 46),
                              width: 1), // Black border
                        ),
                        elevation: 5, // Button shadow effect
                      ),
                      child: SizedBox(
                          width: 250,
                          child: Center(
                            child: Text(
                              'الغاء',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ))),
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: ElevatedButton(
              //     child: Text("ارسال"),
              //     onPressed: () async {
              //       if (selectedEquipment == null || selectedImage == null) {
              //         Fluttertoast.showToast(msg: "يرجى اختيار نموذج ورفع صورة");
              //         return;
              //       }
              //       try {
              //         var registerResponse = await apiService.RegisterSRQ();
              //         if (registerResponse != null) {
              //           Fluttertoast.showToast(msg: "تم إرسال الطلب بنجاح!");
              //           print("Register Response: $registerResponse");
              //         } else {
              //           Fluttertoast.showToast(
              //               msg: "لم يتم الحصول على استجابة صحيحة من الخادم.");
              //         }
              //       } catch (e) {
              //         Fluttertoast.showToast(msg: "حدث خطأ أثناء إرسال الطلب");
              //         print("Error: $e");
              //       }
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
