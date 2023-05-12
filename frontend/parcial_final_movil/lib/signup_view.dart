import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';


String? tokenFmc;

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}



class _SignUpViewState extends State<SignUpView> {

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
  TextEditingController fullNameControllerText = TextEditingController();
  TextEditingController phoneNumberControllerText = TextEditingController();
  TextEditingController passwordControllerText = TextEditingController();
  TextEditingController positionControllerText = TextEditingController();
  File? imageFile;

  // Initial Selected Value
  String? selectedValue;
  
  // List of items in our dropdown menu
  var items = [    
    'Assistant',
    'Network Technician',
    'General Services',
    'Logistic Operator',
    'Accountant',
    'Assistant manager',
  ];

    _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

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


  Future signUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    const url = 'http://192.168.1.14:8080/signup';
    tokenFmc = prefs.getString("token_fmc"); 
    List<String> informationCellphone = await getPhoneInformation();
    Uint8List imagebytes = await imageFile!.readAsBytes(); 
    String base64string = base64.encode(imagebytes);

    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "email": emailControllerText.text,
          "password": passwordControllerText.text,
          "photo": base64string,
          "name": fullNameControllerText.text,
          "cellphone": int.parse(phoneNumberControllerText.text),
          "position": positionControllerText.text,
          "model": informationCellphone[0],
          "uuid": informationCellphone[1],
          "token_FMC": tokenFmc,
        }));
      
    var responseBody = json.decode(response.body);
        
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    }else{
      // ignore: avoid_print
      print(responseBody['message']);
    }

    
      
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up"),
        ),
        body: Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width*0.9, 
            child: ListView(
              children: [
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
                  controller: fullNameControllerText,
                  textAlign: TextAlign.left,
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), 
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  style: const TextStyle(fontSize: 20),
                  controller: phoneNumberControllerText,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), 
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    hint: const Text(
                      'Position',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 85, 85, 85)
                      ),
                    ),
                    items: items
                        .map((item) =>
                        DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 85, 85, 85)
                            ),
                          ),
                        ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value as String;
                        positionControllerText.text = selectedValue!;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: 160,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color.fromARGB(255, 158, 158, 158),
                        ),
                      ),
                    ),
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
                imageFile == null ? Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      _getFromGallery();
                    }, 
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width*0.8, 50),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))
                      ),
                    child: const Text('Pick Photo',style: TextStyle(fontSize: 20))
                  ),
                ): SizedBox(
                  height: 200,
                  child: Image.file(
                  imageFile!,
                ),
                ),
                
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    signUp();
                  }, 
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(50, 50),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))
                    ),
                  child: const Text('Sign Up',style: TextStyle(fontSize: 20))
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

