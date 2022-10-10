import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {
  late String id;
  late String ownId;
  late String billName;
  late int price;
  late Timestamp date;
  late List<dynamic> listPeopleId;

  Bill(
    this.id,
    this.ownId,
    this.billName,
    this.price,
    this.date,
    this.listPeopleId,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'ownId': ownId,
      'billName': billName,
      'price': price,
      'date': date,
      'listPeopleId': listPeopleId,
    };
    return map;
  }

  Bill.fromMap(Map<String, dynamic> map) {
    id = map['id'] ?? '';
    ownId = map['ownId'] ?? '';
    billName = map['billName'] ?? '';
    price = map['price'] ?? 0;
    date = map['date'] ?? Timestamp.fromDate(DateTime.now());
    listPeopleId = map['listPeopleId'] ?? [];
  }
}
