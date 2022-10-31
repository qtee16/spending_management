import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spending_management/repository/data_manager.dart';
import 'package:spending_management/repository/general_repository.dart';
import 'package:spending_management/views/login/login_screen.dart';
import 'package:spending_management/views/main/main_screen.dart';
import 'package:spending_management/views/update/update_screen.dart';

import 'config.dart';

DataManager dataManager = DataManager.instance;
final _generalRepo = GeneralRepository.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var currentUserId = await dataManager.getCurrentUserId();
  var currentVersion = await _generalRepo.getCurrentVersion();
  var updateLink = await _generalRepo.getUpdateLink();


  runApp(MyApp(currentVersion: currentVersion, updateLink: updateLink, currentUserId: currentUserId,));
}

class MyApp extends StatelessWidget {
  String currentVersion;
  String updateLink;
  String? currentUserId;
  MyApp({required this.currentVersion, required this.updateLink, this.currentUserId, Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _firstScreen(currentVersion, updateLink, currentUserId,),
    );
  }
}

Widget _firstScreen(String currentVersion, String updateLink, String? currentUserId) {
  print(currentUserId);
  if (currentVersion == CONFIG_VERSION) {
    if (currentUserId == null) {
      return const LoginScreen();
    } else {
      return MainScreen(currentUserId: currentUserId,);
    }
  } else {
    return UpdateScreen(updateLink: updateLink,);
  }

}
