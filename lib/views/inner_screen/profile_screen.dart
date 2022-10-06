import 'package:flutter/material.dart';
import 'package:spending_management/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final maxSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Hồ sơ', style: TextStyle(color: Colors.blue),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: maxSize.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 0.3 * maxSize.width,
                        width: 0.3 * maxSize.width,
                        child: CircleAvatar(
                            backgroundImage: NetworkImage(Constants.urlImage)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Trần Kim Quốc Thắng',
                        style: TextStyle(fontSize: 24),
                      )
                    ]),
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 0.2 * maxSize.width,
                    child: Divider(
                      color: Colors.grey.shade400,
                      height: 1,
                      thickness: 1.2,
                    ),
                  ),
                  const Text(
                    ' Thông tin cá nhân ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 0.2 * maxSize.width,
                    child: Divider(
                      color: Colors.grey.shade400,
                      height: 1,
                      thickness: 1.2,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: maxSize.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade300,
                ),
                child: Column(children: [
                  ListTile(
                    leading: Image.asset(
                      'assets/images/businessman.png',
                      width: 30,
                    ),
                    title: const Text('Họ tên'),
                    subtitle: const Text('Trần Kim Quốc Thắng'),
                    trailing: Image.asset(
                      'assets/images/pencil.png',
                      width: 20,
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 1,
                    thickness: 1,
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/images/mail.png',
                      width: 30,
                    ),
                    title: const Text('Email'),
                    subtitle: const Text('thangsv01@gmail.com'),
                    trailing: Image.asset(
                      'assets/images/pencil.png',
                      width: 20,
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 1,
                    thickness: 1,
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/images/phone-call.png',
                      width: 30,
                    ),
                    title: const Text('Điện thoại'),
                    subtitle: const Text('0911270031'),
                    trailing: Image.asset(
                      'assets/images/pencil.png',
                      width: 20,
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 1,
                    thickness: 1,
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/images/happy-birthday.png',
                      width: 30,
                    ),
                    title: const Text('Ngày sinh'),
                    subtitle: const Text('01/06/2001'),
                    trailing: Image.asset(
                      'assets/images/pencil.png',
                      width: 20,
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 1,
                    thickness: 1,
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/images/password.png',
                      width: 30,
                    ),
                    title: const Text('Đổi mật khẩu'),
                    subtitle: const Text('********'),
                    trailing: Image.asset(
                      'assets/images/pencil.png',
                      width: 20,
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 1,
                  ),
                ]),
              ),
              SizedBox(
                width: maxSize.width,
                child: Divider(
                  color: Colors.grey.shade400,
                  height: 1,
                  thickness: 1,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Đăng xuất', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
