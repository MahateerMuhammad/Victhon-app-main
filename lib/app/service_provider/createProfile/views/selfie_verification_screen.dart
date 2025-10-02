// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:Victhon/widget/app_botton.dart';
// import 'package:Victhon/widget/textwidget.dart';

// import '../../../../config/theme/app_color.dart';
// import '../../../../widget/loader.dart';
// import '../controller/provider_create_profile_controller.dart';
// import 'selfie_capture_screen.dart';

// class SelfieVerificationScreen extends StatelessWidget {
//  SelfieVerificationScreen({super.key});

//   final createProfileController = Get.put(ProviderCreateProfileController());


//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       ()=> Stack(
//         children: [
//           Scaffold(
//             backgroundColor: Colors.white,
//             body: Padding(
//               padding: const EdgeInsets.all(16),
//               child: SafeArea(
//                 child: Column(
//                   children: [
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     // Progress bar
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: List.generate(
//                         3,
//                         (index) => Expanded(
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(horizontal: 4),
//                             height: 5,
//                             decoration: BoxDecoration(
//                               color: index < 2
//                                   ? AppColor.primaryColor
//                                   : AppColor.primaryColor.shade100,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
          
//                     const TextWidget(
//                       text: 'Selfie Verification',
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     const SizedBox(height: 8),
//                     const TextWidget(
//                       text: 'Complete Profile to get access to all features.',
//                       color: Colors.grey,
//                     ),
//                     const SizedBox(height: 24),
          
//                     GestureDetector(
//                       onTap: () {
//                         // Navigate to selfie capture
//                         Get.to(() => const SelfieCaptureScreen());
//                       },
//                       child: CustomPaint(
//                         painter: BrakeLinePainter(
//                           color: AppColor.primaryColor.shade100,
//                           strokeWidth: 2,
//                         ),
//                         child: Container(
//                           padding: const EdgeInsets.all(24),
//                           width: double.infinity,
//                           height: 200,
//                           decoration: BoxDecoration(
//                             // border: Border.all(
//                             //     color: AppColor.primaryColor.shade100,
//                             //     style: BorderStyle.solid,
//                             //     width: 2),
//                             borderRadius: BorderRadius.circular(16),
//                             // borderOnForeground: false,
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 radius: 48,
//                                 backgroundColor: AppColor.primaryColor.shade50,
//                                 child: const Icon(
//                                   Icons.tag_faces,
//                                   size: 48,
//                                   color: AppColor.primaryColor,
//                                 ),
//                               ),
//                               const SizedBox(height: 24),
//                               const TextWidget(
//                                 text: "Click to Open Camera",
//                                 fontSize: 16,
//                                 color: AppColor.primaryColor,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
          
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: AppColor.primaryCardColor,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.error, color: Colors.red),
//                               SizedBox(width: 8),
//                               TextWidget(
//                                 text: "Precautions",
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 8),
//                           TextWidget(
//                             text: "•  Do not wear hats or mask.",
//                             fontSize: 14,
//                           ),
//                           SizedBox(height: 4),
//                           TextWidget(text: "•  Please stay in a well-lit area."),
//                           SizedBox(height: 4),
//                           TextWidget(text: "•  Do not wear sunglasses."),
//                           SizedBox(height: 4),
//                           TextWidget(
//                               text: "•  Make sure it’s you, not someone else."),
//                         ],
//                       ),
//                     ),
//                     const Spacer(),
          
//                     const SizedBox(height: 16),
//                     AppPrimaryButton(
//                       buttonText: "Verify Selfie",
//                       onPressed: () {

//                         Get.to(() => const SelfieCaptureScreen());
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           createProfileController.isLoading.value
//               ? const LoaderCircle()
//               : const SizedBox()
//         ],
//       ),
//     );
//   }
// }

// class BrakeLinePainter extends CustomPainter {
//   final Color color;
//   final double strokeWidth;
//   final double borderRadius;

//   BrakeLinePainter({
//     required this.color,
//     required this.strokeWidth,
//     this.borderRadius = 20.0,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;

//     final lineLength = 10.0;
//     final lineGap = 6.0;

//     final rect = Rect.fromLTWH(0, 0, size.width, size.height);
//     final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

//     final path = Path()..addRRect(rRect);
//     final metrics = path.computeMetrics();

//     for (final metric in metrics) {
//       double distance = 0.0;
//       while (distance < metric.length) {
//         final next = distance + lineLength;
//         final extractPath = metric.extractPath(
//           distance,
//           next.clamp(0.0, metric.length),
//         );
//         canvas.drawPath(extractPath, paint);
//         distance += lineLength + lineGap;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
