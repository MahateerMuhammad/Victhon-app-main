import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/theme/app_color.dart';

class AppSearchTextField extends StatelessWidget {
  const AppSearchTextField({
    super.key,
    this.suffixIcon,
    this.prefixIcon,
    required this.onChanged,
    required this.searchController,
  });
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: searchController,
      decoration: InputDecoration(
        hintText: "Search",
        
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.inactiveColor),
          borderRadius: BorderRadius.circular(30.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.inactiveColor),
          borderRadius: BorderRadius.circular(30.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.primaryColor),
          borderRadius: BorderRadius.circular(30.r),
        ),
      ),
    );
  }
}
