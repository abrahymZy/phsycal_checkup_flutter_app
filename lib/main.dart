import 'package:flutter/material.dart';
import 'package:train_flutter_application/checkup.dart';
import 'package:train_flutter_application/simples.dart';
import 'home_screen.dart';
import 'login.dart';
import 'sick.dart';


void main()
{
  runApp(
    MaterialApp(
      home: Login(),
      routes: {
        '/Login':(context)=>Login(),
        '/HomeScreen':(context)=>HomeScreen(),
        '/sick' : (context) => Sick(),
        '/check':(context) => Checkup(),
        '/simple':(context)=>Simples()
      },
    )
  );
}
