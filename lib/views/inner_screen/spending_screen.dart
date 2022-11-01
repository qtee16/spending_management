import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spending_management/repository/data_manager.dart';
import 'package:spending_management/repository/user_repository.dart';
import 'package:spending_management/repository/spending_repository.dart';
import 'package:spending_management/utils/constants.dart';
import 'package:spending_management/utils/utils.dart';
import 'package:spending_management/views/bill/add_bill_screen.dart';
import 'package:spending_management/views/bill/update_bill_screen.dart';
import 'package:uuid/uuid.dart';

import '../../models/bill.dart';
import '../../models/my_user.dart';
import '../bill/widget/multi_select.dart';

DataManager dataManager = DataManager.instance;
final _userRepo = UserRepository.instance;
final _spendRepo = SpendingRepository.instance;

class SpendingScreen extends StatefulWidget {
  const SpendingScreen({Key? key}) : super(key: key);

  @override
  State<SpendingScreen> createState() => _SpendingScreenState();
}

class _SpendingScreenState extends State<SpendingScreen> {
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
              'Chi tiêu',
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
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _spendRepo.getAllBills('${selectMonth}_$selectYear'),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshots) {
                    if (snapshots.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }

                    if (snapshots.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Column(
                      children: snapshots.data!.docs.reversed
                          .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        DateTime dateTime = data['date'].toDate();
                        String strDate =
                            '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                        Bill bill = Bill.fromMap(data);
                        return GestureDetector(
                          onLongPress: () => showOptionBottom(
                              context, bill),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _userRepo.getAllUsers(),
                              builder: (context, snapshot) {
                                String avatar;
                                if (snapshot.hasData) {
                                  var users = snapshot.data!.docs
                                      .where((element) =>
                                          (element.data()!
                                              as Map<String, dynamic>)['id'] ==
                                          data['ownId'])
                                      .map((e) => MyUser.fromMap(
                                          e.data() as Map<String, dynamic>))
                                      .toList();
                                  avatar = users[0].urlAvatar;
                                } else {
                                  avatar = Constants.urlImage;
                                }
                                return SpendingItem(
                                  maxSize: maxSize,
                                  avatar: avatar,
                                  title: data['billName'],
                                  money: data['price'],
                                  date: strDate,
                                  listPeople: data['listPeopleId'],
                                );
                              },
                            ),
                            // child: FutureBuilder<MyUser>(
                            //   future: _homeRepo.getUserById(data['ownId']),
                            //   builder: (context, snapshot) {
                            //     String avatar;
                            //     if (snapshot.hasData) {
                            //       MyUser user = snapshot.data!;
                            //       avatar = user.urlAvatar;
                            //     } else {
                            //       avatar = Constants.urlImage;
                            //     }
                            //     return SpendingItem(
                            //       maxSize: maxSize,
                            //       avatar: avatar,
                            //       title: data['billName'],
                            //       money: data['price'],
                            //       date: strDate,
                            //       listPeople: data['listPeopleId'],
                            //     );
                            //   },
                            // ),
                            // child: SpendingItem(
                            //   maxSize: maxSize,
                            //   avatar: Constants.urlImage,
                            //   title: data['billName'],
                            //   money: data['price'],
                            //   date: strDate,
                            //   listPeople: data['listPeopleId'],
                            // ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showAddDialog(context, selectMonth, selectYear);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddBillScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SpendingItem extends StatelessWidget {
  const SpendingItem({
    Key? key,
    required this.maxSize,
    required this.avatar,
    required this.title,
    required this.money,
    required this.date,
    required this.listPeople,
  }) : super(key: key);

  final String avatar;
  final String title;
  final int money;
  final String date;
  final List<dynamic> listPeople;

  final Size maxSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: maxSize.width * 0.04),
          height: maxSize.width * 0.25,
          // decoration: BoxDecoration(
          //   border: Border.all(color: Colors.blue),
          //   borderRadius: BorderRadius.circular(10),
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: maxSize.width * 0.06,
                foregroundImage: NetworkImage(avatar),
                backgroundImage: AssetImage(Constants.loadingAvt),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: maxSize.width * 0.1,
                    width: maxSize.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: maxSize.width * 0.35,
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          width: maxSize.width * 0.25,
                          alignment: Alignment.centerRight,
                          child: Text(
                            date,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: maxSize.width * 0.1,
                    width: maxSize.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: maxSize.width * 0.5,
                          child: Text(
                            Constants.formatter.format(money),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: maxSize.width * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              maxSize.width * 0.05,
                            ),
                            color: Colors.blue,
                          ),
                          child: Text(
                            listPeople.length.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }
}

Future<void> selectDate(BuildContext context, Function setDate) async {
  DateTime selectedDate = DateTime.now();
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101));
  if (picked != null && picked != selectedDate) {
    Timestamp myTimeStamp = Timestamp.fromDate(picked);
    String date = '${picked.day}/${picked.month}/${picked.year}';
    setDate(myTimeStamp);
  }
}

showOptionBottom(BuildContext context, Bill bill) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height * 0.3;
      DateTime date = bill.date.toDate();
      String collection = '${date.month}_${date.year}';
      return Container(
        height: height,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showInfoDialog(context, bill);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                height: height/3,
                width: width,
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/info.png',
                      width: 0.4/3 * height,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      'Thông tin chi tiết',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                if (DataManager.instance.userId == bill.ownId) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateBillScreen(bill: bill)));
                } else {
                  showToastError('Muốn sửa á? Sửa thế đ nào được!');
                }

              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                height: height/3,
                width: width,
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/pencil.png',
                      width: 0.4/3 * height,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      'Sửa chi tiêu',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                if (DataManager.instance.userId == bill.ownId) {
                  showDeleteDialog(context, bill.id, collection);
                } else {
                  showToastError('Muốn xóa á? Xóa thế đ nào được!');
                }

              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                height: height/3,
                width: width,
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/delete.png',
                      width: 0.4/3 * height,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      'Xoá chi tiêu',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

showAddDialog(BuildContext context, int month, int year) {
  final titleController = TextEditingController();
  final moneyController = TextEditingController();
  final dateController = TextEditingController();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return FutureBuilder<List<MyUser>>(
          future: _userRepo.getAllUsersList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              MyUser selectPerson = snapshot.data![0];
              List<MyUser> selectedPeople = [];
              return StatefulBuilder(
                builder: ((context, setStateSB) {
                  void _showMultiSelect() async {
                    final List<MyUser>? results = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MultiSelect(items: snapshot.data!);
                      },
                    );

                    // Update UI
                    if (results != null) {
                      setStateSB(() {
                        selectedPeople = results;
                      });
                    }
                  }
                  var _formKey = GlobalKey<FormState>();

                  return AlertDialog(
                    scrollable: true,
                    title: const Center(child: Text('Thêm chi tiêu mới')),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButton<MyUser>(
                                  alignment: Alignment.bottomLeft,
                                  isExpanded: true,
                                  value: selectPerson,
                                  onChanged: (MyUser? user) {
                                    setStateSB(() {
                                      selectPerson = user!;
                                    });
                                  },
                                  items: snapshot.data!.map((item) {
                                    return DropdownMenuItem(
                                        value: item, child: Text(item.name));
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Tên khoản chi',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng điền đầy đủ thông tin';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: moneyController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Số tiền',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng điền đầy đủ thông tin';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: dateController,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: 'Ngày chi',
                                    suffixIcon: GestureDetector(
                                        onTap: (() =>
                                            selectDate(context, (date) {
                                              DateTime dateTime = date.toDate();
                                              String strDate =
                                                  '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                                              dateController.text = strDate;
                                              // setStateSB(() {
                                              //   dateBill = date;
                                              // });
                                            })),
                                        child: const Icon(
                                            Icons.calendar_month_outlined))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng điền đầy đủ thông tin';
                                  }
                                  return null;
                                },
                              ),
                              ElevatedButton(
                                onPressed: _showMultiSelect,
                                child: const Text('Select People'),
                              ),
                              const Divider(
                                height: 30,
                              ),
                              // display selected items
                              Wrap(
                                children: selectedPeople
                                    .map((e) => Chip(
                                          label: Text(e.name),
                                        ))
                                    .toList(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        child: const Text("Xác nhận"),
                        onPressed: () {
                          var uuid = const Uuid();
                          var id = uuid.v4();
                          var ownId = selectPerson.id;
                          var billName = titleController.text.trim();
                          var price = moneyController.text.trim();
                          var strDate = dateController.text.trim();
                          var listPeopleId =
                              selectedPeople.map((e) => e.id).toList();

                          DateTime dateTime =
                              DateFormat("dd/MM/yyyy").parse(strDate);
                          Timestamp date = Timestamp.fromDate(dateTime);

                          var bill = Bill(id, ownId, billName, int.parse(price),
                              date, listPeopleId);
                          var collection = '${month}_$year';
                          _spendRepo.addNewBill(bill, collection);
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        child: const Text("Huỷ"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                }),
              );
            }
            return AlertDialog(
              content: Row(
                children: [
                  const CircularProgressIndicator(),
                  Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text("Loading...")),
                ],
              ),
            );
          });
    },
  );
}

showInfoDialog(BuildContext context, Bill bill,) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder<List<MyUser>>(
          future: _userRepo.getAllUsersList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              MyUser selectPerson = snapshot.data!.firstWhere((user) => user.id == bill.ownId);
              List<MyUser> selectedPeople = [];
              for (var userId in bill.listPeopleId) {
                MyUser person = snapshot.data!.firstWhere((user) => user.id == userId);
                selectedPeople.add(person);
              }
              DateTime dateTime = bill.date.toDate();
              String strDate =
                  '${dateTime.day}/${dateTime.month}/${dateTime.year}';
              return AlertDialog(
                scrollable: true,
                title: const Center(child: Text('Thông tin chi tiết', style: TextStyle(fontSize: 24),)),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        rowInfo('Người chi: ', selectPerson.name),
                        const SizedBox(
                          height: 10,
                        ),
                        rowInfo('Tên khoản chi: ', bill.billName),
                        const SizedBox(
                          height: 10,
                        ),
                        rowInfo('Số tiền: ', Constants.formatter.format(bill.price)),
                        const SizedBox(
                          height: 10,
                        ),
                        rowInfo('Ngày chi: ', strDate),
                        const Divider(
                          height: 20,
                        ),
                        // display selected items
                        Wrap(
                          children: selectedPeople
                              .map((e) => Chip(
                            label: Text(e.name),
                          ))
                              .toList(),
                        )
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: const Text("Thoát"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }
            return AlertDialog(
              content: Row(
                children: [
                  const CircularProgressIndicator(),
                  Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text("Loading...")),
                ],
              ),
            );
          });
    },
  );
}

showEditDialog(BuildContext context, Bill bill, String collection) {
  final titleController = TextEditingController();
  final moneyController = TextEditingController();
  final dateController = TextEditingController();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      titleController.text = bill.billName;
      moneyController.text = bill.price.toString();
      DateTime date = bill.date.toDate();
      dateController.text = '${date.day}/${date.month}/${date.year}';

      return FutureBuilder<List<MyUser>>(
          future: _userRepo.getAllUsersList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              MyUser selectPerson = snapshot.data!.firstWhere((user) => user.id == bill.ownId);
              List<MyUser> selectedPeople = [];
              for (var userId in bill.listPeopleId) {
                MyUser person = snapshot.data!.firstWhere((user) => user.id == userId);
                selectedPeople.add(person);
              }
              return StatefulBuilder(
                builder: ((context, setStateSB) {
                  void _showMultiSelect() async {
                    final List<MyUser>? results = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MultiSelect(items: snapshot.data!);
                      },
                    );

                    // Update UI
                    if (results != null) {
                      setStateSB(() {
                        selectedPeople = results;
                      });
                    }
                  }
                  var _formKey = GlobalKey<FormState>();

                  return AlertDialog(
                    scrollable: true,
                    title: const Center(child: Text('Sửa chi tiêu')),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButton<MyUser>(
                                  alignment: Alignment.bottomLeft,
                                  isExpanded: true,
                                  value: selectPerson,
                                  onChanged: (MyUser? user) {
                                    setStateSB(() {
                                      selectPerson = user!;
                                    });
                                  },
                                  items: snapshot.data!.map((item) {
                                    return DropdownMenuItem(
                                        value: item, child: Text(item.name));
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Tên khoản chi',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng điền đầy đủ thông tin';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: moneyController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Số tiền',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng điền đầy đủ thông tin';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: dateController,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: 'Ngày chi',
                                    suffixIcon: GestureDetector(
                                        onTap: (() =>
                                            selectDate(context, (date) {
                                              DateTime dateTime = date.toDate();
                                              String strDate =
                                                  '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                                              dateController.text = strDate;
                                              // setStateSB(() {
                                              //   dateBill = date;
                                              // });
                                            })),
                                        child: const Icon(
                                            Icons.calendar_month_outlined))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng điền đầy đủ thông tin';
                                  }
                                  return null;
                                },
                              ),
                              ElevatedButton(
                                onPressed: _showMultiSelect,
                                child: const Text('Select People'),
                              ),
                              const Divider(
                                height: 30,
                              ),
                              // display selected items
                              Wrap(
                                children: selectedPeople
                                    .map((e) => Chip(
                                  label: Text(e.name),
                                ))
                                    .toList(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        child: const Text("Xác nhận"),
                        onPressed: () async {
                          var id = bill.id;
                          var ownId = selectPerson.id;
                          var billName = titleController.text.trim();
                          var price = moneyController.text.trim();
                          var strDate = dateController.text.trim();
                          var listPeopleId =
                          selectedPeople.map((e) => e.id).toList();

                          DateTime dateTime =
                          DateFormat("dd/MM/yyyy").parse(strDate);
                          Timestamp date = Timestamp.fromDate(dateTime);

                          var newBill = Bill(id, ownId, billName, int.parse(price),
                              date, listPeopleId);
                          var collection = '${dateTime.month}_${dateTime.year}';
                          await _spendRepo.editBill(newBill, collection);
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        child: const Text("Huỷ"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                }),
              );
            }
            return AlertDialog(
              content: Row(
                children: [
                  const CircularProgressIndicator(),
                  Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text("Loading...")),
                ],
              ),
            );
          });
    },
  );
}

showDeleteDialog(BuildContext context, String billId, String collection) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
          child: Text('Xoá chi tiêu'),
        ),
        content: Text('Bạn có chắc chắn muốn xoá chi tiêu này không ?'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
            child: const Text("Xác nhận"),
            onPressed: () {
              _spendRepo.deleteBill(collection, billId);
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text("Huỷ"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

rowInfo(String title, String content) {
  return Row(
    children: [
      Text(title, style: TextStyle(
        fontSize: 16,
      ),),
      Text(content, style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),),
    ],
  );
}

// class MultiSelect extends StatefulWidget {
//   final List<MyUser> items;
//
//   const MultiSelect({Key? key, required this.items}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _MultiSelectState();
// }
//
// class _MultiSelectState extends State<MultiSelect> {
//   // this variable holds the selected items
//   final List<MyUser> _selectedItems = [];
//
// // This function is triggered when a checkbox is checked or unchecked
//   void _itemChange(MyUser user, bool isSelected) {
//     setState(() {
//       if (isSelected) {
//         _selectedItems.add(user);
//       } else {
//         _selectedItems.remove(user);
//       }
//     });
//   }
//
//   // this function is called when the Cancel button is pressed
//   void _cancel() {
//     Navigator.pop(context);
//   }
//
// // this function is called when the Submit button is tapped
//   void _submit() {
//     Navigator.pop(context, _selectedItems);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Select Topics'),
//       content: SingleChildScrollView(
//         child: ListBody(
//           children: widget.items
//               .map((user) => CheckboxListTile(
//                     value: _selectedItems.contains(user),
//                     title: Text(user.name),
//                     controlAffinity: ListTileControlAffinity.leading,
//                     onChanged: (isChecked) => _itemChange(user, isChecked!),
//                   ))
//               .toList(),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: _cancel,
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: _submit,
//           child: const Text('Submit'),
//         ),
//       ],
//     );
//   }
// }
