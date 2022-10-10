import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spending_management/models/my_user.dart';
import 'package:spending_management/models/user_bill.dart';

import '../models/bill.dart';

class AnalyticRepository {
  static final AnalyticRepository analyticRepository = AnalyticRepository._getInstance();
  AnalyticRepository._getInstance();

  FirebaseFirestore ref = FirebaseFirestore.instance;

  Future<int> getTotalMoneyOfMonth(String collection) async {
    var query = await ref.collection(collection).get();
    List<Bill> bills = query.docs.map((document) => Bill.fromMap(document.data())).toList();
    int totalMoney = 0;
    for (var bill in bills) {
      totalMoney += bill.price;
    }
    return totalMoney;
  }

  Future<List<UserBill>> calculateMoney(String collection) async {
    var queryBills = await ref.collection(collection).get();
    var queryUsers = await ref.collection('users').get();

    List<Bill> bills = queryBills.docs.map((document) => Bill.fromMap(document.data())).toList();
    List<MyUser> users = queryUsers.docs.map((document) => MyUser.fromMap(document.data())).toList();

    List<UserBill> userBills = [];

    for (var user in users) {
      userBills.add(UserBill(id: user.id, name: user.name, urlAvatar: user.urlAvatar, spend: 0, debt: 0));
    }

    for (var bill in bills) {
      int index = userBills.indexWhere((element) => element.id == bill.ownId);
      var currentSpend = userBills[index].spend;
      currentSpend += bill.price;
      userBills[index].spend = currentSpend;

      var average = bill.price/bill.listPeopleId.length;

      for (var id in bill.listPeopleId) {
        int index = userBills.indexWhere((element) => element.id == id);
        var currentDebt = userBills[index].debt;
        currentDebt += average.toInt();
        userBills[index].debt = currentDebt;
      }
    }

    return userBills;
  }
}