import 'dart:convert';
import 'package:TAXI/model/accept_model.dart';
import 'package:TAXI/model/position_model.dart';
import 'package:TAXI/screens/main_addlo.dart';
import 'package:TAXI/screens/time.dart';
import 'package:TAXI/screens/utility/my_constant.dart';
import 'package:TAXI/screens/utility/my_style.dart';
import 'package:TAXI/screens/utility/normal_dialog.dart';
import 'package:TAXI/screens/utility/signout_process.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Find extends StatefulWidget {
  @override
  _FindState createState() => _FindState();
}

class _FindState extends State<Find> {
  String nameUser;
  double lat, lng;
  List<AcceptModel> acceptModels = [];
  Map<MarkerId, Marker> mapMarkers = Map();

  void routeToAddlo() {
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => MianAddLocation(),
    );
    Navigator.push(context, materialPageRoute).then(
      (value) => readAllPosition(),
    );
  }

  @override
  void initState() {
    super.initState();
    findUser();
    checkPremission();
    readAllPosition();
  }

  void createAllMarker(LatLng latLng, String idMarker,
      BitmapDescriptor bitmapDescriptor, String title) {
    MarkerId markerId = MarkerId(idMarker);
    Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      icon: bitmapDescriptor,
      infoWindow: InfoWindow(title: title),
    );
    mapMarkers[markerId] = marker;
  }

  BitmapDescriptor findColorMarker(String string) {
    List<String> typeTitles = MyConstant.typeMarkers;
    List<BitmapDescriptor> descriptors = [
      BitmapDescriptor.defaultMarkerWithHue(30),
      BitmapDescriptor.defaultMarkerWithHue(240),
      BitmapDescriptor.defaultMarkerWithHue(120),
      BitmapDescriptor.defaultMarkerWithHue(10),
    ];

    if (string == typeTitles[0]) {
      return descriptors[0];
    } else if (string == typeTitles[1]) {
      return descriptors[1];
    } else if (string == typeTitles[2]) {
      return descriptors[2];
    } else {
      return descriptors[3];
    }
  }

  Future<Null> readAllPosition() async {
    String apiReadAllPosition =
        '${MyConstant.domain}/findtaxi/getAllAccept.php';
    await Dio().get(apiReadAllPosition).then(
      (value) {
        // print('## value ==>> $value');
        int i = 0;
        for (var item in json.decode(value.data)) {
          AcceptModel model = AcceptModel.fromMap(item);
          setState(() {
            acceptModels.add(model);
            createAllMarker(
                LatLng(
                  double.parse(model.lat),
                  double.parse(model.lng),
                ),
                'idMarker$i',
                findColorMarker(model.type),
                model.name);
          });
          i++;
        }
      },
    );
  }

  Future<Null> checkPremission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location Open');
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
            context,
            'ไม่ได้เปิด GPS',
            'กรุณาเปิด GPS เพื่อเข้าใช้งาน',
          );
        } else {
          // Find LatLng
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
            context,
            'ไม่ได้เปิด GPS',
            'กรุณาเปิด GPS เพื่อเข้าใช้งาน',
          );
        } else {
          // Find LatLng
          findLatLng();
        }
      }
    } else {
      print('Service Location Close');
      MyDialog().alertLocationService(
        context,
        'กรุณาเปิด GPS ค่ะ',
        'GPS ปิดอยู่ กรุณาเปิด เพื่อเข้าใช้งาน',
      );
    }
  }

  Future<Null> findLatLng() async {
    print('findLatLng ==> work');
    Position position = await findPosition();
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
      print('lat = $lat, lng = $lng');
    });
  }

  Future<Position> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หาพิกัดวินมอเตอร์ไซค์'),
      ),
      drawer: drawerMenu(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 25.0,
            left: 25.0,
            right: 25,
          ),
          child: Column(
            children: [
              Timimg(),
              SizedBox(
                height: 20.0,
              ),
              buildMap(),
              // showMap(),
              // lat == null ? MyStyle().showProgress() : showMap(),
              SizedBox(
                height: 20.0,
              ),
              type1(),
              MyStyle().mySizebox(),
              type3(),
              MyStyle().mySizebox(),
              addLocation(),
            ],
          ),
        ),
      ),
    );
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
              title: 'คุณอยู่ที่นี่', snippet: 'Lat = $lat, Lng = $lng'),
        ),
      ].toSet();

  Widget buildMap() => Container(
        width: double.infinity,
        height: 350,
        child: lat == null
            ? MyStyle().showProgress()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, lng),
                  zoom: 14,
                ),
                onMapCreated: (controller) {},
                myLocationEnabled: true,
                markers: Set<Marker>.of(mapMarkers.values),
              ),
      );

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('taxiMarker'),
        position: LatLng(18.60198944183668, 99.02076967163445),
        infoWindow: InfoWindow(title: 'วินมอเตอร์ไซค์ ศรีสองเมือง'),
        icon: BitmapDescriptor.defaultMarkerWithHue(30),
      ),
      Marker(
        markerId: MarkerId('taxiMarker'),
        position: LatLng(18.582807182576822, 99.00672417246128),
        infoWindow: InfoWindow(title: 'วินมอเตอร์ไซค์ ในเมือง'),
        icon: BitmapDescriptor.defaultMarkerWithHue(30),
      ),
      Marker(
        markerId: MarkerId('taxiMarker'),
        position: LatLng(18.59452201860414, 99.04792290226156),
        infoWindow: InfoWindow(title: 'วินมอเตอร์ไซค์ ตลาดสันป่าฝ้าย'),
        icon: BitmapDescriptor.defaultMarkerWithHue(30),
      ),
      Marker(
        markerId: MarkerId('taxiMarker'),
        position: LatLng(18.59142048148731, 99.04717187874293),
        infoWindow: InfoWindow(title: 'ร้านเช่ารถ'),
        icon: BitmapDescriptor.defaultMarkerWithHue(240),
      ),
      Marker(
        markerId: MarkerId('taxiMarker'),
        position: LatLng(18.592894974885816, 99.05183892251534),
        infoWindow: InfoWindow(title: 'รถแท็กซี่'),
        icon: BitmapDescriptor.defaultMarkerWithHue(120),
      ),
      Marker(
        markerId: MarkerId('taxiMarker'),
        position: LatLng(18.59374915832566, 99.04380302415778),
        infoWindow: InfoWindow(title: 'รถสองแถว'),
        icon: BitmapDescriptor.defaultMarkerWithHue(10),
      ),
    ].toSet();
  }

  // Container showMap() {
  //   LatLng latLng = LatLng(18.60198944183668, 99.02076967163445);
  //   CameraPosition cameraPosition = CameraPosition(
  //     target: latLng,
  //     zoom: 14.0,
  //   );

  //   return Container(
  //     height: 350.0,
  //     child: GoogleMap(
  //       initialCameraPosition: cameraPosition,
  //       mapType: MapType.normal,
  //       onMapCreated: (controller) {},
  //       markers: myMarker(),
  //     ),
  //   );
  // }

  Widget type1() {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 25,
          color: Colors.orange,
        ),
        Text(
          'มอเตอร์ไซค์วิน',
          style: TextStyle(color: Colors.deepOrange[300]),
        ),
        SizedBox(
          width: 25,
        ),
        Icon(
          Icons.location_on,
          size: 25,
          color: Colors.blue,
        ),
        Text(
          'ร้านเช่ารถ',
          style: TextStyle(color: Colors.deepOrange[300]),
        ),
      ],
    );
  }

  Widget type3() {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 25,
          color: Colors.green,
        ),
        Text(
          'รถแท็กซี่',
          style: TextStyle(color: Colors.deepOrange[300]),
        ),
        SizedBox(
          width: 25,
        ),
        Icon(
          Icons.location_on,
          size: 25,
          color: Colors.red,
        ),
        Text(
          'รถสองแถว',
          style: TextStyle(color: Colors.deepOrange[300]),
        ),
      ],
    );
  }

  Row addLocation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: FloatingActionButton(
                  child: Icon(
                    Icons.add_location,
                    size: 30,
                  ),
                  backgroundColor: Colors.deepOrange[300],
                  onPressed: () {
                    routeToAddlo();
                  }),
            ),
          ],
        ),
      ],
    );
  }

  Drawer drawerMenu() {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: MyStyle().showLogo1(),
            accountName: Text(
              '$nameUser',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              'Login',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ListTile(
            leading: IconButton(
              icon: Icon(
                Icons.motorcycle,
                size: 30.0,
              ),
              onPressed: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (value) => Find());
                Navigator.push(context, route);
              },
            ),
            title: Text(
              'หาพิกัดวินมอเตอร์ไซต์',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (value) => Find());
              Navigator.push(context, route);
            },
            selected: true,
          ),
          ListTile(
            leading: IconButton(
              icon: Icon(Icons.add_location, size: 30.0),
              onPressed: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (value) => MianAddLocation());
                Navigator.push(context, route);
              },
            ),
            title: Text(
              'เพิ่มพิกัดวินมอเตอร์ไซต์',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (value) => MianAddLocation());
              Navigator.push(context, route);
            },
            selected: true,
          ),
          Divider(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 30.0,
                  ),
                  onPressed: () => signOutProcess(context),
                ),
                title: Text(
                  'ออกจากระบบ',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () => signOutProcess(context),
                selected: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
