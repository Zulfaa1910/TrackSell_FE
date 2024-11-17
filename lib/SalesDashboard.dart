import 'package:flutter/material.dart';
import 'screens/dashboard_visit_page.dart';
import 'screens/location_collection_page.dart';
import 'screens/reseller_page.dart';
import 'screens/location_history_page.dart';
import 'screens/profile_page.dart'; // Import halaman Profile

class SalesDashboard extends StatefulWidget {
  @override
  _SalesDashboardState createState() => _SalesDashboardState();
}

class _SalesDashboardState extends State<SalesDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardVisitPage(),
    ResellerPage(),
    LocationCollectionPage(),
    LocationHistoryPage(),
    ProfilePage(), // Update to use ProfilePage
  ];

  void _onPageSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onPageSelected,
        selectedItemColor: Colors.redAccent[400],
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Reseller',
          ),
          BottomNavigationBarItem(
            icon: Icon(null), // Kosong untuk posisi tengah
            label: '', // Tidak ada label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onPageSelected(2); // Mengarahkan ke halaman "Visit"
        },
        backgroundColor: Colors.redAccent[400], // Warna merah
        child: Icon(Icons.location_on), // Ikon "Visit"
      ),
    );
    
  }
}
