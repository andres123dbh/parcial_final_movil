import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './signup_view.dart';
import './login_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parcial Final',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parcial Final"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: (() {
                Get.to(() => const SignUpView());
              }),
              style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width*0.8, 50),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))
              ),
              child: const Text("Sign Up",style: TextStyle(fontSize: 20))
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (() {
                Get.to(() => const LoginView());
              }), 
              style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width*0.8, 50),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))
              ),
              child: const Text("Log In",style: TextStyle(fontSize: 20))
            ),
          ],
        ),
      )
    );
  }
}
