import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/models/room_rent.dart';
import 'package:rent_app/providers/utilities_price_provider.dart';
import 'package:rent_app/utils/firebase_helper.dart';
import 'package:rent_app/utils/show_toast_message.dart';

class RoomRentProvider extends ChangeNotifier {
  final List<RoomRent> _roomRentList = [];

  List<RoomRent> get roomRentList => _roomRentList;

  fetchRoomRent(
    BuildContext context, {
    required String roomId,
  }) async {
    try {
      final data = await FirebaseHelper().getData(
          collectionId: RoomRentConstant.roomRentCollection,
          whereId: RoomRentConstant.roomId,
          whereValue: roomId);
      // print(data.docs);
      if (_roomRentList.length != data.docs.length) {
        _roomRentList.clear();
        for (var element in data.docs) {
          _roomRentList.add(RoomRent.fromJson(element.data(), element.id));
        }
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  addRoomRent(
    BuildContext context, {
    required String roomId,
    required String electricityUnitText,
    required String rentAmountText,
    required String month,
  }) async {
    try {
      final utilityProvider =
          Provider.of<UtilitiesPriceProvider>(context, listen: false);
      await utilityProvider.fetchPrice(context);
      final utilityPrice = utilityProvider.utilitiesPrice;
      if (utilityPrice == null) {
        showToast("Please enter utilities price for your home");
      } else {
        final electricityUnits = double.parse(electricityUnitText);
        final electricityPrice =
            electricityUnits * utilityPrice.electricityUnitPrice;
        final rentAmount = double.parse(rentAmountText);
        final sum = rentAmount +
            electricityPrice +
            utilityPrice.internetFee +
            utilityPrice.waterFee;
        final map = RoomRent(
                month: month,
                roomId: roomId,
                electricityUnits: electricityUnits,
                electricityUnitPrice: utilityPrice.electricityUnitPrice,
                electricityTotalPrice: electricityPrice,
                waterFee: utilityPrice.waterFee,
                internetFee: utilityPrice.internetFee,
                rentAmount: rentAmount,
                totalAmount: sum,
                paidAmount: 0,
                remainingAmount: sum)
            .toJson();
        await FirebaseHelper().addData(context,
            collectionId: RoomRentConstant.roomRentCollection, map: map);
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  updateRoomRent(
    BuildContext context, {
    required String docId,
    required double paidAmount,
    required double remainingAmount,
  }) async {
    final map = {
      "paidAmount": paidAmount,
      "remainingAmount": remainingAmount,
    };
    await FirebaseHelper().updateData(context,
        collectionId: RoomRentConstant.roomRentCollection,
        docId: docId,
        map: map);

    final room =
        _roomRentList.firstWhere((element) => element.roomRentId! == docId);
    room.paidAmount = paidAmount;
    room.remainingAmount = remainingAmount;
    final index = _roomRentList.indexOf(room);
    _roomRentList.removeAt(index);
    _roomRentList.insert(index, room);

    notifyListeners();
  }
}
