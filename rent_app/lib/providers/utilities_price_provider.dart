import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/models/utilities_price.dart';
import 'package:rent_app/providers/user_provider.dart';
import 'package:rent_app/utils/firebase_helper.dart';

class UtilitiesPriceProvider extends ChangeNotifier {
  UtilitiesPrice? _utilitiesPrice;

  UtilitiesPrice? get utilitiesPrice => _utilitiesPrice;

  Future fetchPrice(BuildContext context) async {
    try {
      final uuid = Provider.of<UserProvider>(context, listen: false).user.uuid;
      final data = await FirebaseHelper().getData(
          collectionId: UtilitiesPriceConstant.utilityPriceCollection,
          whereId: UserConstants.userId,
          whereValue: uuid);
      if (data.docs.isNotEmpty) {
        _utilitiesPrice = UtilitiesPrice.fromJson(data.docs.first.data());
      }
    } catch (ex) {
      print(ex.toString());
    }
  }
}
