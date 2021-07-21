import 'package:TAXI/screens/find.dart';
import 'package:TAXI/screens/utility/my_style.dart';
import 'package:TAXI/screens/utility/signout_process.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MianAddLocation extends StatefulWidget {

  
  @override
  _MianAddLocationState createState() => _MianAddLocationState();
}

class _MianAddLocationState extends State<MianAddLocation> {
  String nameUser;

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
      appBar: AppBar(
         title: Text('เพิ่มพิกัดวินมอเตอร์ไซค์'),
      ),
      drawer: drawerMenu(),
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

}


