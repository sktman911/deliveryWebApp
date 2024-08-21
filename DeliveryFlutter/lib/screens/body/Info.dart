import 'package:delivery/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:delivery/Entities/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'dart:convert';


class Info extends StatelessWidget {
  
  const Info({super.key});
  Future<String> _layuser() async {
  UserSession u = UserSession.fromJson(await SessionManager().get("user"));
  var tenNhanVien = u.tenNhanVien;
  return 'Xin chào: $tenNhanVien ';
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      
      FutureBuilder<String>(
        
        future: _layuser(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Đã xảy ra lỗi: ${snapshot.error}');
          } else {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png', 
                    width: 200, 
                    height: 200,
                  ),
                  SizedBox(width: 0), 
                  Text(
                    '${snapshot.data}',
                    style: const TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              );
          }
        },
      ),
      ElevatedButton(
        child: const Text("Đăng xuất"),
        onPressed: () {
          SessionManager().destroy();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
        },
      ),
    ]);
  }
}
