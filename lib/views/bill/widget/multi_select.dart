import 'package:flutter/material.dart';

import '../../../models/my_user.dart';

class MultiSelect extends StatefulWidget {
  final List<MyUser> items;

  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<MyUser> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(MyUser user, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(user);
      } else {
        _selectedItems.remove(user);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Chọn thành viên'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((user) => CheckboxListTile(
            value: _selectedItems.contains(user),
            title: Text(user.name),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(user, isChecked!),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Xác nhận'),
        ),
      ],
    );
  }
}