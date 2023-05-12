import 'dart:typed_data';

import 'package:flutter/material.dart';

class UserCard{
    Uint8List photo;
    String fullName;
    String email;

    UserCard({required this.fullName, required this.email,required this.photo});

    Widget build(BuildContext context){
      return Container(
        height: 80,
        decoration: BoxDecoration(
        color: const Color(0xFF94CCF9),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 107, 107, 107),
            offset: Offset(7, 7),
            blurRadius: 6,
          ),
        ],
      ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Image.memory(photo, width: 90, height: 80))
              ],
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(fullName),
                const SizedBox(height: 5),
                Text(email)
              ],
            )
          ],
        ),
      );
    }

}
