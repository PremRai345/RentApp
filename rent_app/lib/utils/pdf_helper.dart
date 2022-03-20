import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:rent_app/models/room_rent.dart';

class PdfHelper {
  pw.Document createPdf(
    BuildContext context, {
    required RoomRent model,
  }) {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context _) {
          return pw.Column(
            children: [
              pw.Center(
                child: pw.Text("Rent Invoice",
                    style: const pw.TextStyle(
                      fontSize: 20,
                    )),
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Table(
                children: [
                  _buildTableRow(
                    context,
                    title: "Month",
                    isAmount: false,
                    month: model.month,
                  ),
                  _buildTableSpacer(context),
                  _buildTableRow(
                    context,
                    title: "Electricity Units Used",
                    amount: model.electricityUnits,
                  ),
                  _buildTableSpacer(context),
                  _buildTableRow(
                    context,
                    title: "Electricity Per Unit Price",
                    amount: model.electricityUnitPrice,
                  ),
                  _buildTableSpacer(context),
                  _buildTableRow(
                    context,
                    title: "Electricity Total Price",
                    amount: model.electricityTotalPrice,
                  ),
                  _buildTableSpacer(context),
                  _buildTableRow(
                    context,
                    title: "Water Fee",
                    amount: model.waterFee,
                  ),
                  _buildTableSpacer(context),
                  _buildTableRow(
                    context,
                    title: "Internet Fee",
                    amount: model.internetFee,
                  ),
                  _buildTableSpacer(context),
                  _buildTableRow(
                    context,
                    title: "Rent Amount",
                    amount: model.rentAmount,
                  ),
                  _buildTableSpacer(context),
                  _buildTableRow(
                    context,
                    title: "Total Amount",
                    amount: model.totalAmount,
                  ),
                  _buildTableSpacer(context),
                  _buildTableRow(
                    context,
                    title: "Paid Amount",
                    amount: model.paidAmount,
                  ),
                  _buildTableDivider(context),
                  _buildTableRow(
                    context,
                    title: "Remaining Amount",
                    amount: model.remainingAmount,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
    return pdf;
  }

  pw.TableRow _buildTableSpacer(BuildContext context) {
    return pw.TableRow(children: [
      pw.SizedBox(
        height: 10,
      ),
      pw.SizedBox(height: 10),
    ]);
  }

  pw.TableRow _buildTableDivider(BuildContext context) {
    return pw.TableRow(children: [
      pw.Divider(
        thickness: 1,
      ),
      pw.Divider(
        thickness: 1,
      ),
    ]);
  }

  pw.TableRow _buildTableRow(
    BuildContext context, {
    required String title,
    double? amount,
    String? month,
    bool isAmount = true,
  }) {
    return pw.TableRow(
      children: [
        pw.Text(
          title,
          style: const pw.TextStyle(
            fontSize: 14,
          ),
        ),
        pw.Text(
          isAmount ? "Rs. $amount" : month!,
          textAlign: pw.TextAlign.right,
          style: const pw.TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  savePdf({
    required pw.Document pdf,
    required String month,
  }) async {
    final directory = await getApplicationSupportDirectory();
    directory.path;
    final file = File(
        "${directory.path}/$month-${DateFormat("yyyy-MM-dd").format(DateTime.now())}");
    await file.writeAsBytes(await pdf.save());
    print("object");
    await OpenFile.open(file.path);
    // await file.open();
  }
}
