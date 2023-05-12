import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './main.dart';

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
            children: [
              const Text('Hello user',style: TextStyle(fontSize: 24.0)),
              ElevatedButton(
                  onPressed: () {
                    logOut();
                  }, 
                  style: ElevatedButton.styleFrom(
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

