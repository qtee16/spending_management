import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spending_management/repository/spending_repository.dart';
import 'package:spending_management/repository/user_repository.dart';

import '../../models/bill.dart';
import '../../models/my_user.dart';
import '../../repository/data_manager.dart';
import 'widget/multi_select.dart';

DataManager dataManager = DataManager.instance;
final _userRepo = UserRepository.instance;
final _spendRepo = SpendingRepository.instance;

class UpdateBillScreen extends StatefulWidget {

  UpdateBillScreen({required this.bill, Key? key}) : super(key: key);

  Bill bill;

  @override
  State<UpdateBillScreen> createState() => _UpdateBillScreenState();
}

class _UpdateBillScreenState extends State<UpdateBillScreen> {
  final titleController = TextEditingController();
  final moneyController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.bill.billName;
    moneyController.text = widget.bill.price.toString();
    DateTime date = widget.bill.date.toDate();
    dateController.text = '${date.day}/${date.month}/${date.year}';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Sửa chi tiêu',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<MyUser>>(
            future: _userRepo.getAllUsersList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                bool visibleWarningSelectedPeople = false;
                // MyUser selectPerson = snapshot.data!.firstWhere((user) => user.id == widget.bill.ownId);
                List<MyUser> selectedPeople = [];
                for (var userId in widget.bill.listPeopleId) {
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
                    var formKey = GlobalKey<FormState>();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            // Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   padding:
                            //   const EdgeInsets.symmetric(horizontal: 10),
                            //   decoration: BoxDecoration(
                            //     border: Border.all(color: Colors.grey),
                            //     borderRadius: BorderRadius.circular(4),
                            //   ),
                            //   child: DropdownButton<MyUser>(
                            //     alignment: Alignment.bottomLeft,
                            //     isExpanded: true,
                            //     value: selectPerson,
                            //     onChanged: (MyUser? user) {
                            //       setStateSB(() {
                            //         selectPerson = user!;
                            //       });
                            //     },
                            //     items: snapshot.data!.map((item) {
                            //       return DropdownMenuItem(
                            //           value: item, child: Text(item.name));
                            //     }).toList(),
                            //   ),
                            // ),
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
                                        var id = widget.bill.id;
                                        var ownId = dataManager.userId!;
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
                                      } else {
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



