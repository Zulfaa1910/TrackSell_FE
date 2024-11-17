// import 'package:flutter/material.dart';
// import '../model/reseller_model.dart';

// class ResellerDetailPage extends StatelessWidget {
//   final Reseller reseller;

//   ResellerDetailPage({required this.reseller});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Detail Reseller'),
//         backgroundColor: Colors.redAccent[400],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Card(
//               elevation: 4,
//               margin: EdgeInsets.only(bottom: 16),
//               child: ListTile(
//                 title: Text('Nama'),
//                 subtitle: Text(reseller.name),
//                 leading: Icon(Icons.person, color: Colors.redAccent[400]),
//               ),
//             ),
//             Card(
//               elevation: 4,
//               margin: EdgeInsets.only(bottom: 16),
//               child: ListTile(
//                 title: Text('Tanggal Lahir'),
//                 subtitle: Text('${reseller.birthdate.split('T')[0]}'), // Formatting DateTime string
//                 leading: Icon(Icons.calendar_today, color: Colors.redAccent[400]),
//               ),
//             ),
//             Card(
//               elevation: 4,
//               margin: EdgeInsets.only(bottom: 16),
//               child: ListTile(
//                 title: Text('Jenis Kelamin'),
//                 subtitle: Text(reseller.gender),
//                 leading: Icon(Icons.transgender, color: Colors.redAccent[400]),
//               ),
//             ),
//             Card(
//               elevation: 4,
//               margin: EdgeInsets.only(bottom: 16),
//               child: ListTile(
//                 title: Text('Nomor Telepon'),
//                 subtitle: Text(reseller.phone),
//                 leading: Icon(Icons.phone, color: Colors.redAccent[400]),
//               ),
//             ),
//             Card(
//               elevation: 4,
//               margin: EdgeInsets.only(bottom: 16),
//               child: ListTile(
//                 title: Text('Alamat'),
//                 subtitle: Text(reseller.address),
//                 leading: Icon(Icons.home, color: Colors.redAccent[400]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
