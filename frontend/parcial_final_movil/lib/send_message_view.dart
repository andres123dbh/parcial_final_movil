import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './home.dart';

class SendMessageView extends StatefulWidget {
  const SendMessageView({Key? key, required this.recipientEmail}) : super(key: key);

  final String recipientEmail;

  @override
  State<SendMessageView> createState() => _SendMessageViewState();
}

class _SendMessageViewState extends State<SendMessageView> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Dashboard(recipientEmail: widget.recipientEmail)
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.recipientEmail}) : super(key: key);

  final String recipientEmail;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController titleControllerText = TextEditingController();
  TextEditingController messageControllerText = TextEditingController();

  String senderEmail = "";

  Future sendMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var url = '${dotenv.env['URL']}/send';

    var response = await http.post(Uri.parse(url), headers: {"accessToken": token!},
        body: jsonEncode({
          "senderEmail": senderEmail,
          "recipientEmail": widget.recipientEmail,
          "title": titleControllerText.text,
          "message": messageControllerText.text,
        }));

    var responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Get.to(() => const HomePage());
    }else{
      print(responseBody['message']);
    }
  }

  Future getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var url = '${dotenv.env['URL']}/whoiam';

    final response = await http.get(Uri.parse(url), headers: {"accessToken": token!});
    dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      senderEmail = responseData['email'];
    });
      
  }

  @override
  initState() {
    super.initState();
    getUserEmail(); 
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: const Text("Message"),
        ),
        body: Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width*0.9, 
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Text('To: ${widget.recipientEmail}',style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('From: $senderEmail',style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                const Text('Tttle (Maximum 100 characters):',style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                TextField(
                  style: const TextStyle(fontSize: 20),
                  controller: titleControllerText,
                  maxLength: 100,
                  textAlign: TextAlign.left,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), 
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Message (Maximum 800 characters):',style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                TextField(
                  style: const TextStyle(fontSize: 20),
                  controller: messageControllerText,
                  maxLength: 800,
                  maxLines: null,
                  textAlign: TextAlign.left,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), 
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    sendMessage();
                  }, 
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(50, 50),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))
                    ),
                  child: const Text('Send',style: TextStyle(fontSize: 20))
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

