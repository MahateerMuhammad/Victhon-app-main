import 'package:flutter/material.dart';

import '../../../../config/theme/app_color.dart';

class CancelBookingTextfield extends StatefulWidget {
  const CancelBookingTextfield({super.key});

  @override
  State<CancelBookingTextfield> createState() => _CancelBookingTextfieldState();
}

class _CancelBookingTextfieldState extends State<CancelBookingTextfield> {
  int _currentLength = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
                height: 150,
                child: TextField(
                  cursorHeight: 18,
                  maxLines: 5,
                  maxLength: 300, // Maximum character limit
                  onChanged: (text) {
                    setState(() {
                      _currentLength = text.length; // Updates character count
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.primaryCardColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Provide a brief reason why you are cancelling.",
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                    ),
                    counterText:
                        '$_currentLength/300', // Display character count
                    counterStyle: const TextStyle(color: Colors.black54),
                  ),
                ),
              );
  }
}