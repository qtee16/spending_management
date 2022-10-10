import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spending_management/repository/data_manager.dart';
import 'package:spending_management/views/login/login_screen.dart';
import 'package:spending_management/views/main/main_screen.dart';

DataManager dataManager = DataManager.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var currentUserId = await dataManager.getCurrentUserId();


  runApp(MyApp(currentUserId: currentUserId,));
}

class MyApp extends StatelessWidget {
  String? currentUserId;
  MyApp({this.currentUserId, Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _firstScreen(currentUserId),
    );
  }
}

Widget _firstScreen(String? currentUserId) {
  print(currentUserId);
  if (currentUserId == null) {
    return const LoginScreen();
  } else {
    return MainScreen(currentUserId: currentUserId,);
  }
}
