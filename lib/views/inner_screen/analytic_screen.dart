import 'package:flutter/material.dart';
import 'package:spending_management/utils/constants.dart';


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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      const Text(
                        'Tổng chi: ',
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        Constants.formatter.format(1000000),
                        style: const TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold,),
                      ),
                    ]),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Trung bình: ',
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        Constants.formatter.format(200000),
                        style: const TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold,),
                      ),
                    ]),
              ),
              const SizedBox(
                height: 20,
              ),
              for (var i = 0; i < 5; i++)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(Constants.urlImage)),
                    title: const Text(
                      'Thang',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '-${Constants.formatter.format(500000)}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Text(
                      '+${Constants.formatter.format(300000)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
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
  }) : super(key: key);

  final String avatar;
  final String title;
  final int money;
  final String date;

  final Size maxSize;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: maxSize.width * 0.04),
        height: maxSize.width * 0.25,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CircleAvatar(
            radius: maxSize.width * 0.06,
            backgroundImage: NetworkImage(avatar),
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
                      width: maxSize.width * 0.4,
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      width: maxSize.width * 0.2,
                      alignment: Alignment.centerRight,
                      child: Text(
                        date,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                height: maxSize.width * 0.1,
                width: maxSize.width * 0.6,
                child: Text(
                  money.toString(),
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ]),
      )
    ]);
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
    String date = '${picked.day}/${picked.month}/${picked.year}';
    setDate(date);
  }
}

showOptionBottom(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height * 0.2;
      return Container(
        height: height,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showEditDialog(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                height: 0.5 * height,
                width: width,
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/pencil.png',
                      width: 0.2 * height,
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
                showDeleteDialog(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                height: 0.5 * height,
                width: width,
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/delete.png',
                      width: 0.2 * height,
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

showAddDialog(BuildContext context) {
  final nameController = TextEditingController();
  final titleController = TextEditingController();
  final moneyController = TextEditingController();
  final dateController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Center(child: Text('Thêm chi tiêu mới')),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tên người chi',
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
                            onTap: (() => selectDate(
                                context, (date) => dateController.text = date)),
                            child: const Icon(Icons.calendar_month_outlined))),
                  ),
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
              // your code
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

showEditDialog(BuildContext context) {
  final nameController = TextEditingController();
  final titleController = TextEditingController();
  final moneyController = TextEditingController();
  final dateController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Center(child: Text('Sửa chi tiêu')),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tên người chi',
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
                          onTap: () {
                            selectDate(
                              context,
                              (date) => dateController.text = date,
                            );
                          },
                          child: const Icon(Icons.calendar_month_outlined)),
                    ),
                  ),
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
              // your code
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

showDeleteDialog(BuildContext context) {
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
              // your code
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
