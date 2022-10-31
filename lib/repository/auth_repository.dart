import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spending_management/repository/data_manager.dart';
import 'package:spending_management/utils/constants.dart';
import 'package:spending_management/utils/utils.dart';

import '../models/my_user.dart';

class AuthRepository {
  static final AuthRepository instance = AuthRepository._getInstance();

  AuthRepository._getInstance();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  DataManager dataManager = DataManager.instance;

  var ref  = FirebaseFirestore.instance;

  registerWithEmailAndPassword(String name, String email, String password) async {
    await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      var urlAvatar = Constants.urlImage;
      var newUser = MyUser(
          id: value.user!.uid,
          name: name,
          email: email,
          urlAvatar: urlAvatar,
          hashPassword: encrypt(password),
      );
      ref
          .collection('users')
          .doc(value.user!.uid)
          .set(newUser.toMap())
          .catchError((e) => print('error: $e'));
      dataManager.setCurrentUserId(value.user!.uid);
    }).catchError((e) => print('error: $e'));
  }

  loginWithEmailAndPassword(String email, String password) async {
    await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)
        .then((value) => dataManager.setCurrentUserId(value.user!.uid))
        .catchError((e) => print('error: $e'));
  }

  signOut() async {
    await firebaseAuth.signOut()
    .then((value) => dataManager.removeCurrentUserId())
    .catchError((e) => print('error: $e'));
  }

}
