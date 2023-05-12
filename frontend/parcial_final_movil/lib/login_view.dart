import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:another_flushbar/flushbar.dart';

import './home.dart';

String? tokenFmc;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      home: Dashboard()
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController emailControllerText = TextEditingController();
  TextEditingController passwordControllerText = TextEditingController();

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

  Future login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = '${dotenv.env['URL']}/login';
    tokenFmc = prefs.getString("token_fmc"); 
    List<String> informationCellphone = await getPhoneInformation();


    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "email": emailControllerText.text,
          "password": passwordControllerText.text,
          "model": informationCellphone[0],
          "uuid": informationCellphone[1],
          "token_FMC": tokenFmc,
        }));

    var responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      prefs.setString('token', responseBody['token']);
      // ignore: use_build_context_synchronously
      Flushbar(
        title: "Log In",
        message: "Log In Satisfactorily",
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.green,
        borderRadius: BorderRadius.circular(8),
      ).show(context);
      // ignore: use_build_context_synchronously
      Future.delayed(const Duration(seconds: 1), () {
        Get.to(() => const HomePage());
      });
    }else{
      // ignore: use_build_context_synchronously
      Flushbar(
        title: "Error",
        message: "An error occurred when Log In",
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: const Text("Log In"),
        ),
        body: Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width*0.9, 
            child: ListView(
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.account_circle,
                  color: Colors.blue,
                  size: 180,
                ),
                const SizedBox(height: 20),
                TextField(
                  style: const TextStyle(fontSize: 20),
                  controller: emailControllerText,
                  textAlign: TextAlign.left,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), 
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  style: const TextStyle(fontSize: 20),
                  controller: passwordControllerText,
                  textAlign: TextAlign.left,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), 
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    login();
                  }, 
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(50, 50),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))
                    ),
                  child: const Text('Login',style: TextStyle(fontSize: 20))
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  }, 
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(50, 50),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))
                    ),
                  child: const Text('Return',style: TextStyle(fontSize: 20))
                ),
              ],
          ),
          
        )
      ),
    );  
  }
}

