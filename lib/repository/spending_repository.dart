import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spending_management/models/bill.dart';

class SpendingRepository {
  static final SpendingRepository spendingRepository =
      SpendingRepository._getInstance();
  SpendingRepository._getInstance();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var ref = FirebaseFirestore.instance;

  addNewBill(Bill newBill, String collection) {
    ref
        .collection(collection)
        .doc(newBill.id)
        .set(newBill.toMap())
        .catchError((error) => print('Failed to add bill: $error'));
  }

  getAllBills(String collection) {
    return ref.collection(collection).orderBy('date').snapshots();
  }

  Future<void> deleteBill(String collection, String billId) {
    return ref
        .collection(collection)
        .doc(billId)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
