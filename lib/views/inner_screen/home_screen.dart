import 'dart:async';

import 'package:flutter/material.dart';
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
    final avtWidth = (maxSize.width - 80)/2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Trang chủ', style: TextStyle(color: Colors.blue),),
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
                'Member',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                  height: (myProducts.length ~/ 2 + 1).toDouble()*(avtWidth + 20),
                  child: GridView.count(
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1,
                    crossAxisCount: 2,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(
                      myProducts.length,
                      (index) {
                        return Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Container(
                                height: avtWidth*0.7,
                                width: avtWidth*0.7,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(avtWidth/2),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(Constants.urlImage),
                                ),
                              ),
                              Text('Thang', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        );
                      },
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
