
import 'package:cleanercms/screens/schedule_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cleanercms/const/constant.dart';
import 'package:cleanercms/screens/main_screen.dart';
import 'package:cleanercms/screens/report_screen.dart';
import 'package:cleanercms/screens/user_table_screen.dart';
import 'package:cleanercms/screens/Community.dart';
import 'package:cleanercms/screens/pickup_screen.dart';
import 'package:flutter/material.dart';
import 'package:cleanercms/screens/community_map_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyC2KJhoP5_COunZcJ656P3SnujLpT021b4",
          authDomain: "cleaner-3c67d.firebaseapp.com",
          projectId: "cleaner-3c67d",
          storageBucket: "cleaner-3c67d.appspot.com",
          messagingSenderId: "185191729917",
          appId: "1:185191729917:web:7584fef29c35cc98fc0c94",
          measurementId: "G-QF7YCZTWSE"
      )
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cleaner CMS',

      routes: {
        '/dashboard': (context) => MainScreen(),
        '/users': (context) => UserTableScreen(),
        '/reports': (context) => ReportTableScreen(),
        '/community': (context) => CommunityScreen(),
        '/map': (context) => ReportMap(),
        '/pickup_requests': (context) => PickupScreen(),
        '/schedule': (context) => SchedulePage(),

      },
      initialRoute: '/',

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        brightness: Brightness.dark,
      ),
      home:
      MainScreen(),
      //   UserTableScreen()
    );
  }
}
