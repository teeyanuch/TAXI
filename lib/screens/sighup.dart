import 'package:TAXI/screens/utility/my_style.dart';
import 'package:TAXI/screens/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name, user, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สมัครสมาชิก'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        behavior: HitTestBehavior.opaque,
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: [
            myLogo(),
            MyStyle().mySizebox(),
            showAppName(),
            MyStyle().mySizebox(),
            nameForm(),
            MyStyle().mySizebox(),
            userForm(),
            MyStyle().mySizebox(),
            passForm(),
            MyStyle().mySizebox(),
            registerButton(),
          ],
        ),
      ),
    );
  }

  Widget registerButton() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 17),
                color: Colors.deepOrange[100],
                onPressed: () {
                  print(
                    'name = $name, user = $user, password = $password',
                  );
                  if (name == null ||
                      name.isEmpty ||
                      user == null ||
                      user.isEmpty ||
                      password == null ||
                      password.isEmpty) {
                    print('Have Space');
                    normalDialog(context, 'กรุณากรอกให้ครบทุกช่อง !!');
                  } else {
                    checkUser();
                  }
                },
                child: Text(
                  'สมัครสมาชิก',
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),
            ),
          ),
        ],
      );

  Future<Null> checkUser() async {
    String url =
        'http://192.168.1.43/findtaxi/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        registerThread();
      } else {
        normalDialog(
            context, '$user มีผู้ใช้งานแล้ว !! กรุณาเปลี่ยน User ใหม่');
      }
    } catch (e) {}
  }

  Future<Null> registerThread() async {
    String url =
        'http://192.168.1.43/findtaxi/addUser.php?isAdd=true&Name=$name&User=$user&Password=$password';

    try {
      Response response = await Dio().get(url);
      print('res = $response');

      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ไม่สามารถสมัครสมาชิกได้ กรุณาลองใหม่');
      }
    } catch (e) {}
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => name = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.face, color: Colors.deepOrange[300]),
                labelStyle: TextStyle(color: Colors.deepOrange[300]),
                labelText: 'Name : ',
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
          ),
        ],
      );

  Widget userForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => user = value.trim(),
              decoration: InputDecoration(
                prefixIcon:
                    Icon(Icons.account_circle, color: Colors.deepOrange[300]),
                labelStyle: TextStyle(color: Colors.deepOrange[300]),
                labelText: 'User : ',
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
          ),
        ],
      );

  Widget passForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => password = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Colors.deepOrange[300]),
                labelStyle: TextStyle(color: Colors.deepOrange[300]),
                labelText: 'Password : ',
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
          ),
        ],
      );

  Row showAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyStyle().showTitle1('Taxi Travel'),
      ],
    );
  }

  Widget myLogo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyStyle().showLogo(),
        ],
      );
}
