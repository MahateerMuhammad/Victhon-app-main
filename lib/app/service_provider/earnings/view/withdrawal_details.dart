import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/app_outline_button.dart';
import 'package:Victhon/widget/textwidget.dart';
import '../../../../utils/functions.dart';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class TransactionDetailsScreen extends StatefulWidget {
  const TransactionDetailsScreen({
    super.key,
    required this.transactionDetails,
  });
  final dynamic transactionDetails;

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        surfaceTintColor: AppColor.whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const TextWidget(
          text: 'Transaction Details',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          RepaintBoundary(
            key: _globalKey,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.transactionDetails["status"] == "success"
                        ? Image.asset(
                            AppIcons.checkMarkBadge,
                            scale: 4,
                          )
                        : widget.transactionDetails["status"] == "pending"
                            ? const CircleAvatar(
                                backgroundColor: AppColor.yellowGold,
                                radius: 24,
                                child: Icon(
                                  Icons.swap_vert,
                                  size: 32,
                                  color: AppColor.whiteColor,
                                ),
                              )
                            : Image.asset(
                                AppIcons.cancelMarkBadge,
                                scale: 4,
                              ),
                    const SizedBox(height: 10),
                    const Text(
                      'Transaction Amount',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    TextWidget(
                      text: formatAsMoney(
                        double.parse(
                            widget.transactionDetails["amount"].toString()),
                      ),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.transactionDetails["transactionType"] ==
                                "withdrawal"
                            ? _transactionDetailRow(
                                'Bank Name',
                                widget.transactionDetails["bankName"],
                              )
                            : _transactionDetailRow(
                                'Sender Name',
                                widget.transactionDetails["senderName"],
                              ),
                        widget.transactionDetails["transactionType"] ==
                                "withdrawal"
                            ? _transactionDetailRow('Account Number',
                                widget.transactionDetails["accountNumber"])
                            : _transactionDetailRow(
                                'Customer Contact', '0123456789'),
                        widget.transactionDetails["transactionType"] ==
                                "withdrawal"
                            ? _transactionDetailRow(
                                'Account Name', 'Olamide Oladehinde')
                            : _transactionDetailRow('Service Name',
                                widget.transactionDetails["serviceName"]),
                        _transactionDetailRow('Transaction Type',
                            widget.transactionDetails["transactionType"]),
                        _transactionDetailRow(
                          'Date',
                          formatDate(widget.transactionDetails["date"]),
                        ),
                        const SizedBox(height: 32),
                        const TextWidget(
                          text: 'Transaction ID',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColor.backgroundYellow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                text:
                                    widget.transactionDetails["transactionId"],
                                fontSize: 16,
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.copy, color: Colors.green),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text: widget.transactionDetails[
                                          "transactionId"]));
                                  Get.snackbar(
                                      'Copied', 'Transaction ID copied');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                    child: AppOutlinedButton(
                  buttonText: "Download Receipt",
                  onPressed: () async {
                    final imageBytes = await _capturePng();
                    if (imageBytes != null) {
                      await _saveImage(imageBytes);
                    }
                  },
                  borderColor: AppColor.primaryColor,
                  textColor: AppColor.primaryColor,
                )),
                const SizedBox(width: 10),
                Expanded(
                    child: AppPrimaryButton(
                  buttonText: "Share Receipt",
                  onPressed: () async {
                    final imageBytes = await _capturePng();
                    if (imageBytes != null) {
                      await _shareImage(imageBytes);
                    }
                  },
                )),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _transactionDetailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: title,
            fontSize: 14,
            color: Colors.grey,
          ),
          if (value is String)
            TextWidget(
              text: value,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )
          else
            value,
        ],
      ),
    );
  }

  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _saveImage(Uint8List bytes) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      Get.snackbar('Permission Denied', 'Storage permission is required.');
      return;
    }

    // Get external storage directory
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final filePath =
        '${directory!.path}/transaction_receipt_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    Get.snackbar("Saved", "Receipt saved to ${file.path}");
  }

  Future<void> _shareImage(Uint8List bytes) async {
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/receipt.png';
    File imgFile = File(imagePath);
    await imgFile.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(imagePath)], text: 'Transaction Receipt');
  }
}
