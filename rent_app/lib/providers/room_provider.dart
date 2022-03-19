import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/models/room.dart';
import 'package:rent_app/providers/user_provider.dart';
import 'package:rent_app/utils/firebase_helper.dart';

class RoomProvider extends ChangeNotifier {
  final List<Room> _listOfRoom = [];

  List<Room> get listOfRoom {
    return _listOfRoom;
  }

  fetchRoom(BuildContext context) async {
    try {
      final uuid = Provider.of<UserProvider>(context, listen: false).user.uuid;
      final data = await FirebaseHelper().getData(
        collectionId: RoomConstant.roomCollection,
        whereId: UserConstants.userId,
        whereValue: uuid,
      );
      if (data.docs.length != _listOfRoom.length) {
        _listOfRoom.clear();
        for (var element in data.docs) {
          // print(element.data())
          _listOfRoom.add(Room.fromJson(element.data(), element.id));
        }
      }
    } catch (ex) {
      print(ex.toString());
      throw ex.toString();
    }
  }

  addRoom(BuildContext context, String name) async {
    try {
      final uuid = Provider.of<UserProvider>(context, listen: false).user.uuid;

      final map = Room(name: name, uuid: uuid).toJson();

      await FirebaseHelper().addData(
        context,
        map: map,
        collectionId: RoomConstant.roomCollection,
      );
    } catch (ex) {
      print(ex.toString());
      throw ex.toString();
    }
  }

  updateRoom(
    BuildContext context, {
    required String newRoomName,
    required String roomId,
  }) async {
    try {
      final map = {
        "name": newRoomName,
      };

      await FirebaseHelper().updateData(
        context,
        map: map,
        docId: roomId,
        collectionId: RoomConstant.roomCollection,
      );

      final room = _listOfRoom.firstWhere((element) => element.id == roomId);
      room.name = newRoomName;
      notifyListeners();
    } catch (ex) {
      throw ex.toString();
    }
  }
}
