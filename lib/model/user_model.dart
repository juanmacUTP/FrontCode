// ignore_for_file: unused_element

class UserModel {
  final String userId;
  final String userName;
  String userPhone;
  String userOccupation;
  String userAddress;
  final String userPass;

  UserModel(
      {required this.userId,
      required this.userName,
      required this.userPhone,
      required this.userOccupation,
      required this.userAddress,
      required this.userPass});

  UserModel.fromJson(Map<String, dynamic> json)
      : userId = json['id'],
        userName = json['name'],
        userPhone = json['phoneNumber'],
        userAddress = json['address'],
        userOccupation = json['occupation'],
        userPass = json['password_hash'];

  set _userPhone(String phone){
    userPhone = phone;
  }

  set _userAddress(String address){
    userAddress = address;
  }

  set _userOccupation(String occupation){
    userOccupation = occupation;
  }

}
