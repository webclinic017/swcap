import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:swcap/config/api_urls.dart';
import 'package:swcap/model/user/user_model.dart';

class AuthApi {
  
  static Future<UserModel> userLogin(username , password) async {
    
    UserModel thisResponse = UserModel();
    
    final client = http.Client();
    
    try{
      
      final response = await client.post(Uri.parse(ApiUrl.userLoginApiUrl) , body: {
        "username" : username,
        "password" : password
      });

      print({
        "username" : username,
        "password" : password,
      });

      if(response.statusCode == 200){

        if(jsonDecode(response.body)['status']){

          thisResponse = userModelFromJson(response.body);

        }else{
          thisResponse = UserModel(
            status: false,
            data: null
          );
        }

        return thisResponse;

      }else{
        print("Wrong Status Code : ${response.statusCode}");
      }
      
    }catch(e){
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;
    
  }
  
}