import 'package:flutter/material.dart';
import 'location_collection_page.dart'; // Import the LocationCollectionPage

class LocationHistoryPage extends StatelessWidget {
  final List<String> resellerNames = ['Reseller A', 'Reseller B', 'Reseller C']; // Daftar nama reseller
  final List<String> taskNames = ['Task A', 'Task B', 'Task C']; // Daftar nama task

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard Kunjungan'),
          backgroundColor: Colors.redAccent[400], // Warna AppBar
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // Height of the tab bar
            child: Column(
              children: [
                SizedBox(height: 10), // Space above the tab bar
                Container(
                  color: Colors.white, // Change tab bar color to white
                  child: TabBar(
                    isScrollable: true, // Makes the tab bar scrollable
                    indicatorColor: Colors.redAccent[400], // Tab indicator color
                    tabs: [
                      Tab(child: Align(alignment: Alignment.center, child: Text('Kunjungan'))),
                      Tab(child: Align(alignment: Alignment.center, child: Text('Task'))),
                      Tab(child: Align(alignment: Alignment.center, child: Text('Laporan'))),
                    ],
                  ),
                ),
                SizedBox(height: 10), // Space below the tab bar
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildKunjunganTab(context),
            _buildTaskTab(context),
            _buildLaporanTab(),
          ],
        ),
      ),
    );
  }

  // Method to build the Kunjungan tab content
  Widget _buildKunjunganTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Padding adjusted
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Riwayat Kunjungan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: resellerNames.length, // Jumlah reseller
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.location_on, color: Colors.redAccent),
                  title: Text(resellerNames[index]),
                  subtitle: Text('Detail kunjungan ke ${resellerNames[index]}'),
                  onTap: () {
                    // Navigasi ke LocationCollectionPage dengan lokasi reseller tertentu
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocationCollectionPage()), // Navigasi ke halaman peta
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Tambah Kunjungan Manual'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () {
              _showAddKunjunganDialog(context);
            },
          )
        ],
      ),
    );
  }

  // Method to build the Task tab content
  Widget _buildTaskTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Padding adjusted
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tugas Hari Ini',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: taskNames.length, // Jumlah task
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.task, color: Colors.redAccent),
                  title: Text(taskNames[index]),
                  subtitle: Text('Detail task untuk ${taskNames[index]}'),
                  onTap: () {
                    // Navigasi ke LocationCollectionPage dengan tugas reseller
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocationCollectionPage()), // Navigasi ke halaman peta
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method to build the Laporan tab content
  Widget _buildLaporanTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Padding adjusted
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Laporan Kegiatan Hari Ini',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text('Kunjungan Selesai: 3'),
            subtitle: Text('Reseller A, B, C'),
          ),
          ListTile(
            leading: Icon(Icons.task, color: Colors.orange),
            title: Text('Tugas Selesai: 2 dari 3'),
            subtitle: Text('Kunjungi Reseller A, B'),
          ),
          ListTile(
            leading: Icon(Icons.report, color: Colors.blue),
            title: Text('Kunjungan Manual: 1'),
            subtitle: Text('Reseller B'),
          ),
        ],
      ),
    );
  }

  // Dialog for adding manual visit
  void _showAddKunjunganDialog(BuildContext context) {
    TextEditingController _resellerController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Kunjungan Manual'),
          content: TextField(
            controller: _resellerController,
            decoration: InputDecoration(labelText: 'Nama Reseller'),
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            TextButton(
              child: Text('Simpan'),
              onPressed: () {
                // Handle saving kunjungan manually
                print('Kunjungan ke ${_resellerController.text} disimpan!');
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LocationHistoryPage(),
  ));
}
