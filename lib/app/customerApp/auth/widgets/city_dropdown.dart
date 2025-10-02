// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:victhon/config/theme/app_color.dart';
// import '../controller/auth_controller.dart';

// // ignore: must_be_immutable
// class CityDropdown extends StatefulWidget {
//   const CityDropdown({
//     super.key,
//     this.width = double.infinity,
//   });
//   final double width;

//   @override
//   State<CityDropdown> createState() => _StateDropdown();
// }

// class _StateDropdown extends State<CityDropdown> {
//   // String? values;
//   final authController = Get.put(AuthController());


//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       ()=> Container(
//         padding: const EdgeInsets.fromLTRB(10, 2, 5, 3),
//         width: widget.width,
//         height: 40,
//         decoration: BoxDecoration(
//           border: Border.all(color: AppColor.inactiveColor),
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: DropdownButton<String>(
//           isExpanded: true,
//           value: authController.selectedCity.value,
//           dropdownColor: AppColor.whiteColor,
//           underline: const SizedBox(),
//           focusColor: Colors.transparent,
//           hint: const Text(
//             "City",
//             textAlign: TextAlign.left,
//             style:  TextStyle(
//               fontSize: 14,
//               color: AppColor.inactiveColor,
//             ),
//           ),
//           items: authController.citiesDropDownItem.map(buildItem).toList(),
//           icon: const Icon(
//             Icons.keyboard_arrow_down_outlined,
//             color: Color.fromRGBO(0, 0, 0, 0.7),
//             size: 30,
//           ),
//           onChanged: (value) {
//             authController.updateSelectedCity(value!);
            
//             setState(() {});
//           },
//         ),
//       ),
//     );
//   }

//   DropdownMenuItem<String> buildItem(String item) {
//     return DropdownMenuItem(
//       value: item,
//       child: FittedBox(
//         child: Text(
//           item,
//           textAlign: TextAlign.left,
//           style: const TextStyle(
//             fontSize: 16,
//             color: AppColor.blackColor,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }
