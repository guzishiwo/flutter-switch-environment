import 'package:flutter/material.dart';
import 'package:flutter_switch_environment/env.dart';
import 'package:get/get.dart';

void mainCom() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final buildEnv = Get.find<BuildEnvironment>();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Material(
        color: Colors.white,
        child: Center(
          child: Text(buildEnv.apiBaseUrl),
        ),
      ),
    );
  }
}
