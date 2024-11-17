import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationCollectionPage extends StatefulWidget {
  @override
  _LocationCollectionPageState createState() => _LocationCollectionPageState();
}

class _LocationCollectionPageState extends State<LocationCollectionPage> {
  GoogleMapController? _mapController;
  LatLng _currentLocation = LatLng(-6.200000, 106.816666); // Default Jakarta location
  Set<Marker> _markers = {}; // Markers for locations
  int? _currentResellerIndex; // Index reseller yang sedang dikunjungi
  bool _visited = false; // Status kunjungan

  // Daftar lokasi reseller (contoh)
  List<LatLng> _resellerLocations = [
    LatLng(-6.215, 106.845), // Reseller A
    LatLng(-6.201, 106.823), // Reseller B
    LatLng(-6.195, 106.829), // Reseller C
  ];

  // Daftar nama reseller
  List<String> _resellerNames = [
    'Reseller A',
    'Reseller B',
    'Reseller C',
  ];

  @override
  void initState() {
    super.initState();
    _setInitialLocation(); // Get initial location on load
  }

  // Function to get the user's current location and set the map camera
  Future<void> _setInitialLocation() async {
    Position position = await _getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _markers.add(Marker(markerId: MarkerId('currentLocation'), position: _currentLocation));
      _addResellerMarkers();
    });
  }

  // Function to get the current location of the user
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Function to add markers for resellers
  void _addResellerMarkers() {
    _resellerLocations.asMap().forEach((index, location) {
      _markers.add(Marker(
        markerId: MarkerId('reseller$index'),
        position: location,
        infoWindow: InfoWindow(
          title: _resellerNames[index],
        ),
      ));
    });
  }

  // Function to navigate to a reseller location
  void _navigateToLocation(LatLng location, int index) async {
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}&travelmode=driving';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
      setState(() {
        _currentResellerIndex = index; // Simpan index reseller yang sedang dikunjungi
        _visited = false; // Reset status kunjungan
      });
    } else {
      throw 'Could not launch $googleUrl';
    }
  }

  // Function to check if user has arrived at the location
  Future<void> _checkArrival() async {
    Position position = await _getCurrentPosition();
    LatLng currentPosition = LatLng(position.latitude, position.longitude);
    
    // Cek apakah posisi pengguna mendekati lokasi reseller
    if (_currentResellerIndex != null) {
      double distanceInMeters = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        _resellerLocations[_currentResellerIndex!].latitude,
        _resellerLocations[_currentResellerIndex!].longitude,
      );
      
      // Misal jarak untuk dianggap sudah sampai adalah 50 meter
      if (distanceInMeters < 50) {
        setState(() {
          _visited = true; // Tandai sudah dikunjungi
        });
      }
    }
  }

  // Function to handle map creation
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: _currentLocation, zoom: 14),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tracking Reseller'),
        backgroundColor: Colors.redAccent[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display map
            Container(
              height: 400, // Map height
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _currentLocation,
                  zoom: 14,
                ),
                markers: _markers,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Pilih Reseller untuk Dikunjungi:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Daftar reseller
            Expanded(
              child: ListView.builder(
                itemCount: _resellerNames.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(_resellerNames[index]),
                      trailing: Icon(Icons.navigation),
                      onTap: () {
                        _navigateToLocation(_resellerLocations[index], index);
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                Position position = await _getCurrentPosition();
                setState(() {
                  _currentLocation = LatLng(position.latitude, position.longitude);
                  _mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: _currentLocation, zoom: 14),
                    ),
                  );
                  _markers.clear();
                  _markers.add(Marker(markerId: MarkerId('currentLocation'), position: _currentLocation));
                  _addResellerMarkers(); // Refresh markers
                });

                // Cek kedatangan ke lokasi reseller
                await _checkArrival();
              },
              child: Text('Update Lokasi Saya'),
            ),
            SizedBox(height: 16),
            // Tampilkan status kunjungan
            if (_visited)
              Text(
                'Selesai Dikunjungi! Kunjungi reseller selanjutnya.',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
