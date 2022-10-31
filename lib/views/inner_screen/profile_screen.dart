import 'package:flutter/material.dart';
import 'package:spending_management/models/my_user.dart';
import 'package:spending_management/repository/auth_repository.dart';
import 'package:spending_management/repository/data_manager.dart';
import 'package:spending_management/repository/profile_repository.dart';
import 'package:spending_management/repository/user_repository.dart';
import 'package:spending_management/utils/constants.dart';
import 'package:spending_management/views/login/login_screen.dart';

DataManager dataManager = DataManager.instance;
final _authRepo = AuthRepository.instance;
final _profileRepo = ProfileRepository.instance;
final _userRepo = UserRepository.instance;

class ProfileScreen extends StatefulWidget {
  String currentUserId;

  ProfileScreen({required this.currentUserId, Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final maxSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Hồ sơ',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<MyUser>(
          stream: _userRepo
              .getStreamUserById(widget.currentUserId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('#');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: maxSize.width,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onLongPress: () async {
                              await _profileRepo
                                  .getFromGallery();
                              print(snapshot.data!.urlAvatar);
                            },
                            child: Container(
                              height: 0.3 * maxSize.width,
                              width: 0.3 * maxSize.width,
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage(Constants.loadingAvt),
                                foregroundImage:
                                    NetworkImage(snapshot.data!.urlAvatar),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            snapshot.data!.name,
                            style: TextStyle(fontSize: 24),
                          )
                        ]),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        child: SizedBox(
                          width: maxSize.width,
                          child: Divider(
                            color: Colors.grey.shade400,
                            height: 1,
                            thickness: 1.2,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const Text(
                          ' Thông tin cá nhân ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SizedBox(
                  //       width: 0.2 * maxSize.width,
                  //       child: Divider(
                  //         color: Colors.grey.shade400,
                  //         height: 1,
                  //         thickness: 1.2,
                  //       ),
                  //     ),
                  //     const Text(
                  //       ' Thông tin cá nhân ',
                  //       style: TextStyle(
                  //         color: Colors.grey,
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 0.2 * maxSize.width,
                  //       child: Divider(
                  //         color: Colors.grey.shade400,
                  //         height: 1,
                  //         thickness: 1.2,
                  //       ),
                  //     ),
                  //   ],
                  // ),

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
                        subtitle: Text(snapshot.data!.name),
                        trailing: GestureDetector(
                          onTap: () {
                            _profileRepo.showEditDialog(
                              context: context,
                              type: AppKeys.name,
                              text: snapshot.data!.name,
                              updateDb:
                              _profileRepo.updateName,
                            );
                          },
                          child: Image.asset(
                            'assets/images/pencil.png',
                            width: 20,
                          ),
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
                        subtitle: Text(snapshot.data!.email),
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
                        subtitle: Text(snapshot.data!.phone),
                        trailing: GestureDetector(
                          onTap: () {
                            _profileRepo.showEditDialog(
                              context: context,
                              type: AppKeys.phone,
                              text: snapshot.data!.phone,
                              updateDb:
                                  _profileRepo.updatePhone,
                            );
                          },
                          child: Image.asset(
                            'assets/images/pencil.png',
                            width: 20,
                          ),
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
                        subtitle: Text(snapshot.data!.birthday),
                        trailing: GestureDetector(
                          onTap: () {
                            _profileRepo.showEditDialog(
                              context: context,
                              type: AppKeys.birthday,
                              text: snapshot.data!.birthday,
                              updateDb:
                                  _profileRepo.updateBirthday,
                            );
                          },
                          child: Image.asset(
                            'assets/images/pencil.png',
                            width: 20,
                          ),
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
                        trailing: GestureDetector(
                          onTap: () {
                            _profileRepo.showEditDialog(
                              context: context,
                              type: AppKeys.password,
                              text: "",
                              updateDb:
                                  _profileRepo.updatePassword,
                            );
                          },
                          child: Image.asset(
                            'assets/images/pencil.png',
                            width: 20,
                          ),
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
                      onPressed: () async {
                        await _authRepo.signOut();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 40),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        'Đăng xuất',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
