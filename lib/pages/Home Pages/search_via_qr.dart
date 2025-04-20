import 'package:equapp/controller/apiservices.dart';
import 'package:equapp/models/equ_id.dart';
import 'package:equapp/models/query_equid.dart';
import 'package:equapp/widget/custom_Appbar.dart';
import 'package:equapp/widget/custom_DataTable.dart';
import 'package:equapp/widget/qr.dart';
import 'package:flutter/material.dart';

class SearchQuery extends StatefulWidget {
  final String EMPID;

  SearchQuery({
    required this.EMPID,
  });

  @override
  State<SearchQuery> createState() => _SearchQueryState();
}

class _SearchQueryState extends State<SearchQuery> {
  final ApiService apiService = ApiService();
  List<EquipmentID> equipmentIDs = [];
  List<EquDetailsData> equipmentDetails = [];
  TextEditingController searchController = TextEditingController();
  String statusMessage = '';
  String errorMessage = '';
  bool isLoading = false;
  @override
  @override
  @override
  void initState() {
    super.initState();
    fetchEquipmentIDs();
  }

  Future<void> fetchEquipmentIDs() async {
    setState(() {
      isLoading = false;

      errorMessage = '';
      statusMessage = '';
    });
    try {
      List<EquipmentID> fetchedIDs =
          await apiService.getFireFighEqp("90016134");
      setState(() {
        equipmentIDs = fetchedIDs;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching equipment IDs: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Future<void> fetchEquipmentIDs() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //       errorMessage = '';
  //       statusMessage = '';
  //     });
  //     List<EquipmentID> fetchedIDs =
  //         await apiService.getFireFighEqp("90016134");
  //     setState(() {
  //       equipmentIDs = fetchedIDs;
  //     });
  //   } catch (e) {
  //     debugPrint(
  //         "Error fetching equipment IDs: ${e.toString()}"); // ✅ Better Debugging
  //     setState(() {
  //       errorMessage = "خطأ في جلب بيانات المعدات.";
  //     });
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<void> fetchEquipmentDetails(String equipmentID, String UserID) async {
    try {
      List<EquDetailsData> fetchedDetails =
          await apiService.getEqpHistoryByQRID(equipmentID, widget.EMPID);
      setState(() {
        if (fetchedDetails.isEmpty) {
          statusMessage = "لا توجد بيانات لهذا الرقم المدخل.";
          equipmentDetails = [];
        } else {
          equipmentDetails = fetchedDetails;
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = "حدث خطأ أثناء جلب بيانات المعدة: $e";
        equipmentDetails = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleSearch() async {
    final equipmentID = searchController.text.trim();
    if (equipmentID.isEmpty) {
      setState(() {
        statusMessage = "يرجى إدخال رقم المعدة.";
        equipmentDetails = [];
      });
      return; // 🚨 Stops execution here (GOOD)
    }
    setState(() {
      // ✅ Show loading before searching
      statusMessage = "";
      equipmentDetails = [];
      isLoading = true; // Start loading
    });
    try {
      // Fetch the list of available equipment IDs if not already fetched
      if (equipmentIDs.isEmpty) {
        equipmentIDs = await apiService.getFireFighEqp("90016134");
      }
      // Check if the entered ID exists in the fetched list
      final isValidEquipmentID =
          equipmentIDs.any((equipment) => equipment.id == equipmentID);

      if (!isValidEquipmentID) {
        setState(() {
          statusMessage = "رقم المعدة المدخل غير موجود.";
          equipmentDetails = [];
        });
        return;
      }
      // If found, fetch its details
      await fetchEquipmentDetails(equipmentID, widget.EMPID);
    } catch (e) {
      setState(() {
        statusMessage = "حدث خطأ أثناء البحث: $e";
        equipmentDetails = [];
      });
    } finally {
      setState(() {
        isLoading = false; // End loading once fetch is complete
      });
    }
  }

  void openQRScanner() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRViewExample(
          onScan: (result) async {
            String equipmentID = result; // The scanned equipment ID
            if (equipmentID.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("لم يتم مسح رمز QR بشكل صحيح",
                      textAlign: TextAlign.center),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: const Color.fromARGB(221, 192, 54, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 250),
                ),
              );
              return;
            }

            // Check if the scanned ID exists in the fetched equipmentIDs
            final isValidEquipmentID =
                equipmentIDs.any((equipment) => equipment.id == equipmentID);

            if (!isValidEquipmentID) {
              // If the scanned equipment ID doesn't exist, show a message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("لا يوجد معدة بهذا الرقم",
                      textAlign: TextAlign.center),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: const Color.fromARGB(221, 192, 54, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 250),
                ),
              );
              return;
            }

            // Start loading state
            setState(() {
              isLoading = true;
              errorMessage = '';
              statusMessage = '';
            });

            // Fetch equipment details using the scanned equipment ID
            try {
              final fetchedDetails = await apiService.getEqpHistoryByQRID(
                  equipmentID, widget.EMPID);
              setState(() {
                if (fetchedDetails.isEmpty) {
                  statusMessage = "لا توجد بيانات لهذا الرقم المدخل.";
                  equipmentDetails = [];
                } else {
                  equipmentDetails = fetchedDetails;
                  statusMessage = "تم مسح الرقم: $equipmentID بنجاح";
                }
              });
            } catch (e) {
              setState(() {
                errorMessage = "حدث خطأ أثناء جلب بيانات المعدة: $e";
                equipmentDetails = [];
              });
            } finally {
              setState(() {
                isLoading = false;
              });
            }

            // Show a Snackbar with a confirmation message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  equipmentDetails.isNotEmpty
                      ? "تم مسح الرقم: $equipmentID بنجاح"
                      : "لا توجد بيانات لهذا الرقم المدخل.",
                  textAlign: TextAlign.center,
                ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        text: "الأستعلام عبر الرمز",
        BGColor: Colors.white,
        TextColor: Colors.black,
        IconColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "للأستعلامات عن فحوصات المعدة قم بادخال الرقم المرجعي او قراءة رمز QR ",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      cursorColor: Color(0xFF157283),
                      decoration: InputDecoration(
                        hintText: ' أدخل رقم النموذج/رقم المعدة للأستعلام ',
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
                    ),
                  ),
                  SizedBox(width: 8), // Space between TextField and Button
                  ElevatedButton(
                    onPressed: handleSearch, // Disable when loading
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF157283), // Button color
                      foregroundColor: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12), // Padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      elevation: 5, // Shadow effect
                    ),
                    child: Text(
                      "بحث",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 70,
                    height: 50,
                    child: IconButton(
                      icon: Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
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
                ],
              ),
              SizedBox(height: 20),
              if (isLoading && searchController.text.isNotEmpty)
                Center(
                  child: CircularProgressIndicator(), // Show loading spinner
                ),

              // / Show Status Message If No Equipment Data
              if (!isLoading && statusMessage.isNotEmpty)
                Center(
                  child: Text(
                    statusMessage,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),

              /// Show DataTable if Equipment Details Exist
              if (equipmentDetails.isNotEmpty)
                Expanded(
                  child: CustomDataTable(
                    title: "",
                    headers: ["النموذج", "رقم الفحص", "الفاحص", "تاريخ الفحص"],
                    rows: equipmentDetails.map((data) {
                      return [
                        data.z_DL01_51.toString(),
                        data.z_Y55FFNFN_39.toString(),
                        data.z_DL01_34.toString(),
                        data.z_Y55VMED_24.toString(),
                      ];
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
