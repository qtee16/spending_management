import 'package:cloud_firestore/cloud_firestore.dart';

class GeneralRepository {
  static final GeneralRepository instance = GeneralRepository._getInstance();
  GeneralRepository._getInstance();

  final fireStoreRef = FirebaseFirestore.instance;
  
  Future<String> getCurrentVersion() async {
    var query = await fireStoreRef.collection('update').doc('update_id').get();
    var data = query.data();
    return data!['version'];
  }

  Future<String> getUpdateLink() async {
    var query = await fireStoreRef.collection('update').doc('update_id').get();
    var data = query.data();
    return data!['updateLink'];
  }
}