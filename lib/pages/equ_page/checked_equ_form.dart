import 'package:equapp/controller/apiservices.dart';
import 'package:equapp/models/formTemplate.dart';

import 'package:flutter/material.dart';

class FormCheckedEquTemplatePage extends StatefulWidget {
  final String FormType;
  final String formID;

// FormType
  const FormCheckedEquTemplatePage(
      {required this.formID, required this.FormType});

  @override
  _FormTemplatePageState createState() => _FormTemplatePageState();
}

class _FormTemplatePageState extends State<FormCheckedEquTemplatePage> {
  final ApiService apiService = ApiService();
  late Future<List<FormTemplate>> _formTemplates;
  Map<String, String> enteredTexts = {};
  Map<String, TextEditingController> textControllers = {};
  Map<String, String> selectedChoices = {}; // Store selected dropdown choices

  @override
  void initState() {
    super.initState();
    _formTemplates = ApiService().GetFormInfo('${widget.formID}', '90013234');
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('تفاصيل النموذج')),
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
                padding: EdgeInsets.all(16),
                color: Colors.grey[200],
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
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  final template = templates[index];
                  switch (template.itemDataType) {
                    case 'H':
                      return Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.blue[100],
                        child: Center(
                          child: Text(
                            template.itemText,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blue[900]),
                          ),
                        ),
                      );
                    case 'E':
                      if (!textControllers.containsKey(template.itemText)) {
                        textControllers[template.itemText] =
                            TextEditingController(text: template.FormItemValue);
                      }
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(template.itemText,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black))),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: textControllers[template.itemText],
                                decoration:
                                    InputDecoration(hintText: 'ادخل النص هنا'),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      );
                    case 'I':
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(template.itemText,
                                    style: TextStyle(fontSize: 16))),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 3,
                              child: DropdownButton<String>(
                                hint: Text("اختر"),
                                isExpanded: true,
                                value: selectedChoices[template.itemText]!
                                        .isNotEmpty
                                    ? selectedChoices[template.itemText]
                                    : null,
                                items: template.formItemDetail
                                    .split('_')
                                    .map((item) {
                                  return DropdownMenuItem(
                                      value: item, child: Text(item));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedChoices[template.itemText] = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    default:
                      return SizedBox.shrink();
                  }
                },
              )),

              // Add Save and Cancel buttons at the end of the page
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      List<String> missingFields = [];
                      int counter = 1;

                      // Check for empty text fields
                      textControllers.forEach((key, controller) {
                        final template =
                            templates.firstWhere((t) => t.itemText == key);
                        // Only check for 'E' (Entry Text) type fields if ItemRequired is "Y"
                        if (template.itemDataType == 'E' &&
                            template.ItemRequired ==
                                'Y' && // Check if the field is mandatory
                            controller.text.trim().isEmpty) {
                          missingFields.add(
                              '$counter. ${template.itemText}'); // Add field name with number
                          counter++;
                        }
                      });

                      // Check for unselected dropdown choices in 'I' (Dropdown List) cases
                      selectedChoices.forEach((key, value) {
                        final template =
                            templates.firstWhere((t) => t.itemText == key);
                        // Only check for 'I' (Dropdown List) type fields if ItemRequired is "Y"
                        if (template.itemDataType == 'I' &&
                            template.ItemRequired ==
                                'Y' && // Check if the field is mandatory
                            (value.isEmpty || value == '--اختر--')) {
                          missingFields.add(
                              '$counter. ${template.itemText}'); // Add field name with number
                          counter++;
                        }
                      });

                      if (missingFields.isNotEmpty) {
                        // Display an alert dialog for missing fields
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('نموذج غير مكتمل'),
                              content: Text(
                                'يرجى تعبئة الحقول الفارغة: \n${missingFields.join('\n')}', // Each missing field on a new line
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('تم'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Proceed to prepare and send data if all fields are filled
                        List<Map<String, String>> formValues = [];

                        // Add text field data
                        textControllers.forEach((key, controller) {
                          final template =
                              templates.firstWhere((t) => t.itemText == key);
                          formValues.add({
                            'ItemText': key,
                            'ItemValue': controller.text,
                            'ItemOrder': template.itemOrder,
                          });
                        });

                        // Add dropdown data
                        selectedChoices.forEach((key, value) {
                          final template =
                              templates.firstWhere((t) => t.itemText == key);
                          formValues.add({
                            'ItemText': key,
                            'ItemValue': value,
                            'ItemOrder': template.itemOrder,
                          });
                        });

                        // Submit data to the API
                        try {
                          print("FormValues to send: $formValues");
                          var allData = await apiService.UpdateFormInfo(
                            "90013234", // User ID
                            formValues, // Prepared data
                            "${widget.FormType}", // Form type
                            "${templates.first.formID}", // Form ID
                          );
                          if (allData.isNotEmpty) {
                            // Show success snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('تم الحفظ بنجاح'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            // Show error snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'لا يمكن حفظه يرجى المحاوله مرة اخرى.'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        } catch (error) {
                          print("Error during form submission: $error");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('An error occurred: $error'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                    child: Text('حفظ'),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("الغاء"))
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
