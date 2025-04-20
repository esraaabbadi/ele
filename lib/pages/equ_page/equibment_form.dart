import 'package:equapp/controller/apiservices.dart';
import 'package:equapp/models/formTemplate.dart';

import 'package:flutter/material.dart';

class FormTemplatePage extends StatefulWidget {
  final String FormType;
  final String formID;
  final String EMPID;
  final String Group;

// FormType
  const FormTemplatePage(
      {required this.formID,
      required this.FormType,
      required this.EMPID,
      required this.Group});

  @override
  _FormTemplatePageState createState() => _FormTemplatePageState();
}

class _FormTemplatePageState extends State<FormTemplatePage> {
  final ApiService apiService = ApiService();
  late Future<List<FormTemplate>> _formTemplates;
  Map<String, String> enteredTexts = {};
  Map<String, TextEditingController> textControllers = {};
  Map<String, String> selectedChoices = {}; // Store selected dropdown choices
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _formTemplates =
        ApiService().getFormTemplate('${widget.formID}', '${widget.EMPID}');
  }

  @override
  void dispose() {
    // Dispose all text controllers
    textControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void initializeSelectedChoices(List<FormTemplate> templates) {
    for (var template in templates) {
      selectedChoices.putIfAbsent(
          template.itemText, () => ''); // Default to empty
    }
  }

  Future<void> showMessageDialog(
      BuildContext context, String message, Color bgColor) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: bgColor, // Background color based on status
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("تم",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> showSuccessMessageAndPop(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents user from closing manually
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "تم الحفظ بنجاح",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );

    // Wait for 5 seconds, then close the dialog and pop the page
    await Future.delayed(Duration(seconds: 5));
    Navigator.of(context).pop(); // Close dialog
    Navigator.of(context).pop(); // Pop the page
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(size: 40, color: Colors.white),
        backgroundColor: Color(0xFF157283),
        title: Center(
            child: Text(
          'تفاصيل النموذج',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: FutureBuilder<List<FormTemplate>>(
        future: _formTemplates,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
              'لا توجد بيانات',
              style: TextStyle(color: Colors.black),
            ));
          }

          List<FormTemplate> templates = snapshot.data!;
          if (selectedChoices.isEmpty) {
            initializeSelectedChoices(templates);
          }
          templates.sort((a, b) =>
              int.parse(a.itemOrder).compareTo(int.parse(b.itemOrder)));

          // templates.sort((a, b) => (a.itemOrder).compareTo(b.itemOrder));

          return Column(
            children: [
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,

                  border:
                      Border.all(color: Colors.black, width: 2), // Black border
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'رقم المرجعي:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      templates.first.formID,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 11, 26, 109)),
                    ),
                    SizedBox(
                      width: 300,
                    ),
                    Text(
                      'رقم النموذج:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      widget.formID,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 11, 26, 109)),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: templates.length, // Use firstThreeTemplates
                  itemBuilder: (context, index) {
                    final template =
                        templates[index]; // Use firstThreeTemplates
                    switch (template.itemDataType) {
                      case 'H':
                        return ListTile(
                          title: Center(
                            widthFactor: double.infinity,
                            child: Text(template.itemText,
                                style: TextStyle(
                                  backgroundColor: Colors.grey[500],
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        );

                      case 'E':
                        // Initialize the TextEditingController for this field if not already done
                        if (!textControllers.containsKey(template.itemText)) {
                          textControllers[template.itemText] =
                              TextEditingController(
                                  text:
                                      template.formItemDetail); // Default value
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .center, // Align items properly
                            children: [
                              Text(
                                template.itemText,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                  width:
                                      16), // Space between text and input box
                              Expanded(
                                child: TextField(
                                  controller:
                                      textControllers[template.itemText],
                                  decoration: InputDecoration(
                                    hintText: 'ادخل النص هنا',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true, // Fill background
                                    fillColor:
                                        Colors.grey[200], // Background color
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Color(0xFF157283), width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Color(0xFF157283), width: 2),
                                    ),
                                  ),
                                  style: TextStyle(color: Colors.black),
                                  onChanged: (value) {
                                    // Update the value in enteredTexts
                                    enteredTexts[template.itemText] = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      case 'I':
                        return Column(
                          children: [
                            ListTile(
                              subtitle: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Item Text with Red Asterisk for Required Fields
                                  Row(
                                    children: [
                                      Text(
                                        template.itemText,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (template.ItemRequired ==
                                          'Y') // Show * only for required fields
                                        Text(
                                          ' *',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                      width:
                                          16), // Add spacing between text and dropdown

                                  // Dropdown
                                  Expanded(
                                    child: DropdownButton<String>(
                                      hint: Text("اختر"),
                                      isExpanded: true,
                                      value: selectedChoices[template.itemText]!
                                              .isNotEmpty
                                          ? selectedChoices[template.itemText]
                                          : null, // Null when empty
                                      items: [
                                        DropdownMenuItem(
                                          value: '--اختر--',
                                          child: Text('--اختر--',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                        ...template.formItemDetail
                                            .split('_')
                                            .map((item) {
                                          return DropdownMenuItem(
                                            value: item,
                                            child: Text(item),
                                          );
                                        }).toList(),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          selectedChoices[template.itemText] =
                                              value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );

                      default:
                        return SizedBox.shrink();
                    }
                  },
                ),
              ),

              // Add Save and Cancel buttons at the end of the page
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(children: [
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null // Disable button when loading
                            : () async {
                                List<String> missingFields = [];
                                int counter = 1;

                                // Check for empty text fields
                                textControllers.forEach((key, controller) {
                                  final template = templates
                                      .firstWhere((t) => t.itemText == key);
                                  if (template.itemDataType == 'E' &&
                                      template.ItemRequired == 'Y' &&
                                      controller.text.trim().isEmpty) {
                                    missingFields
                                        .add('$counter. ${template.itemText}');
                                    counter++;
                                  }
                                });

                                // Check for unselected dropdown choices
                                selectedChoices.forEach((key, value) {
                                  final template = templates
                                      .firstWhere((t) => t.itemText == key);
                                  if (template.itemDataType == 'I' &&
                                      template.ItemRequired == 'Y' &&
                                      (value.isEmpty || value == '--اختر--')) {
                                    missingFields
                                        .add('$counter. ${template.itemText}');
                                    counter++;
                                  }
                                });

                                if (missingFields.isNotEmpty) {
                                  // Show missing fields dialog and return early (no loading dialog)
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'نموذج غير مكتمل',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 190, 56, 46),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Text(
                                          'يرجى تعبئة الحقول الفارغة: \n${missingFields.join('\n')}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFF157283),
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 32, vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(
                                              'تم',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return; // Stop further execution
                                }

                                // Show loading dialog (prevents user interaction)
                                showDialog(
                                  context: context,
                                  barrierDismissible:
                                      false, // Prevent dismissing by tapping outside
                                  builder: (context) => WillPopScope(
                                    onWillPop: () async =>
                                        false, // Disable back button
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Color(0xFF157283)),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'جارِ تحميل يرجى الانتظار ',
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
                                  ),
                                );

                                // Prepare data for API
                                List<Map<String, String>> formValues = [];
                                textControllers.forEach((key, controller) {
                                  final template = templates
                                      .firstWhere((t) => t.itemText == key);
                                  formValues.add({
                                    'ItemText': key,
                                    'ItemValue': controller.text,
                                    'ItemOrder': template.itemOrder,
                                  });
                                });

                                selectedChoices.forEach((key, value) {
                                  final template = templates
                                      .firstWhere((t) => t.itemText == key);
                                  formValues.add({
                                    'ItemText': key,
                                    'ItemValue': value,
                                    'ItemOrder': template.itemOrder,
                                  });
                                });

                                try {
                                  print("FormValues to send: $formValues");
                                  var allData =
                                      await apiService.saveSubmittedFormInfo(
                                    '${widget.Group}',
                                    "${widget.EMPID}", // User ID
                                    formValues, // Prepared data
                                    "${widget.FormType}", // Form type
                                    "${templates.first.formID}", // Form ID
                                  );

                                  Navigator.pop(
                                      context); // Close loading dialog

                                  if (allData.isNotEmpty) {
                                    await showSuccessMessageAndPop(context);
                                  } else {
                                    await showMessageDialog(
                                      context,
                                      'لا يمكن حفظه يرجى المحاولة مرة أخرى.',
                                      Color.fromARGB(255, 190, 56, 46)
                                          .withOpacity(.8),
                                    );
                                  }
                                } catch (error) {
                                  Navigator.pop(
                                      context); // Close loading dialog
                                  print("Error during form submission: $error");

                                  await showMessageDialog(
                                    context,
                                    'حدث خطأ: $error',
                                    Color.fromARGB(255, 190, 56, 46)
                                        .withOpacity(.8),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF157283),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side:
                                BorderSide(color: Color(0xFF157283), width: 1),
                          ),
                          elevation: 5,
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                'ارسال',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    if (isLoading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.5), // Dark overlay
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ]),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
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
                                color: const Color.fromARGB(255, 190, 56, 46),
                                width: 1), // Black border
                          ),
                          elevation: 5, // Button shadow effect
                        ),
                        child: Text(
                          "الغاء",
                          style: TextStyle(
                            fontSize: 18, // Increase text size
                            fontWeight: FontWeight.bold, // Make text bold
                          ),
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 80,
              )
            ],
          );
        },
      ),
    );
  }
}
