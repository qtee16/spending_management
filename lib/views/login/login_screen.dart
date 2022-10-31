import 'package:flutter/material.dart';
import 'package:spending_management/repository/auth_repository.dart';
import 'package:spending_management/repository/data_manager.dart';
import 'package:spending_management/utils/utils.dart';

import '../main/main_screen.dart';

DataManager dataManager = DataManager.instance;
final _authRepo = AuthRepository.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                  'Đăng nhập',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
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
                  controller: passwordController,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mật khẩu',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng điền đầy đủ thông tin';
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
                      var email = emailController.text.trim();
                      var password = passwordController.text.trim();
                      await _authRepo.loginWithEmailAndPassword(email, password);
                      var currentUserId = await dataManager.getCurrentUserId();
                      if (currentUserId != null) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen(currentUserId: currentUserId,)));
                      } else {
                        showToastError('Tài khoản không tồn tại');
                      }

                    }
                  },
                  child: const Text('Đăng nhập'),
                ),
                const SizedBox(
                  height: 20,
                ),
                // TextButton(
                //     onPressed: () {
                //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterScreen()));
                //     },
                //     child: const Text(
                //       'Đăng ký',
                //       style: TextStyle(decoration: TextDecoration.underline),
                //     ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
