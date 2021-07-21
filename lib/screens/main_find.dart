import 'package:TAXI/screens/find.dart';
import 'package:TAXI/screens/main_addlo.dart';
import 'package:TAXI/screens/time.dart';
import 'package:TAXI/screens/utility/my_style.dart';
import 'package:TAXI/screens/utility/signout_process.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainFind extends StatefulWidget {
  @override
  _MainFindState createState() => _MainFindState();
}

class _MainFindState extends State<MainFind> {
  String nameUser;
  // final today = DateTime.now();

  @override
  void initState() {
    super.initState();
    findUser();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main FIND TAXI' : 'Welcome $nameUser'),
      ),
      drawer: drawerMenu(),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 150.0, horizontal: 10.0),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Timimg(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  getExpanded('Logo8', 'หาพิกัด', 'วินมอเตอร์ไซต์'),
                  getExpanded1('Logo5', 'เพิ่มพิกัด', 'วินมอเตอร์ไซต์'),
                ],
              ),
            ),
          ],
        ),
      ),
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
                Icons.motorcycle, size: 30.0,
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

  Expanded getExpanded(String images, String text, String subtext) {
    return Expanded(
      child: FlatButton(
        padding: EdgeInsets.all(0),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/$images.png',
                  height: 120,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  text,
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  subtext,
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0),
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
          margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.deepOrange[100],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(),
            ],
          ),
        ),
        onPressed: () {
          MaterialPageRoute route =
              MaterialPageRoute(builder: (value) => Find());
          Navigator.push(context, route);
        },
      ),
    );
  }

  Expanded getExpanded1(String images, String text, String subtext) {
    return Expanded(
      child: FlatButton(
        padding: EdgeInsets.all(0),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/$images.png',
                  height: 120,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  text,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  subtext,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0),
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
          margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.deepOrange[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(),
            ],
          ),
        ),
        onPressed: () {
          MaterialPageRoute route =
              MaterialPageRoute(builder: (value) => MianAddLocation());
          Navigator.push(context, route);
        },
      ),
    );
  }
}
