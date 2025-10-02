// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:victhon/app/service_provider/profile/view/change_password.dart';
// import '../../../../config/theme/app_color.dart';
// import '../../../../widget/textwidget.dart';

// class LoginSettings extends StatefulWidget {
//   const LoginSettings({super.key});

//   @override
//   State<LoginSettings> createState() => _LoginSettingsState();
// }

// class _LoginSettingsState extends State<LoginSettings> {
//   bool biometricLogin = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.whiteColor,
//       appBar: AppBar(
//         title: const TextWidget(
//           text: 'Login Setting',
//           fontSize: 18,
//           fontWeight: FontWeight.w500,
//         ),
//         centerTitle: true,
//         backgroundColor: AppColor.whiteColor,
//         surfaceTintColor: AppColor.whiteColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 24,
//               ),
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     color: AppColor.primaryCardColor,
//                     borderRadius: BorderRadius.circular(8)),
//                 child: Column(
//                   children: [
//                     ListTile(
//                       leading: const Icon(LucideIcons.key,
//                           color: AppColor.primaryColor),
//                       title: const Text(
//                         "Change Password",
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       trailing: Icon(
//                         Icons.arrow_forward_ios,
//                         size: 18,
//                         color: AppColor.blackColor.withOpacity(0.8),
//                       ),
//                       onTap: () {
//                         Get.to(() => ChangePassword());
//                       }, // Implement navigation here
//                     ),
//                     ListTile(
//                       leading: const Icon(LucideIcons.fingerprint,
//                           color: AppColor.primaryColor),
//                       title: const Text(
//                         "Biometric Log in",
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       trailing: SizedBox(
//                         height: 35,
//                         width: 45,
//                         child: FittedBox(
//                           fit: BoxFit.fill,
//                           child: Switch(
//                             value: biometricLogin,
//                             activeColor: AppColor.whiteColor,
//                             activeTrackColor: AppColor.blueBorderColor,
//                             inactiveTrackColor: AppColor.primaryColor.shade100,
//                             inactiveThumbColor: AppColor.whiteColor,
//                             // Removing the focus/outline
//                             focusColor: Colors.transparent,
//                             trackOutlineColor:
//                                 MaterialStateProperty.all(Colors.transparent),
//                             onChanged: (value) {
//                               setState(() {
//                                 biometricLogin = value;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                       onTap: () {
//                         setState(() {
//                                 biometricLogin = !biometricLogin;
//                               });
//                       }, // Implement navigation here
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
