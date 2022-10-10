class UserBill {
  late String id;
  late String name;
  late String urlAvatar;
  late int spend;
  late int debt;

  UserBill({required this.id, required this.name, required this.urlAvatar, required this.spend, required this.debt});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'id': id,
      'name': name,
      'urlAvatar': urlAvatar,
      'spend': spend,
      'debt': debt,
    };
    return map;
  }

  UserBill.fromMap(Map<String, dynamic> map) {
    id = map['id'] ?? '';
    name = map['name'] ?? '';
    urlAvatar = map['urlAvatar'] ?? '';
    spend = map['spend'] ?? '';
    debt = map['debt'] ?? '';
  }
}