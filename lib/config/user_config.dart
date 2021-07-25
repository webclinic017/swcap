import 'package:shared_preferences/shared_preferences.dart';
import 'package:swcap/model/user/user_model.dart';

class UserConfig {

  static setUserSession(UserModel user) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isLogged", true);
    pref.setString("userID", user.data.id ?? "");
    pref.setString("userName", user.data.name ?? "");
    pref.setString("userUserName", user.data.username);
    pref.setString("userPassword", user.data.password);
    pref.setString("userMobile", user.data.mobileNumber);
    pref.setString("userShowAccount", user.data.showAccount);

  }

  static unsetUserSession() async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isLogged", false);
    pref.remove("userID");
    pref.remove("userName");
    pref.remove("userUserName");
    pref.remove("UserPassword");
    pref.remove("userMobile");
    pref.remove("userShowAccount");

  }

}