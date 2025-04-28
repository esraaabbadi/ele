import 'dart:io';
import 'package:equapp/Pages/login.dart';
import 'package:equapp/pages/Home%20Pages/notification.dart';
import 'package:equapp/pages/Maintenance%20Request%20pages/Show_Maininance_Request.dart';
import 'package:equapp/pages/Maintenance%20Request%20pages/regester_maintenance_request.dart';
import 'package:equapp/pages/equ_page/all_equ.dart';
import 'package:equapp/pages/equ_page/equipmets.dart';
import 'package:equapp/pages/equ_page/required_daily_checks.dart';
import 'package:equapp/pages/equ_page/required_monthly_checks.dart';
import 'package:equapp/pages/equ_page/required_weekly_checks.dart';
import 'package:equapp/pages/equ_page/tasks_done_today.dart';
import 'package:equapp/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'ar',
    supportedLocales: [
      'ar',
    ],
  );
  runApp(LocalizedApp(delegate, MyApp()));
}
// Setup the MaterialApp

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? empID; // Store EMPID

  @override
  Widget build(BuildContext context) {
    // var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/login': (context) => LogPage(),
          '/maintenance_requests': (context) => ShowMainRequestPage(
                EMPID: empID ?? '', // Pass EMPID dynamically
                EName: '',
              ),
          '/register_maintenance': (context) => MaintenanceRequestPage(
                EName: '',
                EMPID: empID ?? '',
              ),
          '/equipment_details': (context) => EquipmentsPage(
                EMPID: empID ?? '',
                EName: '',
                Group: '',
              ),
          '/Required_Daily_Checks': (context) => RequiredDailyChecksPage(
                EMPID: '',
                Group: '',
              ),
          '/Required_Weekly_Checks': (context) => RequiredWeeklyChecksPage(
                EMPID: '',
                Group: '',
              ),
          '/Required_Monthly_Checks': (context) => RequiredMonthlyChecksPage(
                EMPID: '',
                Group: '',
              ),
          '/Equ_List_Checks': (context) => EquListPage(),
          '/Equ_Tasks_Done_Today': (context) => EquTasksDoneTodayPage(),
          '/notification': (context) => NotificationPage(
                EName: '',
                EMPID: '',
              ),
        },
        title: 'Flutter Translate Demo',
        locale: Locale('ar'), // Arabic locale
        supportedLocales: [Locale('ar'), Locale('en')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        // localizationsDelegates: [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   localizationDelegate
        // ],
        // supportedLocales: localizationDelegate.supportedLocales,
        // locale: localizationDelegate.currentLocale,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.grey.shade50,
          primaryColor: const Color(0xFF157283),
          textTheme: generalTheme,
        ),
        home: LogPage(), // Keep SplashPage, later navigate to HomePage
      ),
    );
  }

  // Function to set EMPID from HomePage
  void updateEmpID(String newEmpID) {
    setState(() {
      empID = newEmpID;
    });
  }
}
