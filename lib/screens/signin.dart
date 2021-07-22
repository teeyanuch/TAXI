import 'dart:convert';

import 'package:TAXI/model/user_model.dart';
import 'package:TAXI/screens/main_find.dart';
import 'package:TAXI/screens/utility/my_constant.dart';
import 'package:TAXI/screens/utility/my_style.dart';
import 'package:TAXI/screens/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String user, password;
  bool statusRedEye = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เข้าสู่ระบบ'),
      ),
      body: Container(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(
            FocusNode(),
          ),
          behavior: HitTestBehavior.opaque,
          child: Center(
              child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyStyle().showLogo(),
                MyStyle().mySizebox(),
                MyStyle().showTitle1('Taxi Travel'),
                MyStyle().mySizebox(),
                userForm(),
                MyStyle().mySizebox(),
                passForm(),
                MyStyle().mySizebox(),
                loginButton(),
                MyStyle().mySizebox(),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget loginButton() => Container(
        width: 250.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(29),
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 17),
            color: Colors.deepOrange[100],
            onPressed: () {
              if (user == null ||
                  user.isEmpty ||
                  password == null ||
                  password.isEmpty) {
                normalDialog(context, 'กรุณากรอกให้ครบทุกช่องค่ะ !!');
              } else {
                checkAuthen();
              }
            },
            child: Text(
              'เข้าสู่ระบบ',
              style: TextStyle(color: Colors.deepOrange),
            ),
          ),
        ),
      );

  Future<Null> checkAuthen() async {
    String url =
        '${MyConstant.domain}/findtaxi/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      print('res = $response');

      if (response.toString() == 'null') {
        normalDialog(context, 'ไม่มี $user นี้');
      } else {
        var result = json.decode(response.data);
      print('result = $result');
      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password) {
          routeTuService(userModel);
        } else {
          normalDialog(context, 'Password ผิด กรุณาลองใหม่');
        }
      }
      }
    } catch (e) {}
  }

  Future<Null> routeTuService(UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', userModel.id);
    preferences.setString('Name', userModel.name);

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => MainFind(),
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget userForm() => Container(
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
              borderSide: BorderSide(color: Colors.deepOrange),
              borderRadius: BorderRadius.circular(29),
            ),
          ),
        ),
      );

  Widget passForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: statusRedEye,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(Icons.remove_red_eye, color: Colors.deepOrange[300]),
                onPressed: () {
                  setState(() {
                    statusRedEye = !statusRedEye;
                  });
                }),
            prefixIcon: Icon(Icons.lock, color: Colors.deepOrange[300]),
            labelStyle: TextStyle(color: Colors.deepOrange[300]),
            labelText: 'password : ',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrange[300]),
              borderRadius: BorderRadius.circular(29),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrange),
              borderRadius: BorderRadius.circular(29),
            ),
          ),
        ),
      );
}
