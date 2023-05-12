import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';  
import 'package:shared_preferences/shared_preferences.dart';  

import './menu.dart';
import './home.dart';
  
Future<void> main() async {  
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
  SharedPreferences.getInstance().then((prefs) {  
    runApp(GetMaterialApp(home: LandingPage(prefs: prefs)));
  });  
}  

Future<void> _manejoMensajeEnSegundoPlano(RemoteMessage mensaje) async {
  // ignore: avoid_print
  print("Mensaje: ${mensaje.messageId}");
}
  
class LandingPage extends StatelessWidget {  
  final SharedPreferences prefs;  
  const LandingPage({super.key, required this.prefs});  
  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(  
      theme: ThemeData(  
        primarySwatch: Colors.blue,  
      ),  
      home: _decideMainPage(),  
    );  
  }  
  
  _decideMainPage() {  
    if (prefs.getString("token") == null) {  
      return const MyApp();  
      // return RegistrationPage(prefs: prefs);  
    } else {  
      return const HomePage();  
    } 
  }  
}  