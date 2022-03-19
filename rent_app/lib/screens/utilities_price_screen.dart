import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/models/utilities_price.dart';
import 'package:rent_app/providers/utilities_price_provider.dart';

import '/constants/constants.dart';
import '/providers/user_provider.dart';
import '/utils/firebase_helper.dart';
import '/utils/size_config.dart';
import '/utils/validation_mixin.dart';
import '/widgets/curved_body_widget.dart';
import '/widgets/general_alert_dialog.dart';
import '/widgets/general_text_field.dart';

class UtilitiesPriceScreen extends StatelessWidget {
  UtilitiesPriceScreen({Key? key}) : super(key: key);

  final electricityUnitController = TextEditingController();
  final waterFeeController = TextEditingController();
  final internetFeeController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // final future = Provider.of<UtilitiesPriceProvider>(context, listen: true)
    //     .fetchPrice(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Utilities Price"),
      ),
      body: CurvedBodyWidget(
        widget: SingleChildScrollView(
          child: FutureBuilder(
              future: Provider.of<UtilitiesPriceProvider>(context, listen: true)
                  .fetchPrice(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final utilityPriceProvider =
                    Provider.of<UtilitiesPriceProvider>(context).utilitiesPrice;
                if (utilityPriceProvider != null) {
                  electricityUnitController.text =
                      utilityPriceProvider.electricityUnitPrice.toString();
                  waterFeeController.text =
                      utilityPriceProvider.waterFee.toString();
                  internetFeeController.text =
                      utilityPriceProvider.internetFee.toString();
                }
                return Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Set your utilities price!",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: SizeConfig.height * 2,
                      ),
                      Text(
                        "Electricity unit",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      SizedBox(
                        height: SizeConfig.height,
                      ),
                      GeneralTextField(
                        title: "Electricity unit",
                        controller: electricityUnitController,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validate: (value) => ValidationMixin().validateNumber(
                            value!, "electricity unit price", 100),
                        onFieldSubmitted: (_) {},
                      ),
                      SizedBox(
                        height: SizeConfig.height * 2,
                      ),
                      Text(
                        "Water Fee",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      SizedBox(
                        height: SizeConfig.height,
                      ),
                      GeneralTextField(
                        title: "Water Fee",
                        controller: waterFeeController,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validate: (value) => ValidationMixin().validateNumber(
                          value!,
                          "water fee",
                          10000,
                        ),
                        onFieldSubmitted: (_) {},
                      ),
                      SizedBox(
                        height: SizeConfig.height * 2,
                      ),
                      Text(
                        "Internet Fee",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      SizedBox(
                        height: SizeConfig.height,
                      ),
                      GeneralTextField(
                        title: "Internet Fee",
                        controller: internetFeeController,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        validate: (value) => ValidationMixin().validateNumber(
                          value!,
                          "internet fee",
                          10000,
                        ),
                        onFieldSubmitted: (_) {
                          submit(context);
                        },
                      ),
                      SizedBox(
                        height: SizeConfig.height * 2,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => submit(context),
                          child: const Text("Submit"),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  submit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        final uid = Provider.of<UserProvider>(context, listen: false).user.uuid;
        final map = UtilitiesPrice(
          electricityUnitPrice: double.parse(electricityUnitController.text),
          waterFee: double.parse(waterFeeController.text),
          internetFee: double.parse(internetFeeController.text),
          uuid: uid,
        ).toJson();
        await FirebaseHelper().addOrUpdateContent(
          context,
          collectionId: UtilitiesPriceConstant.utilityPriceCollection,
          whereId: UserConstants.userId,
          whereValue: uid,
          map: map,
        );
      } catch (ex) {
        GeneralAlertDialog().customAlertDialog(context, ex.toString());
      }
    }
  }
}
