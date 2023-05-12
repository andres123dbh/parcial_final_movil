import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './send_message_view.dart';

class UserView extends StatefulWidget {
  const UserView({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {

  User user = User("","",0,"");

  Widget image = Container();

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
      image = Image.memory(const Base64Decoder().convert(responseBody['user']['foto']), width: 250, height: 150,fit: BoxFit.fill);
      user = User(responseBody['user']['nombre_completo'], responseBody['user']['email'], responseBody['user']['celular'], responseBody['user']['cargo']);
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
              Text(user.fullName,style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 10),
              image,
              const SizedBox(height: 10),
              Text('Email: ${user.email}',style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Cell Phone: ${user.cellphone}',style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Position: ${user.position}',style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => SendMessageView(recipientEmail: user.email));
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


class User {
  String fullName;
  String email;
  int cellphone;
  String position;
  
  User(this.fullName,this.email,this.cellphone,this.position);
}
