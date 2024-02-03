import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      onForeground: onIosForeground,
      onBackground: onIosBackground,
    ), 
    androidConfiguration: AndroidConfiguration(
      onStart: onStart, isForegroundMode: true));
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  Timer.periodic(const Duration(seconds: 1), (timer) async{ 
        print("Background service running");
      });
  return true;
}

@pragma('vm:entry-point')
Future<bool> onIosForeground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  print("Foreground service running");
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service){
  DartPluginRegistrant.ensureInitialized();
  if(service is AndroidServiceInstance){
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
      print("Foreground service running");
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
      Timer.periodic(const Duration(seconds: 1), (timer) async{ 
        print("Background service running");
      });
    });
  }

  service.on('stopService').listen((event) {
      service.stopSelf();
      print("Service stopped");
    });
  // Timer.periodic(const Duration(seconds: 1), (timer) async{ 
  //   if(service is AndroidServiceInstance){
  //     if (await service.isForegroundService()){
  //       service.setForegroundNotificationInfo(
  //         title: "Hello World", content: "Foreground service working!!");
  //     }
  //   }
  // });
}