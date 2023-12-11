// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         primarySwatch: Colors.blue,
//       ),
//       home: Homepage(),
//     );
//   }
// }
//
// class Homepage extends StatefulWidget {
//   const Homepage({Key? key}) : super(key: key);
//
//   @override
//   _HomepageState createState() => _HomepageState();
// }
//
// class _HomepageState extends State<Homepage> {
//
//   String location ='Null, Press Button';
//   String Address = 'search';
//
//   Future<Position> _getGeoLocationPosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       await Geolocator.openLocationSettings();
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   }
//
//   Future<void> GetAddressFromLatLong(Position position)async {
//     List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//     print(placemarks);
//     Placemark place = placemarks[0];
//     Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
//     setState(()  {
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Coordinates Points',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
//             SizedBox(height: 10,),
//             Text(location,style: TextStyle(color: Colors.black,fontSize: 16),),
//             SizedBox(height: 10,),
//             Text('ADDRESS',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
//             SizedBox(height: 10,),
//             Text('${Address}'),
//             ElevatedButton(onPressed: () async{
//               Position position = await _getGeoLocationPosition();
//               location ='Lat: ${position.latitude} , Long: ${position.longitude}';
//               GetAddressFromLatLong(position);
//             }, child: Text('Get Location'))
//           ],
//         ),
//       ),
//     );
//   }
// }












import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String location = 'Null, Press Button';
  String address = 'search';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied.';
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _updateLocationAndAddress() async {
    try {
      Position position = await _getGeoLocationPosition();
      setState(() {
        location = 'Lat: ${position.latitude}, Long: ${position.longitude}';
      });

      await _getAddressFromLatLong(position);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      setState(() {
        address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Coordinates Points',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              location,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'ADDRESS',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('${address}'),
            ElevatedButton(
              onPressed: _updateLocationAndAddress,
              child: Text('Get Location'),
            ),
          ],
        ),
      ),
    );
  }
}










//
//
// import 'dart:async';
//
// import 'dart:io';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
//
// List<CameraDescription>? cameras;
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   CameraController? controller;
//   String imagePath = "";
//   late DateTime currentTime;
//   Position? _currentPosition;
//   String _currentAddress = "Fetching Address...";
//   GoogleMapController? _googleMapController;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = CameraController(cameras![0], ResolutionPreset.max);
//     controller?.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//     // Initialize currentTime
//     currentTime = DateTime.now();
//
//     // Update currentTime every second
//     Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         currentTime = DateTime.now();
//       });
//     });
//
//     // Request location permission
//     _requestLocationPermission();
//   }
//
//   Future<void> _requestLocationPermission() async {
//     if (!(await Geolocator.isLocationServiceEnabled())) {
//       await Geolocator.openLocationSettings();
//     }
//
//     PermissionStatus permission = await Geolocator.checkPermission();
//     if (permission == PermissionStatus.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission != PermissionStatus.granted) {
//         // Handle if the user denies location permission
//         return;
//       }
//     }
//   }
//
//   Future<void> _getCurrentAddress() async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         _currentPosition!.latitude,
//         _currentPosition!.longitude,
//       );
//
//       if (placemarks.isNotEmpty) {
//         Placemark placemark = placemarks[0];
//         setState(() {
//           _currentAddress =
//           "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}";
//         });
//       }
//     } catch (e) {
//       print("Error getting address: $e");
//     }
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!controller!.value.isInitialized) {
//       return Container();
//     }
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 20,
//               ),
//               // Display current date and time
//               DateTimeDisplay(currentTime: currentTime),
//               Container(
//                 width: 200,
//                 height: 200,
//                 child: ClipOval(
//                   child: AspectRatio(
//                     aspectRatio: controller!.value.aspectRatio,
//                     child: CameraPreview(controller!),
//                   ),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   try {
//                     final image = await controller!.takePicture();
//                     setState(() {
//                       imagePath = image.path;
//                     });
//
//                     // Get the current location
//                     _currentPosition = await Geolocator.getCurrentPosition(
//                       desiredAccuracy: LocationAccuracy.high,
//                     );
//                     _getCurrentAddress();
//
//                     // Move the map camera to the user's location
//                     GoogleMapController mapController =
//                     await _googleMapController!.future;
//                     mapController.animateCamera(
//                       CameraUpdate.newLatLng(
//                         LatLng(
//                           _currentPosition!.latitude,
//                           _currentPosition!.longitude,
//                         ),
//                       ),
//                     );
//                   } catch (e) {
//                     print(e);
//                   }
//                 },
//                 child: Container(
//                   child: Text(
//                     "CLICK HERE TO PUNCH",
//                     style: TextStyle(color: Colors.red, backgroundColor: Colors.cyan),
//                   ),
//                 ),
//               ),
//               Container(
//                 height: 300,
//                 child: GoogleMap(
//                   initialCameraPosition: CameraPosition(
//                     target: LatLng(37.7749, -122.4194), // Initial map position
//                     zoom: 12.0, // Initial zoom level
//                   ),
//                   onMapCreated: (GoogleMapController controller) {
//                     _googleMapController = controller;
//                   },
//                 ),
//               ),
//               Text(
//                 'Address:',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 '$_currentAddress',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class DateTimeDisplay extends StatelessWidget {
//   final DateTime currentTime;
//
//   const DateTimeDisplay({Key? key, required this.currentTime}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final formattedDate = DateFormat('dd-MMM-yyyy').format(currentTime);
//     final formattedTime = DateFormat('HH:mm:ss').format(currentTime);
//
//     return Column(
//       children: [
//         Text(
//           'Date:',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           '$formattedDate',
//           style: TextStyle(fontSize: 16),
//         ),
//         SizedBox(height: 10),
//         Text(
//           'Time:',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           '$formattedTime',
//           style: TextStyle(fontSize: 16),
//         ),
//         SizedBox(height: 20),
//       ],
//     );
//   }
// }
