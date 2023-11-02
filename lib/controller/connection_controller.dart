import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:s_distribuidos/model/user_model.dart';


class ConnectionController {
  static String? token = '';
  static DateTime? accessTokenExpiration;

 /* static void test() async {
    final url = Uri.parse('http://146.190.117.195:5000/api/test');

    var response = await http.get(url);

    print(response.body);
  }
*/
  static Future<int> signUp(String name, String id, String password,
      String phone, String address, String occupation) async {
    final url = Uri.parse('http://146.190.117.195:5000/api/signup');

    final json = jsonEncode({
      'name': name,
      'id': id,
      'password': password,
      'phoneNumber': phone,
      'address': address,
      'occupation': occupation
    });

    var response = await http.post(url,
        headers: {'Content-type': 'application/json'}, body: json);
    return response.statusCode;
  }

  static Future<int> signIn(String id, String password) async {
    final url = Uri.parse('http://146.190.117.195:5000/api/login');

    final json = jsonEncode({
      'id': id,
      'password': password,
    });

    var response = await http.post(url,
        headers: {'Content-type': 'application/json'}, body: json);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      token = responseData['access_token'];
      accessTokenExpiration = DateTime.now().add(const Duration(minutes: 5));
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  static Future<http.Response> getAllUsers() async {
    final url = Uri.parse('http://146.190.117.195:5000/api/users');

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return response;
  }

  static Future<http.Response> getUser(String userId) async{
    final url = Uri.parse('http://146.190.117.195:5000/api/$userId');

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return response;

  }

  static Future<int> updateUser(UserModel user) async {
    final url = Uri.parse('http://146.190.117.195:5000/api/${user.userId}');

    final json = jsonEncode({
      'address': user.userAddress,
      'phoneNumber': user.userPhone,
      'occupation': user.userOccupation
    });

    if (accessTokenExpiration != null && DateTime.now().isAfter(accessTokenExpiration!)) {
      token = null;
      accessTokenExpiration = null;
      return -1;
    }else{
      final response = await http.put(url,
          headers: {'Authorization': 'Bearer $token', 'Content-type': 'application/json'}, body: json);
      return response.statusCode;
    }
  }



  static Future<int> deleteUser(UserModel user) async {
    final url = Uri.parse('http://146.190.117.195:5000/api/${user.userId}');

    if (accessTokenExpiration != null && DateTime.now().isAfter(accessTokenExpiration!)) {
      token = null;
      accessTokenExpiration = null;
      return -1;
    }else{
      final response = await http.delete(url,
          headers: {'Authorization': 'Bearer $token'});
      return response.statusCode;
    }
  }


  static deleteToken() {
    token = null;
    accessTokenExpiration = null;

  }
}

