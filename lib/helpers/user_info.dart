import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  Future setToken(String value) async {
    var pref = await SharedPreferences.getInstance();
    return pref.setString("token", value);
  }

  Future<String?> getToken() async {
    var pref = await SharedPreferences.getInstance();

    return pref.getString("token");
  }

  Future setUserID(int value) async {
    var pref = await SharedPreferences.getInstance();

    return pref.setInt("userID", value);
  }

  Future<int?> getUserID() async {
    var pref = await SharedPreferences.getInstance();

    return pref.getInt("userID");
  }

  Future logout() async {
    var pref = await SharedPreferences.getInstance();

    pref.clear();
  }
}