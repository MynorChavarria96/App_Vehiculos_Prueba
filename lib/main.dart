// ignore_for_file: depend_on_referenced_packages

import 'package:app_vehiculos/app/app_widget.dart';
import 'package:app_vehiculos/providers/vehicle_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => VehicleProvider(),
      child: const AppWidget(),
    ),
  );
}


