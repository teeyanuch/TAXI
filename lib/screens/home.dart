import 'package:TAXI/screens/main_find.dart';
import 'package:TAXI/screens/sighup.dart';
import 'package:TAXI/screens/signin.dart';
import 'package:TAXI/screens/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    checkPreferance();
  }

  Future<Null> checkPreferance() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String id = preferences.getString('id');
      if (id != null && id.isNotEmpty) {
        routeToService();
      } else {}
    } catch (e) {}
  }

  void routeToService() {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => MainFind(),
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: showDrawer(),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyStyle().showLogo(),
              MyStyle().mySizebox(),
              MyStyle().showTitle1('Taxi Travel'),
              MyStyle().mySizebox(),
              sighInButton(),
              MyStyle().mySizebox(),
              sighUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget sighInButton() => Container(
        width: 250.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(29),
          child: RaisedButton(
            padding: EdgeInsets.symmetric(
              vertical: 15,
            ),
            color: Colors.deepOrange[300],
            onPressed: () {
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (value) => SignIn());
              Navigator.push(context, route);
            },
            child: Text(
              'เข้าสู่ระบบ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );

  Widget sighUpButton() => Container(
        width: 250.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(29),
          child: RaisedButton(
            padding: EdgeInsets.symmetric(
              vertical: 15,
            ),
            color: Colors.deepOrange[100],
            onPressed: () {
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (value) => SignUp());
              Navigator.push(context, route);
            },
            child: Text(
              'สมัครสมาชิก',
              style: TextStyle(color: Colors.deepOrange),
            ),
          ),
        ),
      );

  // Drawer showDrawer() => Drawer(
  //       child: ListView(
  //         children: [
  //           showHeadDrawer(),
  //           addLocation(),
  //           signUp(),
  //         ],
  //       ),
  //     );

  // ListTile addLocation() {
  //   return ListTile(
  //     leading: Icon(Icons.add_location),
  //     title: Text('เพิ่มพิกัดวินมอเตอร์ไซต์'),
  //   );
  // }

  // ListTile signUp() {
  //   return ListTile(
  //     leading: Icon(Icons.exit_to_app),
  //     title: Text('ออกจากระบบ'),
  //   );
  // }

  // UserAccountsDrawerHeader showHeadDrawer() {
  //   return UserAccountsDrawerHeader(
  //     accountName: Text('Guest'),
  //     accountEmail: Text('Please Login'),
  //   );
  // }
}
