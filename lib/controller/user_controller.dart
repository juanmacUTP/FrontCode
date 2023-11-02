import '../model/user_model.dart';
import 'connection_controller.dart';
import 'dart:convert';

class UserController{
  static List<UserModel> usersList = [];

  static Future<int> addUsersFromDB() async{
    final response = await ConnectionController.getAllUsers();


    if (ConnectionController.accessTokenExpiration != null && DateTime.now().isAfter(ConnectionController.accessTokenExpiration!)){
      ConnectionController.deleteToken();
      return -1;
    }else {
      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        for (var data in responseData){
          usersList.add(UserModel.fromJson(data));
        }
      }

      return response.statusCode;
    }
}

  static Future<int> searchUserFromDB(String userId) async {
    final response = await ConnectionController.getUser(userId);


    if (ConnectionController.accessTokenExpiration != null &&
        DateTime.now().isAfter(ConnectionController.accessTokenExpiration!)) {
      ConnectionController.deleteToken();
      return -1;
    } else {
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
          usersList.add(UserModel.fromJson(responseData));

      }

      return response.statusCode;
    }
  }

  static cleanUserList(){
    usersList.clear();
  }

}