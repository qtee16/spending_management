import 'package:flutter/material.dart';
import 'package:spending_management/repository/auth_repository.dart';
import 'package:spending_management/repository/data_manager.dart';
import 'package:spending_management/views/main/main_screen.dart';

final AuthRepository _authRepo = AuthRepository.authRepository;
DataManager dataManager = DataManager.instance;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cfPassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Đăng ký',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Họ tên',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng điền đầy đủ thông tin';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng điền đầy đủ thông tin';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mật khẩu',
                  ),validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng điền đầy đủ thông tin';
                  }
                  return null;
                },

                ),
                const SizedBox(
                  height: 32,
                ),
                TextFormField(
                  controller: cfPassController,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Xác nhận mật khẩu',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng điền đầy đủ thông tin';
                    } else if (value.compareTo(passwordController.text) != 0) {
                      return 'Vui lòng nhập chính xác mật khẩu';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String name = nameController.text.trim();
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();
                      await _authRepo.registerWithEmailAndPassword(name, email, password);
                      var currentUserId = await dataManager.getCurrentUserId();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen(currentUserId: currentUserId,)));
                    }
                  },
                  child: const Text('Đăng ký'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
