import 'package:equapp/controller/Login.dart';
import 'package:equapp/controller/apiservices.dart';
import 'package:equapp/pages/Home Pages/home.dart';
import 'package:equapp/util/num.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogPage extends StatefulWidget {
  @override
  State<LogPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LogPage> {
  LoginController loginController = LoginController();
  @override
  void initState() {
    super.initState();
    _loadSavedUsername();
  }

  void _loadSavedUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('savedUsername');

    debugPrint("Loading saved username: $savedUsername");

    if (savedUsername != null) {
      setState(() {
        nameCon.text = savedUsername;
      });
    }
  }

  TextEditingController nameCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  bool isRememberMeChecked = false;
  bool _isObscure = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Image.asset("assets/images/Mas.png"),
              // Container(
              //   color: Color(0xFF157283),
              //   height: MediaQuery.of(context).size.height * 0.4,
              // ),

              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: nameCon,
                                cursorColor: Color(0xFF157283),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                                textDirection: TextDirection.rtl,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  EnglishDigitFormatter(), // 👈 this is the key
                                ],
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person,
                                      color: Color(0xFF157283)),
                                  labelText: "رمز الدخول الى الخدمة",
                                  labelStyle: TextStyle(
                                      color: Color(0xFF157283), fontSize: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                        color: Color(0xFF157283), width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide:
                                        BorderSide(color: Color(0xFF157283)),
                                  ),
                                ),
                              ),

                              SizedBox(height: 16),
                              SizedBox(height: 16),

                              //Password TextFormField
                              TextFormField(
                                controller: passwordCon,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                                obscureText: !_isObscure,
                                cursorColor: Color(0xFF157283),
                                decoration: InputDecoration(
                                  prefixIcon: IconButton(
                                    icon: Icon(
                                      _isObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Color(0xFF157283),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                  ),
                                  labelText: "كلمة المرور",
                                  labelStyle: TextStyle(
                                      color: Color(0xFF157283), fontSize: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Color(0xFF157283),
                                      width: 2.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide: BorderSide(
                                        color: Color(0xFF157283),
                                      )),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 16.0),
                                ),
                              ),
                              SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      // Show loading dialog first
                                      showDialog(
                                          context: context,
                                          barrierDismissible:
                                              false, // Prevents dialog from being closed outside
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                'اشعار',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // Show loading indicator until the image is loaded

                                                  SizedBox(height: 5),
                                                  Text(
                                                    "عملية تغيير كلمة المرور تتم من خلال تطبيق بوابة الموظف كون كلمة المرور موحده لكل التطبيقات, لذا لتغيير كلمة المرور الخاصة بك قم بذلك من خلال تطبيق بوابة وذلك لغايات التحقق",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ), // "Please wait" in Arabic
                                                  // "Loading image..." in Arabic
                                                ],
                                              ),
                                              actions: [
                                                Center(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close success dialog
                                                      // Navigate back one page
                                                    },
                                                    child: Text(
                                                      'اغلاق',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF003F54),
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Text(
                                      'نسيت كلمة المرور',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: Color(0xFF003F54),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 13,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () async {
                                    // Validate if fields are empty
                                    if (nameCon.text.isEmpty ||
                                        passwordCon.text.isEmpty) {
                                      String errorMessage = nameCon
                                                  .text.isEmpty &&
                                              passwordCon.text.isEmpty
                                          ? "يرجى إدخال اسم المستخدم وكلمة المرور"
                                          : nameCon.text.isEmpty
                                              ? "يرجى إدخال اسم المستخدم"
                                              : "يرجى إدخال كلمة المرور";

                                      // Ensure SnackBar is displayed correctly
                                      Future.delayed(Duration.zero, () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(errorMessage),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      });
                                      return; // Stop execution if fields are empty
                                    }
                                    showDialog(
                                      context: context,
                                      barrierDismissible:
                                          false, // Prevent closing by tapping outside
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CircularProgressIndicator(
                                                    color: Color(
                                                        0XFF157283)), // Loader
                                                SizedBox(height: 16),
                                                Text(
                                                  "يرجى الأنتظار...",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    // API Call
                                    ApiService apiService = ApiService();
                                    await apiService
                                        .checklogin(
                                            nameCon.text, passwordCon.text)
                                        .then((onValue) async {
                                      Navigator.pop(context);
                                      // print(
                                      //     "API Response: $onValue"); // Debugging - Print the API response

                                      // Check if API returns an empty "Data" object (indicating failure)
                                      if (onValue?['data'].isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "اسم المستخدم أو كلمة المرور غير صحيحة"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return; // Stop execution if credentials are incorrect
                                      }
// Save username in SharedPreferences
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setString(
                                          'savedUsername', nameCon.text);
                                      debugPrint(
                                          "Username saved: ${nameCon.text}");
                                      // If login is successful, navigate to HomePage
                                      if (onValue?['data']['EmpName'] != null) {
                                        // Save username to SharedPreferences after successful login

                                        String empRole = onValue?['data']
                                            ['CurrentUserLoginRole'];
                                        String employeeGroup =
                                            empRole == 'Electricity Employee'
                                                ? "موظف بدائرة الكهرباء"
                                                : "$empRole";

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                HomePage(
                                              onValue?['data']['EmpName'],
                                              nameCon.text,
                                              onValue?['data']['RelatedGroup'],
                                              employeeGroup,
                                            ),
                                          ),
                                        );
                                      }
                                    }).catchError((error) {
                                      Navigator.pop(context);
                                      print(
                                          "API Error: $error"); // Debugging - Print any API call errors
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "حدث خطأ أثناء الاتصال بالخادم"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0XFF157283),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.0),
                                  ),
                                  child: Text(
                                    "تسجيل الدخول",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Logo and  text
              Positioned(
                top: MediaQuery.of(context).size.height * 0.04,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   'assets/images/logo.png',
                    //   height: 50,
                    // ),
                    // SizedBox(height: 10),
                    // Text(
                    //   'شركة مصفاة البترول الارنية\nJordan Petrolum Refinary CO.LTD\n',
                    //   textAlign: TextAlign.center,
                    //   style: Theme.of(context).textTheme.titleMedium,
                    // ),
                    SizedBox(height: 350),
                    Text(
                      ' نظام ادارة ومراقبة المعدات في الشركة',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
