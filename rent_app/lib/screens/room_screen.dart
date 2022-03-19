import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/models/room.dart';
import 'package:rent_app/models/room_rent.dart';
import 'package:rent_app/providers/room_rent_provider.dart';
import 'package:rent_app/screens/rent_history_screen.dart';
import 'package:rent_app/utils/navigate.dart';
import 'package:rent_app/utils/show_toast_message.dart';
import 'package:rent_app/utils/size_config.dart';
import 'package:rent_app/utils/validation_mixin.dart';
import 'package:rent_app/widgets/curved_body_widget.dart';
import 'package:rent_app/widgets/general_alert_dialog.dart';
import 'package:rent_app/widgets/general_drop_down.dart';
import 'package:rent_app/widgets/general_table_row.dart';
import 'package:rent_app/widgets/general_text_field.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({required this.room, Key? key}) : super(key: key);

  final Room room;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  bool showForm = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
        actions: [
          IconButton(
              onPressed: () => setState(() => showForm = !showForm),
              icon: Icon(
                  showForm ? Icons.receipt_long_outlined : Icons.add_outlined))
        ],
      ),
      body: CurvedBodyWidget(
          widget: SingleChildScrollView(
        child: showForm
            ? FormWidget(
                roomId: widget.room.id!,
              )
            : Histories(
                roomId: widget.room.id!,
              ),
      )),
    );
  }
}

class FormWidget extends StatelessWidget {
  FormWidget({required this.roomId, Key? key}) : super(key: key);

  final String roomId;

  final rentAmountController = TextEditingController();
  final electricityUnitsController = TextEditingController();
  final monthController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Month"),
          GeneralDropDown(monthController),
          SizedBox(
            height: SizeConfig.height,
          ),
          const Text("Rent Amount"),
          GeneralTextField(
            title: "Rent Amount",
            controller: rentAmountController,
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validate: (value) => ValidationMixin()
                .validateNumber(value!, "rent amount", 1000000),
            onFieldSubmitted: (_) {},
          ),
          SizedBox(
            height: SizeConfig.height,
          ),
          const Text("Units of electricity Used"),
          GeneralTextField(
            title: "Units of electricity used",
            controller: electricityUnitsController,
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.done,
            validate: (value) => ValidationMixin().validateNumber(
              value!,
              "units of electricity used",
              100,
            ),
            onFieldSubmitted: (_) {},
          ),
          SizedBox(
            height: SizeConfig.height * 2,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                // totalAmountController.text
                if (formKey.currentState!.validate()) {
                  if (monthController.text.isEmpty) {
                    showToast("Please select a month");
                    return;
                  }
                  try {
                    GeneralAlertDialog().customLoadingDialog(context);
                    await Provider.of<RoomRentProvider>(context, listen: false)
                        .addRoomRent(context,
                            roomId: roomId,
                            electricityUnitText:
                                electricityUnitsController.text,
                            month: monthController.text,
                            rentAmountText: rentAmountController.text);
                    Navigator.pop(context);
                  } catch (ex) {
                    print(ex.toString());
                    Navigator.pop(context);
                    GeneralAlertDialog()
                        .customAlertDialog(context, ex.toString());
                  }
                }
              },
              child: const Text("Save"),
            ),
          )
        ],
      ),
    );
  }
}

class Histories extends StatelessWidget {
  const Histories({required this.roomId, Key? key}) : super(key: key);

  final String roomId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Histories",
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(
          height: SizeConfig.height,
        ),
        FutureBuilder(
            future: Provider.of<RoomRentProvider>(context, listen: false)
                .fetchRoomRent(context, roomId: roomId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              final roomRentList = Provider.of<RoomRentProvider>(
                context,
              ).roomRentList;
              return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                        height: SizeConfig.height,
                      ),
                  itemCount: roomRentList.length,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    return buildTableCard(context, roomRentList[index]);
                  });
            }),
      ],
    );
  }

  Widget buildTableCard(BuildContext context, RoomRent model) {
    final tableRow = GeneralTableRow();
    return InkWell(
      onTap: () => navigate(
        context,
        RentHistoryScreen(model: model),
      ),
      child: Card(
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
                title: "Total Amount",
                amount: model.totalAmount,
              ),
              tableRow.buildTableSpacer(context),
              tableRow.buildTableRow(
                context,
                title: "Paid Amount",
                amount: model.paidAmount,
              ),
              tableRow.buildTableSpacer(context),
              tableRow.buildTableRow(
                context,
                title: "Remaining Amount",
                amount: model.remainingAmount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
