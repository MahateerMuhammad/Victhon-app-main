import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/remote_services/remote_services.dart';

class EarningsController extends GetxController {
  final isLoading = false.obs;

  RxList<dynamic> transactionDetails = <dynamic>[].obs;
  RxInt walletBalance = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransaction();
  }

  Future<void> fetchTransaction() async {
    isLoading(true);
    print("heyyyyyyyy fetch transaction");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? savedTransactionDetails = prefs.getString("cached_transaction");
    int? savedWalletAmount = prefs.getInt("cached_walletAmount");
    if (savedTransactionDetails != null) {
      transactionDetails.value =
          List<dynamic>.from(json.decode(savedTransactionDetails)).toList();
      walletBalance.value = savedWalletAmount ?? 0;
    }

    // Fetch new services from API
    final response = await RemoteServices().getTransaction();
    // print("@@@@@@@@@@ ${response["data"]} @@@@@@@@@@");
    print("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");
    isLoading(false);

    if (response is Map<String, dynamic>) {
      transactionDetails.value = response["data"];
      walletBalance.value = response["walletBalance"];
      await prefs.setInt("cached_walletAmount", response["walletBalance"]);
      await prefs.setString(
          "cached_transaction", json.encode(response["data"]));
    }
    // else {
    //   // Check if services exist in local storage
    //   String? savedTransactionDetails = prefs.getString("cached_transaction");
    //   if (savedTransactionDetails != null) {
    //     transactionDetails.value =
    //         List<dynamic>.from(json.decode(savedTransactionDetails)).toList();
    //   }
    // }
  }
}
