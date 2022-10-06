import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {
  late String id;
  late String ownName;
  late String billName;
  late int price;
  late Timestamp date;
  late List<String> listPeople;

  Bill(
    this.id,
    this.ownName,
    this.billName,
    this.price,
    this.date,
    this.listPeople,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'ownName': ownName,
      'billName': billName,
      'price': price,
      'date': date,
      'listPeople': listPeople,
    };
    return map;
  }

  Bill.fromMap(Map<String, dynamic> map) {
    id = map['id'] ?? '';
    ownName = map['ownName'] ?? '';
    billName = map['billName'] ?? '';
    price = map['price'] ?? 0;
    date = map['date'] ?? Timestamp.fromDate(DateTime.now());
    listPeople = map['listPeople'] ?? [];
  }
}
