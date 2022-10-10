import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spending_management/models/my_user.dart';
import 'package:spending_management/repository/user_repository.dart';
import 'package:spending_management/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map> myProducts =
      List.generate(5, (index) => {"id": index, "name": "Product $index"})
          .toList();

  @override
  Widget build(BuildContext context) {
    final maxSize = MediaQuery.of(context).size;
    final avtWidth = (maxSize.width - 80) / 2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Trang chủ',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                'Thành viên',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: UserRepository.userRepository.getAllUsers(),
              builder: (context, snapshots) {
                if (snapshots.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var listUser = snapshots.data!.docs
                    .map((document) => MyUser.fromMap(
                        document.data() as Map<String, dynamic>))
                    .toList();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    height: (listUser.length ~/ 2 + 1).toDouble() * (avtWidth + 20),
                    child: GridView.count(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1,
                      crossAxisCount: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        listUser.length,
                        (index) {
                          return Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                  height: avtWidth * 0.7,
                                  width: avtWidth * 0.7,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius:
                                        BorderRadius.circular(avtWidth / 2),
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(listUser[index].urlAvatar),
                                  ),
                                  // child: FutureBuilder<String>(
                                  //   future: HomeRepository.homeRepository
                                  //       .getUrlImage(),
                                  //   builder: (BuildContext context,
                                  //       AsyncSnapshot snapshot) {
                                  //     if (snapshot.connectionState ==
                                  //         ConnectionState.waiting) {
                                  //       return CircularProgressIndicator();
                                  //     }
                                  //     if (snapshot.hasData) {
                                  //       return CircleAvatar(
                                  //         backgroundImage:
                                  //             NetworkImage(snapshot.data),
                                  //       );
                                  //     }
                                  //     return Container();
                                  //   },
                                  // ),
                                ),
                                Text(
                                  listUser[index].name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
