import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spending_management/repository/data_manager.dart';
import 'package:spending_management/repository/user_repository.dart';
import 'package:spending_management/utils/constants.dart';
import 'package:spending_management/utils/utils.dart';

import '../views/bill/add_bill_screen.dart';

class ProfileRepository {
  static final ProfileRepository instance = ProfileRepository._getInstance();

  ProfileRepository._getInstance();

  final storageRef = FirebaseStorage.instance.ref();
  final firestore = FirebaseFirestore.instance;

  DataManager dataManager = DataManager.instance;
  final _userRepo = UserRepository.instance;

  getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final metadata = SettableMetadata(contentType: "image/jpeg");
      var currentUserId = await dataManager.getCurrentUserId();
      final uploadTask = storageRef
          .child('images/avatar/$currentUserId.jpg')
          .putFile(imageFile, metadata);

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
          // Handle unsuccessful uploads
            break;
          case TaskState.success:
          // Handle successful uploads on complete
          // ...
            await updateAvatar();
            print("Upload is successfully");
            break;
        }
      });
    }
  }

  updateAvatar() async {
    final url = await storageRef
        .child('images')
        .child('avatar')
        .child('${dataManager.userId}.jpg')
        .getDownloadURL();
    firestore.collection('users').doc(dataManager.userId).update({
      "urlAvatar": url,
    });
  }

  updateName(String name) async {
    firestore.collection('users').doc(dataManager.userId).update({
      "name": name,
    });
  }

  updatePhone(String phone) async {
    firestore.collection('users').doc(dataManager.userId).update({
      "phone": phone,
    });
  }

  updateBirthday(String birthday) async {
    firestore.collection('users').doc(dataManager.userId).update({
      "birthday": birthday,
    });
  }

  updatePassword(BuildContext context, String password) async {
    //Create an instance of the current user.
    final user = FirebaseAuth.instance.currentUser!;

    //Pass in the password to updatePassword.
    try {
      await user.updatePassword(password);
      firestore.collection('users').doc(dataManager.userId).update({
        "hashPassword": encrypt(password),
      });
      showToastSuccess('Đổi mật khẩu thành công');
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        showToastError('Vui lòng đăng nhập lại để thay đổi mật khẩu');
      }
      print('Failed with error code: ${e.code}');
      print(e.message);
    } catch (e) {
      print('Error: ' + e.toString());
    }
    // user.updatePassword(password).then((_) {
    //   print("Successfully changed password");
    //   firestore.collection('users').doc(dataManager.userId).update({
    //     "hashPassword": encrypt(password),
    //   });
    //   showToastSuccess('Đổi mật khẩu thành công');
    //   Navigator.pop(context);
    // })
    //     .catchError((error) {
    //   print("Password can't be changed" + error.toString());
    //
    //   //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    // });
  }

  checkCorrectPassword(String password) async {
    final currentUser = await _userRepo.getUserById(dataManager.userId!);
    print('Check ${currentUser.hashPassword == encrypt(password)}');
    return currentUser.hashPassword == encrypt(password);
  }

  checkInputForm(
      BuildContext context,
      String type,
      TextEditingController formController,
      [TextEditingController? passController, TextEditingController? cfPassController,]
      ) {
    if (type == AppKeys.birthday) {
      return TextFormField(
        readOnly: true,
        controller: formController,
        decoration: InputDecoration(
            labelText: Constants.keyName[type],
            icon: Constants.keyIcon[type],
            suffixIcon: GestureDetector(
                onTap: (() =>
                    selectDate(context, (date) {
                      DateTime dateTime = date.toDate();
                      String strDate =
                          '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                      formController.text = strDate;
                    })),
                child: const Icon(
                    Icons.calendar_month_outlined))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng điền đầy đủ thông tin';
          }
          return null;
        },
      );
    }
    if (type == AppKeys.password) {
      return Column(
        children: [
          TextFormField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            controller: formController,
            decoration: InputDecoration(
              labelText: 'Mật khẩu hiện tại',
              icon: Constants.keyIcon[type],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng điền đầy đủ thông tin';
              }
              return null;
            },
          ),
          TextFormField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            controller: passController,
            decoration: InputDecoration(
              labelText: 'Mật khẩu mới',
              icon: Constants.keyIcon[type],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng điền đầy đủ thông tin';
              }
              return null;
            },
          ),
          TextFormField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            controller: cfPassController,
            decoration: InputDecoration(
              labelText: 'Xác nhận mật khẩu mới',
              icon: Constants.keyIcon[type],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng điền đầy đủ thông tin';
              } else if (value.compareTo(passController!.text) != 0) {
                return 'Vui lòng nhập chính xác mật khẩu';
              }
              return null;
            }
          ),
        ],
      );
    }
    return TextFormField(
      controller: formController,
      decoration: InputDecoration(
        labelText: Constants.keyName[type],
        icon: Constants.keyIcon[type],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng điền đầy đủ thông tin';
        }
        return null;
      },
    );
  }

  validateForm(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {

    }
  }

  showEditDialog({
    required BuildContext context,
    required String type,
    required String text,
    required Function updateDb,
  }) {
    final formController = TextEditingController();
    final passController = TextEditingController();
    final cfPassController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    formController.text = text;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Chỉnh sửa thông tin'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: checkInputForm(context, type, formController, passController, cfPassController),
              ),
            ),
            actions: [
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
                        if (type == AppKeys.password) {
                          final isCorrectPass = await checkCorrectPassword(formController.text);
                          if (isCorrectPass) {
                            await updateDb(context, passController.text);
                          } else {
                            showToastError('Mật khẩu không chính xác');
                          }
                        } else {
                          await updateDb(formController.text);
                          showToastSuccess('Cập nhật thành công');
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    width: 20,
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
              )
            ],
          );
        });
  }
}
