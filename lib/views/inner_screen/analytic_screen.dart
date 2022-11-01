import 'package:flutter/material.dart';
import 'package:spending_management/models/user_bill.dart';
import 'package:spending_management/repository/analytic_repository.dart';
import 'package:spending_management/repository/data_manager.dart';
import 'package:spending_management/utils/constants.dart';

DataManager dataManager = DataManager.instance;
final _analyticRepo = AnalyticRepository.instance;

class AnalyticScreen extends StatefulWidget {
  const AnalyticScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticScreen> createState() => _AnalyticScreenState();
}

class _AnalyticScreenState extends State<AnalyticScreen> {
  int selectMonth = DateTime.now().month;
  int selectYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final maxSize = MediaQuery.of(context).size;
    final paddingTop = MediaQuery.of(context).padding.top;
    final contentHeight = maxSize.height -
        kToolbarHeight -
        kBottomNavigationBarHeight -
        paddingTop;
    int totalMoney = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: contentHeight * 0.24,
        title: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Thống kê',
              style: TextStyle(color: Colors.blue),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton(
                        value: selectMonth,
                        onChanged: (value) {
                          setState(() {
                            selectMonth = int.parse(value.toString());
                          });
                        },
                        items: Constants.monthKeys.map((item) {
                          return DropdownMenuItem(
                              value: item, child: Text('Tháng $item'));
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton(
                        value: selectYear,
                        onChanged: (value) {
                          setState(() {
                            selectYear = int.parse(value.toString());
                          });
                        },
                        items: Constants.years.map((item) {
                          return DropdownMenuItem(
                              value: item, child: Text('$item'));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/reloading.png'),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng chi: ',
                        style: TextStyle(fontSize: 24),
                      ),
                      FutureBuilder<int>(
                          future: _analyticRepo.getTotalMoneyOfMonth(
                              "${selectMonth}_$selectYear"),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Center(child: Text('#'));
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return Text(
                              Constants.formatter.format(snapshot.data),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }),
                      // StreamBuilder<QuerySnapshot>(
                      //   stream: _spendRepo.getAllBills('${selectMonth}_$selectYear'),
                      //   builder: (BuildContext context,
                      //       AsyncSnapshot<QuerySnapshot> snapshots) {
                      //     if (snapshots.hasError) {
                      //       return const Center(child: Text('#'));
                      //     }
                      //
                      //     if (snapshots.connectionState == ConnectionState.waiting) {
                      //       return const Center(child: CircularProgressIndicator());
                      //     }
                      //
                      //
                      //     List<Bill> bills = snapshots.data!.docs.reversed
                      //           .map((DocumentSnapshot document) {
                      //         Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      //         Bill bill = Bill.fromMap(data);
                      //         return bill;
                      //       }).toList();
                      //     for (var bill in bills) {
                      //       totalMoney += bill.price;
                      //     }
                      //     return Text(
                      //       Constants.formatter.format(totalMoney),
                      //       style: const TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold,),
                      //     );
                      //   },
                      // ),
                      // StreamBuilder<QuerySnapshot>(
                      //   stream: _analyticRepo.getTotalMoneyOfMonth('${selectMonth}_$selectYear}'),
                      //     builder: (context, snapshots) {
                      //     int totalMoney = 0;
                      //     for (var element in snapshots.data!.docs) {
                      //       int price = int.parse((element.data() as Map<String, dynamic>)['price']);
                      //       totalMoney += price;
                      //       print('priceeeeeeeeeeeeeeeee');
                      //       print(price);
                      //     }
                      //     if (snapshots.hasError) {
                      //       return const Center(child: Text('Something went wrong'));
                      //     }
                      //
                      //     if (snapshots.connectionState == ConnectionState.waiting) {
                      //       return const Center(child: CircularProgressIndicator());
                      //     }
                      //
                      //     return Text(
                      //       Constants.formatter.format(totalMoney),
                      //       style: const TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold,),
                      //     );
                      //
                      // }),
                    ]),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<List<UserBill>>(
                  future: _analyticRepo
                      .calculateMoney("${selectMonth}_$selectYear"),
                  builder: (context, snapshot) {
                    try {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Column(
                        children: snapshot.data!.map((userBill) {
                          var res = userBill.spend - userBill.debt;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Material(
                              elevation: 4,
                              child: ListTile(
                                leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage(Constants.loadingAvt),
                                    foregroundImage:
                                        NetworkImage(userBill.urlAvatar)),
                                title: Text(
                                  userBill.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '-${Constants.formatter.format(userBill.debt)}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                                trailing: Text(
                                  ((res > 0) ? '+' : '') +
                                      Constants.formatter.format(res),
                                  style: (res > 0)
                                      ? const TextStyle(
                                          color: Colors.green,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )
                                      : const TextStyle(
                                          color: Colors.red,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    } catch (e) {
                      print('Error: $e');
                    }
                    return Container();
                  }),
              // for (var i = 0; i < 5; i++)
              //   Container(
              //     margin: const EdgeInsets.only(bottom: 10),
              //     child: ListTile(
              //       shape: RoundedRectangleBorder(
              //         side: const BorderSide(color: Colors.black, width: 1),
              //         borderRadius: BorderRadius.circular(5),
              //       ),
              //       leading: CircleAvatar(
              //           backgroundImage: NetworkImage(Constants.urlImage)),
              //       title: const Text(
              //         'Thang',
              //         style:
              //             TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //       ),
              //       subtitle: Text(
              //         '-${Constants.formatter.format(500000)}',
              //         style: const TextStyle(
              //           color: Colors.red,
              //           fontSize: 16,
              //         ),
              //       ),
              //       trailing: Text(
              //         '+${Constants.formatter.format(300000)}',
              //         style: const TextStyle(
              //           color: Colors.green,
              //           fontSize: 28,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
