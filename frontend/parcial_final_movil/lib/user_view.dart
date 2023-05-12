import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserView extends StatefulWidget {
  const UserView({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {

  dynamic user;

  var url = '${dotenv.env['URL']}/information';

  Future getUsers () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    var response = await http.post(Uri.parse(url), headers: {"accessToken": token!},
        body: jsonEncode({
          "email": widget.email
        }));

    var responseBody = json.decode(response.body);


    setState(() {
      print(responseBody['user']);
    });
      
  }

  @override
  initState() {
    super.initState();
    getUsers(); 
  }


  @override
  Widget build(BuildContext context) {
  

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('User'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.email),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print("object");
                }, 
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width*0.8, 50),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))
                  ),
                child: const Text('Send Message',style: TextStyle(fontSize: 20))
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                }, 
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width*0.8, 50),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))
                  ),
                child: const Text('Return',style: TextStyle(fontSize: 20))
              ),
            ]),
        ),
      )
    );
  }

  
}

