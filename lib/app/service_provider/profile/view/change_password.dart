// import 'package:flutter/material.dart';
// import 'package:victhon/widget/app_botton.dart';
// import 'package:victhon/widget/custom_form_field.dart';

// import '../../../../config/theme/app_color.dart';
// import '../../../../widget/textwidget.dart';

// class ChangePassword extends StatelessWidget {
//   const ChangePassword({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.whiteColor,
//       appBar: AppBar(
//         title: const TextWidget(
//           text: 'Change Password',
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
//               const TextWidget(
//                 text: 'Verify Login Password',
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//               const TextWidget(
//                 text:
//                     'Please enter your current password to verify your identity before proceeding to change it.',
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//               const SizedBox(
//                 height: 32,
//               ),
//               const TextWidget(
//                 text: 'Password',
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//               const SizedBox(
//                 height: 4,
//               ),
//               CustomFormField(hintText: "Enter current Password"),
//               const SizedBox(
//                 height: 40,
//               ),
//               AppPrimaryButton(
//                 buttonText: "Send Code",
//                 onPressed: () {},
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
