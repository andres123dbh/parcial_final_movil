import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './signup_view.dart';
import './login_view.dart';
import './home.dart';

String? token;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load(fileName: "assets/.env");
  FirebaseMessaging.onBackgroundMessage(_manejoMensajeEnSegundoPlano);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.getToken().then((value) {
    // ignore: avoid_print
    print("FirebaseMessaging token: $value");
    prefs.setString('token_fmc', value!);
  });
  token = await prefs.getString("token");  
  runApp(const GetMaterialApp(home: MyApp()));
}

Future<void> _manejoMensajeEnSegundoPlano(RemoteMessage mensaje) async {
  // ignore: avoid_print
  print("Mensaje: ${mensaje.messageId}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parcial Final',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: token == null ? "/main" : "/home",
      routes: {
        '/login': (context) => const MyHomePage(title: 'Home Page'),
        "/home": (context) => const HomePage(),
      },
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
