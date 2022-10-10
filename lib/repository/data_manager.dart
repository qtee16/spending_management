
import 'package:shared_preferences/shared_preferences.dart';

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