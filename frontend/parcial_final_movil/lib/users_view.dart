import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import './user_card.dart';


class ListUsers extends StatefulWidget {
  const ListUsers({super.key});

  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {

  List<dynamic> userList = [];

  var url = '${dotenv.env['URL']}/users';

  Future getUsers () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.get(Uri.parse(url), headers: {"accessToken": token!});
    dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
    userList = responseData['users'];

    setState(() {
      userList = responseData['users'];
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
          title: const Text("Users"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Users:',style: TextStyle(fontSize: 24.0)),
            const SizedBox(height: 20),
            userList.isEmpty ? Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: const [
                      Text('No users yet',style: TextStyle(fontSize: 24.0)),
                      SizedBox(height: 20),
                    ],
                  )
            ): ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: userList.length,
              itemBuilder: (BuildContext context, int index) {
                Uint8List bytesImage = const Base64Decoder().convert(userList[index]['foto']);
                return UserCard(photo: bytesImage, fullName: userList[index]['nombre_completo'], email: userList[index]['email']).build(context);
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
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
          ],
        )
        
      ),
    );
  }

  
}
