import 'package:flutter/material.dart';
import 'auth_wrapper.dart';


class AppWidget  extends StatelessWidget {
  const AppWidget ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Vehículos',
      theme: ThemeData(
      useMaterial3: false, 
      primarySwatch: Colors.blueGrey,
  ),
      home: const AuthWrapper(),
    );
  }
}