import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/main.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../widget/textwidget.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({
    super.key,
    required this.url,
  });
  final String url;

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    print("@@@@@@ ${widget.url}");

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          print("------------------ ${request.url}");
          if (request.url.startsWith('https://')) {
            // Handle the redirect here
            Get.back();
            box.write("isPaymentSuccess", true);
            // _handlePaymentRedirect(request.url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        surfaceTintColor: AppColor.whiteColor,
        centerTitle: true,
        title: const TextWidget(
          text: "Payment",
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (loadingPercentage < 100)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: LinearProgressIndicator(
                color: AppColor.primaryColor,
                value: loadingPercentage / 100.0,
              ),
            ),
        ],
      ),
    );
  }
}