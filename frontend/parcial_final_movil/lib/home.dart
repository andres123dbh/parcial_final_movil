import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import './main.dart';
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

  logOut() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("token");
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: "demo")));
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

