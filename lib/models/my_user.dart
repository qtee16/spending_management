class MyUser {
  late String id;
  late String name;
  late String email;
  late String birthday;
  late String phone;
  late String urlAvatar;

  MyUser({
    required this.id,
    required this.name,
    required this.email,
    required this.urlAvatar,
    this.birthday = '',
    this.phone = '',
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'id': id,
      'name': name,
      'email': email,
      'birthday': birthday,
      'phone': phone,
      'urlAvatar': urlAvatar,
    };
    return map;
  }

  MyUser.fromMap(Map<String, dynamic> map) {
    id = map['id'] ?? '';
    name = map['name'] ?? '';
    email = map['email'] ?? '';
    birthday = map['birthday'] ?? '';
    phone = map['phone'] ?? '';
    urlAvatar = map['urlAvatar'] ?? '';
  }
}