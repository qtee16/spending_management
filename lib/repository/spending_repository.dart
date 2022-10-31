import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spending_management/models/bill.dart';

class SpendingRepository {
  static final SpendingRepository instance =
      SpendingRepository._getInstance();

  SpendingRepository._getInstance();

  var ref = FirebaseFirestore.instance;

  addNewBill(Bill newBill, String collection) {
    ref
        .collection(collection)
        .doc(newBill.id)
        .set(newBill.toMap())
        .catchError((error) => print('Failed to add bill: $error'));
  }

  editBill(Bill bill, String collection) {
    print(bill.id);
    ref
        .collection(collection)
        .doc(bill.id)
        .update(bill.toMap())
        .then((value) => print('Update ${bill.id}'))
        .catchError((error) => print('Failed to update: $error'));
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
