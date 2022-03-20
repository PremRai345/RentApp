import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/models/room.dart';
import 'package:rent_app/models/room_rent.dart';
import 'package:rent_app/providers/room_rent_provider.dart';
import 'package:rent_app/utils/pdf_helper.dart';
import 'package:rent_app/utils/size_config.dart';
import 'package:rent_app/utils/validation_mixin.dart';
import 'package:rent_app/widgets/curved_body_widget.dart';
import 'package:rent_app/widgets/general_alert_dialog.dart';
import 'package:rent_app/widgets/general_table_row.dart';
import 'package:rent_app/widgets/general_text_field.dart';

class RentHistoryScreen extends StatelessWidget {
  const RentHistoryScreen({required this.model, Key? key}) : super(key: key);

  final RoomRent model;

  @override
  Widget build(BuildContext context) {
    final tableRow = GeneralTableRow();
    return Scaffold(
      appBar: AppBar(
        title: Text(model.month),
        actions: [
          InkWell(
            onTap: () async {
              final helper = PdfHelper();
              final pdf = helper.createPdf(context, model: model);
              await helper.savePdf(pdf: pdf, month: model.month);
            },
            child: Container(
              margin: EdgeInsets.only(right: SizeConfig.width * 2),
              child: Image.asset(
                ImageConstants.pdfDownload,
                height: SizeConfig.height,
                width: SizeConfig.width * 10,
              ),
            ),
          ),
        ],
      ),
      body: CurvedBodyWidget(
        widget: Padding(
          padding: EdgeInsets.symmetric(
            // horizontal: SizeConfig.width * 2/,
            vertical: SizeConfig.height,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.width * 2,
                      vertical: SizeConfig.height,
                    ),
                    child: Table(
                      children: [
                        tableRow.buildTableRow(
                          context,
                          title: "Month",
                          isAmount: false,
                          month: model.month,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Electricity Units Used",
                          amount: model.electricityUnits,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Electricity Per Unit Price",
                          amount: model.electricityUnitPrice,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Electricity Total Price",
                          amount: model.electricityTotalPrice,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Water Fee",
                          amount: model.waterFee,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Internet Fee",
                          amount: model.internetFee,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Rent Amount",
                          amount: model.rentAmount,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Total Amount",
                          amount: model.totalAmount,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Paid Amount",
                          amount: model.paidAmount,
                        ),
                        tableRow.buildTableDivider(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Remaining Amount",
                          amount: model.remainingAmount,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                PayRemainingAmountForm(model: model),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PayRemainingAmountForm extends StatelessWidget {
  PayRemainingAmountForm({required this.model, Key? key}) : super(key: key);

  final amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RoomRent model;

  @override
  Widget build(BuildContext context) {
    amountController.text = model.remainingAmount.toString();
    return Form(
      key: formKey,
      child: Column(
        children: [
          GeneralTextField(
            title: "Pay Remaining Amount",
            controller: amountController,
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.done,
            validate: (value) => ValidationMixin().validateNumber(
                value!, "remaining amount", model.remainingAmount),
            onFieldSubmitted: (_) {
              submit(context);
            },
          ),
          SizedBox(
            height: SizeConfig.height,
          ),
          ElevatedButton(
            onPressed: () {
              submit(context);
            },
            child: const Text("Pay"),
          ),
        ],
      ),
    );
  }

  submit(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      GeneralAlertDialog().customLoadingDialog(context);
      final paidAmount = double.parse(amountController.text);
      await Provider.of<RoomRentProvider>(context, listen: false)
          .updateRoomRent(
        context,
        docId: model.roomRentId!,
        paidAmount: model.paidAmount + paidAmount,
        remainingAmount: model.remainingAmount - paidAmount,
      );
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (ex) {
      Navigator.pop(context);
      GeneralAlertDialog().customAlertDialog(context, ex.toString());
    }
  }
}
