import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import './menu.dart';
import './users_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      home: HomeUser()
    );
  }
}

class HomeUser extends StatelessWidget {
  const HomeUser({super.key});

  @override
  Widget build(BuildContext context) {

    Future<List<String>> getPhoneInformation() async {
      var deviceInfo = DeviceInfoPlugin();
      String phonemModel = '';
      String phoneId = '';

      if (Platform.isIOS) { // import 'dart:io'
        var iosDeviceInfo = await deviceInfo.iosInfo;
        phonemModel = iosDeviceInfo.model;
        phoneId = iosDeviceInfo.identifierForVendor!; // unique ID on iOS
      } else if(Platform.isAndroid) {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        phonemModel = androidDeviceInfo.model;
        phoneId = androidDeviceInfo.id; // unique ID on Android
      }
      return [phonemModel,phoneId];
    }


    Future logOut() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      List<String> informationCellphone = await getPhoneInformation();
      var url = '${dotenv.env['URL']}/logout';

      var response = await http.post(Uri.parse(url), headers: {"accessToken": token!},
          body: jsonEncode({
            "model": informationCellphone[0],
            "uuid": informationCellphone[1]
          }));

      if (response.statusCode == 200) {
        prefs.remove("token");
        Get.to(() => const MyHomePage(title: "demo"));
      }else{
        // ignore: use_build_context_synchronously
        Flushbar(
          title: "Error",
          message: "An error occurred when Log Out",
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(8),
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ).show(context);
      }
    }

    return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Hello User',style: TextStyle(fontSize: 24.0)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (() {
                  Get.to(() => const ListUsers());
                }), 
                style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width*0.8, 50),
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))
                ),
                child: const Text("View Users",style: TextStyle(fontSize: 20))
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    logOut();
                  }, 
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width*0.8, 50),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))
                    ),
                  child: const Text('Log Out',style: TextStyle(fontSize: 20))
                  ),
            ],
          )
      ),
    );  
  }
}

