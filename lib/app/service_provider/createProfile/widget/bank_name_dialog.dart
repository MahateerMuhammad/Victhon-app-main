import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/createProfile/controller/provider_create_profile_controller.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widget/textwidget.dart';

class BankNameTextfield extends StatefulWidget {
  const BankNameTextfield({super.key});

  @override
  State<BankNameTextfield> createState() => _BankNameTextfieldState();
}

class _BankNameTextfieldState extends State<BankNameTextfield> {
  final createProfileController = Get.put(ProviderCreateProfileController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("=== BANK NAME TEXTFIELD TAPPED ===");
        print("Current selected bank: ${createProfileController.selectedBank}");
        
        // Test API directly for debugging
        createProfileController.testBanksApi();
        
        showSelectBankDialog(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.primaryCardColor,
        ),
        child: Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              createProfileController.selectedBank.isEmpty
                  ? const SizedBox()
                  : CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      child: TextWidget(
                        text: createProfileController.selectedBank['bankName']
                            .toString()
                            .substring(0, 1),
                      ),
                      // backgroundImage: CachedNetworkImageProvider(
                      //   createProfileController.selectedBank['name'],
                      //   errorListener: (error) => const Icon(
                      //     Icons.person,
                      //     color: AppColor.whiteColor,
                      //   ),
                      // ),
                    ),
              const SizedBox(
                width: 8,
              ),
              createProfileController.selectedBank.isEmpty
                  ? const TextWidget(
                      text: "Bank Name",
                      color: Colors.grey,
                    )
                  : TextWidget(
                      text: createProfileController.selectedBank["bankName"],
                    ),
              const Spacer(),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 25,
              )
            ],
          ),
        ),
      ),
    );
  }
}

void showSelectBankDialog(BuildContext context) {
  print("=== OPENING BANK SELECTION DIALOG ===");
  final createProfileController = Get.find<ProviderCreateProfileController>();
  print("Available banks when opening dialog: ${createProfileController.bankDetails.length}");
  print("Current selected bank: ${createProfileController.selectedBank}");
  
  // If no banks are loaded, try to fetch them again
  if (createProfileController.bankDetails.isEmpty) {
    print("⚠️ No banks available - triggering fetchAllBanks again");
    createProfileController.fetchAllBanks();
  }
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return const SelectBankDialog();
    },
  );
}

class SelectBankDialog extends StatefulWidget {
  const SelectBankDialog({super.key});

  @override
  State<SelectBankDialog> createState() => _SelectBankDialogState();
}

class _SelectBankDialogState extends State<SelectBankDialog> {
  final createProfileController = Get.put(ProviderCreateProfileController());

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    print("=== BANK DIALOG BUILD DEBUG ===");
    print("Total banks available: ${createProfileController.bankDetails.length}");
    print("Search query: '$searchQuery'");
    
    List<dynamic> filteredBanks = createProfileController.bankDetails
        .where((bank) =>
            bank['bankName']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    
    print("Filtered banks count: ${filteredBanks.length}");
    if (filteredBanks.isNotEmpty) {
      print("First few filtered banks:");
      for (int i = 0; i < filteredBanks.length && i < 3; i++) {
        print("  Bank $i: ${filteredBanks[i]['bankName']}");
      }
    }
    print("=== END BANK DIALOG BUILD DEBUG ===");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Bank",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Search Field
                SizedBox(
                  height: 45,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search Bank Name",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: false,
                      contentPadding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(8),
                      //   borderSide:
                      //       BorderSide(color: AppColor.primaryColor.shade300),
                      // ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: AppColor.primaryColor.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: AppColor.primaryColor.shade300),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 32,
            color: AppColor.primaryCardColor,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: TextWidget(text: "A"),
            ),
          ),
          const SizedBox(height: 16),

          // Bank List
          Expanded(
            child: ListView.builder(
              itemCount: filteredBanks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    child: TextWidget(
                      text: filteredBanks[index]['bankName']
                          .toString()
                          .substring(0, 1),
                    ),
                    // CachedNetworkImageProvider(
                    //   filteredBanks[index]['name'],
                    //   errorListener: (error) => const Icon(
                    //     Icons.person,
                    //     color: AppColor.whiteColor,
                    //   ),
                    // ),
                  ),
                  title: Text(
                    filteredBanks[index]['bankName']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    // Enhanced debug prints for bank selection
                    print("=== BANK SELECTION DEBUG ===");
                    print("Selected Bank Index: $index");
                    print("Selected Bank Object: ${filteredBanks[index]}");
                    print("Bank Name: ${filteredBanks[index]['bankName']}");
                    print("Bank Code: ${filteredBanks[index]['bankCode'] ?? 'No code'}");
                    
                    createProfileController.selectedBank.value =
                        filteredBanks[index];
                    
                    print("Controller selectedBank after assignment: ${createProfileController.selectedBank}");
                    print("Selected Bank Name from Controller: ${createProfileController.selectedBank['bankName']}");
                    print("=== END BANK SELECTION DEBUG ===");

                    Navigator.pop(context, filteredBanks[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
