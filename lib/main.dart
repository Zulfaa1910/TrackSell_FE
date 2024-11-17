import 'package:flutter/material.dart';
import 'SplashScreen.dart';
import 'auth/LoginPage.dart';
import 'auth/RegisterPage.dart';
import 'auth/forgot_password_page.dart';
import 'auth/VerifyPhonePage.dart'; // Import VerifyPage
import 'SalesDashboard.dart';
import 'screens/dashboard_visit_page.dart';
import 'screens/location_collection_page.dart';
import 'screens/reseller_page.dart';
import 'screens/location_history_page.dart';
import 'screens/history_page.dart'; // Import HistoryPage
import 'screens/messages_page.dart'; // Import MessagesPage
import 'screens/profile_page.dart'; // Import ProfilePage
import 'screens/notification_page.dart'; // Import NotificationPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackSell',
      theme: ThemeData(
        primarySwatch: Colors.red, // Sesuaikan dengan warna tema Anda
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/forgot-password': (context) => ForgotPasswordPage(),
        '/verify': (context) => VerifyPhonePage(), // Tambahkan rute untuk VerifyPage
        '/sales-dashboard': (context) => SalesDashboard(),
        '/dashboard-visit': (context) => DashboardVisitPage(),
        '/location-collection': (context) => LocationCollectionPage(),
        '/reseller': (context) => ResellerPage(),
        '/location-history': (context) => LocationHistoryPage(),
        '/history': (context) => HistoryPage(), // Rute untuk HistoryPage
        '/messages': (context) => MessagesPage(), // Rute untuk MessagesPage
        '/profile': (context) => ProfilePage(), // Rute untuk ProfilePage
        '/notifications': (context) => NotificationPage(), // Rute untuk NotificationPage
        // '/edit-profile': (context) => EditProfilePage(), // Rute untuk EditProfilePage
      },
    );
  }
}
