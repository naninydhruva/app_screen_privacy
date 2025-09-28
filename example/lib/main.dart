import 'package:flutter/material.dart';
import 'dart:async';
import 'package:app_screen_privacy/app_screen_privacy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    AppScreenPrivacy.init(
      logo: 'assets/images/privacy-lock.png',
      backgroundColor: '#FFFFFF',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(child: Text('Test for screen overlay with custom logo\n')),
      ),
    );
  }
}
