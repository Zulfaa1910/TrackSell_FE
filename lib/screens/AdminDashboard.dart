import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  final _pages = [
    AdminManagementPage(),
    SalesMonitoringPage(),
    PerformanceAnalysisPage(),
    NotificationReminderPage(),
    ReportDocumentationPage(),
    SalesVerificationPage(),
  ];

  void _onDrawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // Close the drawer
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Add notification logic
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.redAccent[400], // Eye-catching color
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/logo.png'), // Replace with your logo
                    radius: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Admin Dashboard',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Manajemen Pre-Reseller'),
              leading: Icon(Icons.people),
              onTap: () => _onDrawerItemTapped(0),
            ),
            ListTile(
              title: Text('Monitoring Lokasi Sales'),
              leading: Icon(Icons.location_on),
              onTap: () => _onDrawerItemTapped(1),
            ),
            ListTile(
              title: Text('Analisis Kinerja'),
              leading: Icon(Icons.assessment),
              onTap: () => _onDrawerItemTapped(2),
            ),
            ListTile(
              title: Text('Notifikasi dan Pengingat'),
              leading: Icon(Icons.notifications),
              onTap: () => _onDrawerItemTapped(3),
            ),
            ListTile(
              title: Text('Laporan dan Dokumentasi'),
              leading: Icon(Icons.insert_drive_file),
              onTap: () => _onDrawerItemTapped(4),
            ),
            ListTile(
              title: Text('Verifikasi Penjualan'),
              leading: Icon(Icons.verified_user),
              onTap: () => _onDrawerItemTapped(5),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent[400], // Highlight color
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

// Example Pages (You need to create these pages accordingly)

class AdminManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Manajemen Pre-Reseller Content'));
  }
}

class SalesMonitoringPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Monitoring Lokasi Sales Content'));
  }
}

class PerformanceAnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Analisis Kinerja Content'));
  }
}

class NotificationReminderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Notifikasi dan Pengingat Content'));
  }
}

class ReportDocumentationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Laporan dan Dokumentasi Content'));
  }
}

class SalesVerificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Verifikasi Penjualan Content'));
  }
}
