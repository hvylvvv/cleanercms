import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_dashboard_ui/const/constant.dart';
import 'package:fitness_dashboard_ui/screens/main_screen.dart';
import 'package:fitness_dashboard_ui/screens/user_table_screen.dart';
import 'package:flutter/material.dart';


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
        // '/': (context) => HomePage(),
        // '/dashboard': (context) => DashboardPage(),
        '/users': (context) => UserTableScreen(),
        // '/reports': (context) => ReportsPage(),
        // '/pickup_requests': (context) => PickupRequestsPage(),
        // '/schedule': (context) => SchedulePage(),
        // '/signout': (context) => SignOutPage(),
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
