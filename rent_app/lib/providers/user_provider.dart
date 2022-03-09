import 'package:flutter/cupertino.dart';
import 'package:rent_app/models/user.dart';

class UserProvider extends ChangeNotifier {
  late User _user;

  setUser(Map obj) {
    _user = User.fromJson(obj);
    notifyListeners();
  }

  User get user => _user;

  Map<String, dynamic> updateUser(
      {required String name, required String address, required int age}) {
    _user = User(
      uuid: _user.uuid,
      email: _user.email,
      name: name,
      address: address,
      age: age,
      image: null,
      photoUrl: null,
    );
    notifyListeners();
    return _user.toJson();
  }

  updateUserImage(String image) {
    _user.image = image;
    notifyListeners();
  }
}
