
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spending_management/repository/analytic_repository.dart';
import 'package:spending_management/repository/auth_repository.dart';
import 'package:spending_management/repository/general_repository.dart';
import 'package:spending_management/repository/profile_repository.dart';
import 'package:spending_management/repository/spending_repository.dart';
import 'package:spending_management/repository/user_repository.dart';

class DataManager {
  static DataManager instance = DataManager._getInstance();
  DataManager._getInstance();

  SharedPreferences? _sharedPref;

  final String keyUserId = 'key_user_id';

  String? userId;

  getSharedPreferences() async {
    _sharedPref ??= await SharedPreferences.getInstance();
    return _sharedPref;
  }

  setCurrentUserId(String id) async {
    SharedPreferences sharedPreferences = await getSharedPreferences();
    sharedPreferences.setString(keyUserId, id);
  }

  getCurrentUserId() async {
    SharedPreferences sharedPreferences = await getSharedPreferences();
    userId = sharedPreferences.getString(keyUserId);
    return userId;
  }

  removeCurrentUserId() async {
    SharedPreferences sharedPreferences = await getSharedPreferences();
    sharedPreferences.remove(keyUserId);
  }

}