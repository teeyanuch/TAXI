import 'dart:convert';
import 'dart:math';
import 'package:TAXI/model/position_model.dart';
import 'package:TAXI/screens/utility/my_constant.dart';
import 'package:TAXI/screens/utility/my_style.dart';
import 'package:TAXI/screens/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MianAddLocation extends StatefulWidget {
  @override
  _MianAddLocationState createState() => _MianAddLocationState();
}

class _MianAddLocationState extends State<MianAddLocation> {
  String nameUser;
  double lat, lng;
  List<String> typeMarkers;
  String typeMarker;
  final formKey = GlobalKey<FormState>();
  TextEditingController namePlateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    typeMarkers = MyConstant.typeMarkers;

    findUser();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    Position position = await findPosition();
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
      print('### lat = $lat, lng = $lng');
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
        title: Text('เพิ่มพิกัดรถรับจ้าง'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  buildName(),
                  buildTypeMarker(),
                  buildMap(),
                  buildAddButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
  }

  Widget buildAddButton() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 15),
                color: Colors.deepOrange[100],
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    if (typeMarker == null) {
                      normalDialog(context, 'โปรดเลือกเลือกชนิดของพิกัด');
                    } else {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      String idRecord = preferences.getString('id');

                      String apiCheckLocation =
                          '${MyConstant.domain}/findtaxi/getPositionWhereidRecord.php?isAdd=true&idRecord=$idRecord';
                      await Dio().get(apiCheckLocation).then((value) {
                        if (value.toString() == 'null') {
                          processAddLocation(idRecord);
                        } else {
                          bool statusDisKm =
                              true; //true => สามารถ Add Location ได้
                          for (var item in json.decode(value.data)) {
                            PositionModel model = PositionModel.fromMap(item);
                            double disKm = calculateDistance(
                              lat,
                              lng,
                              double.parse(model.lat),
                              double.parse(model.lng),
                            );
                            if ((disKm <= 0.2) && (typeMarker == model.type)) {
                              statusDisKm = false;
                            }
                          }

                          if (statusDisKm) {
                            processAddLocation(idRecord);
                          } else {
                            normalDialog(
                                context, 'สถานที่นี้ คุณได้เพิ่มพิกัดไปแล้ว');
                          }
                        }
                      });
                    } // end if
                  }
                },
                child: Text(
                  'เพิ่มพิกัด',
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),
            ),
          ),
        ],
      );

  Future<Null> processAddLocation(String idRecord) async {
    // สิ่งที่ต้องทำถ้าไม่อยู่ที่เดิม
    String apiInsertLocation =
        '${MyConstant.domain}/findtaxi/addPosition.php?isAdd=true&idRecord=$idRecord&name=${namePlateController.text}&type=$typeMarker&lat=$lat&lng=$lng';

    await Dio().get(apiInsertLocation).then((value) async {
      if (value.toString() == 'true') {
        String apiReadAllPosition =
            '${MyConstant.domain}/findtaxi/getAllPosition.php';
        // print('###########################################');
        // print('####### api = $apiReadAllPosition');
        // print('###########################################');
        await Dio().get(apiReadAllPosition).then((value) {
          int loopTime = 0;
          for (var item in json.decode(value.data)) {
            PositionModel positionModel = PositionModel.fromMap(item);
            double disKm = calculateDistance(
              lat,
              lng,
              double.parse(positionModel.lat),
              double.parse(positionModel.lng),
            );
            print('#### disKm ===>>> $disKm');
            if (disKm <= 0.2) {
              loopTime++;
            }
          }
          // print('###########################################');
          // print('loopTime = $loopTime');
          // print('###########################################');

          if (loopTime < 5) {
            waitAcceptDialog(loopTime);
          } else {
            acceptDialog(namePlateController.text, typeMarker);
          }
        });
      } else {
        normalDialog(context, 'ไม่สามารถอัพเดตพิกัดได้');
      }
    });
  }

  Future<Null> waitAcceptDialog(int loopTime) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ขอบคุณที่เพิ่มพิกัดค่ะ'),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<Null> acceptDialog(String name, String type) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('พิกัดของคุณถูกยอมรับแล้ว'),
        actions: [
          FlatButton(
            onPressed: () async {
              String apiAddAccept =
                  '${MyConstant.domain}/findtaxi/addAccept.php?isAdd=true&name=$name&lat=$lat&lng=$lng&type=$type';
              await Dio().get(apiAddAccept).then(
                (value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Container buildMap() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 16,
      ),
      width: 350,
      height: 350,
      child: lat == null
          ? MyStyle().showProgress()
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, lng),
                zoom: 17,
              ),
              onMapCreated: (controller) {},
              myLocationEnabled: true,
            ),
    );
  }

  DropdownButton<String> buildTypeMarker() {
    return DropdownButton<String>(
      value: typeMarker,
      items: typeMarkers
          .map(
            (e) => DropdownMenuItem(
              child: Text(e),
              value: e,
            ),
          )
          .toList(),
      hint: Text(
        'โปรดเลือกชนิดของพิกัด',
        style: TextStyle(color: Colors.deepOrange[300]),
      ),
      onChanged: (value) {
        setState(() {
          typeMarker = value;
        });
      },
      style: const TextStyle(
        color: Colors.deepOrange,
      ),
    );
  }

  Container buildName() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: 250,
      child: TextFormField(
        controller: namePlateController,
        validator: (value) {
          if (value.isEmpty) {
            return 'กรุณากรอกชื่อสถานที่';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          prefixIcon:
              Icon(Icons.account_balance, color: Colors.deepOrange[300]),
          labelStyle: TextStyle(color: Colors.deepOrange[300]),
          labelText: 'ชื่อสถานที่: ',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange[300]),
            borderRadius: BorderRadius.circular(29),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange[300]),
            borderRadius: BorderRadius.circular(29),
          ),
        ),
      ),
    );
  }

  // Drawer drawerMenu() {
  //   return Drawer(
  //     child: Column(
  //       mainAxisSize: MainAxisSize.max,
  //       children: [
  //         UserAccountsDrawerHeader(
  //           currentAccountPicture: MyStyle().showLogo1(),
  //           accountName: Text(
  //             '$nameUser',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           accountEmail: Text(
  //             'Login',
  //             style: TextStyle(color: Colors.white70),
  //           ),
  //         ),
  //         ListTile(
  //           leading: IconButton(
  //             icon: Icon(
  //               Icons.motorcycle,
  //               size: 30.0,
  //             ),
  //             onPressed: () {
  //               MaterialPageRoute route =
  //                   MaterialPageRoute(builder: (value) => Find());
  //               Navigator.push(context, route);
  //             },
  //           ),
  //           title: Text(
  //             'หาพิกัดวินมอเตอร์ไซต์',
  //             style: TextStyle(fontSize: 16),
  //           ),
  //           onTap: () {
  //             MaterialPageRoute route =
  //                 MaterialPageRoute(builder: (value) => Find());
  //             Navigator.push(context, route);
  //           },
  //           selected: true,
  //         ),
  //         ListTile(
  //           leading: IconButton(
  //             icon: Icon(Icons.add_location, size: 30.0),
  //             onPressed: () {
  //               MaterialPageRoute route =
  //                   MaterialPageRoute(builder: (value) => MianAddLocation());
  //               Navigator.push(context, route);
  //             },
  //           ),
  //           title: Text(
  //             'เพิ่มพิกัดวินมอเตอร์ไซต์',
  //             style: TextStyle(fontSize: 16),
  //           ),
  //           onTap: () {
  //             MaterialPageRoute route =
  //                 MaterialPageRoute(builder: (value) => MianAddLocation());
  //             Navigator.push(context, route);
  //           },
  //           selected: true,
  //         ),
  //         Divider(),
  //         Expanded(
  //           child: Align(
  //             alignment: Alignment.bottomCenter,
  //             child: ListTile(
  //               leading: IconButton(
  //                 icon: Icon(
  //                   Icons.exit_to_app,
  //                   size: 30.0,
  //                 ),
  //                 onPressed: () => signOutProcess(context),
  //               ),
  //               title: Text(
  //                 'ออกจากระบบ',
  //                 style: TextStyle(fontSize: 16),
  //               ),
  //               onTap: () => signOutProcess(context),
  //               selected: true,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
