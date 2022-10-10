import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spending_management/repository/user_repository.dart';
import 'package:spending_management/repository/spending_repository.dart';
import 'package:uuid/uuid.dart';

import '../../models/bill.dart';
import '../../models/my_user.dart';
import 'widget/multi_select.dart';

UserRepository _homeRepo = UserRepository.userRepository;
SpendingRepository _spendRepo = SpendingRepository.spendingRepository;

class AddBillScreen extends StatefulWidget {
  const AddBillScreen({Key? key}) : super(key: key);

  @override
  State<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final titleController = TextEditingController();
  final moneyController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Thêm chi tiêu mới',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<MyUser>>(
            future: _homeRepo.getAllUsersList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                MyUser selectPerson = snapshot.data![0];
                List<MyUser> selectedPeople = [];
                bool visibleWarningSelectedPeople = false;
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
                    var formKey = GlobalKey<FormState>();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: Form(
                        key: formKey,
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
                              readOnly: true,
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
                            const SizedBox(height: 10,),
                            ElevatedButton(
                              onPressed: _showMultiSelect,
                              child: const Text('Chọn thành viên'),
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
                            ),
                            Visibility(child: Text('*Vui lòng chọn thành viên', style: TextStyle(color: Colors.red),), visible: visibleWarningSelectedPeople,),

                            const SizedBox(height: 30,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                  child: const Text("Xác nhận"),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      if (selectedPeople.isNotEmpty) {
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
                                        var collection = '${dateTime.month}_${dateTime.year}';
                                        _spendRepo.addNewBill(bill, collection);
                                        Navigator.pop(context);
                                      } else if (selectedPeople.isEmpty) {
                                        setStateSB(() {
                                          visibleWarningSelectedPeople = true;
                                        });
                                      }

                                    }
                                  },
                                ),
                                const SizedBox(width: 20,),
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
                            )
                          ],
                        ),
                      ),
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
            }),
      ),
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



