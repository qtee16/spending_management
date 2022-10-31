import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:spending_management/models/my_user.dart';

class UserRepository {
  static final UserRepository instance = UserRepository._getInstance();
  UserRepository._getInstance();

  final storageRef = FirebaseStorage.instance.ref();
  final fireStoreRef = FirebaseFirestore.instance;

  Future<String> getUrlImage() async {
    final imageRef = await storageRef.child('images/avatar/default.png').getDownloadURL();
    return imageRef;
  }

  Future<MyUser> getUserById(String userId) async {
    var query = await fireStoreRef.collection('users').doc(userId).get();
    var user = MyUser.fromMap(query.data()!);
    return user;
  }

  Stream<MyUser> getStreamUserById(String userId)  {
    return fireStoreRef.collection('users').doc(userId).snapshots().map(
            (event) => MyUser.fromMap(event.data()!),
    );
  }

  getAllUsers() {
    return fireStoreRef.collection('users').snapshots();
  }

  Future<List<MyUser>> getAllUsersList() async {
    var querySnapshot = await fireStoreRef.collection('users').get();
    var listUser = querySnapshot.docs.map((e) => MyUser.fromMap(e.data())).toList();
    return listUser;
  }

}