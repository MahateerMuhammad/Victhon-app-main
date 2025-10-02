import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Victhon/app/service_provider/profile/widget/contact_us_container.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widget/textwidget.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const TextWidget(
          text: 'Contact Us',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        surfaceTintColor: AppColor.whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContactUsContainer(
                icon: Icon(
                  Icons.mail,
                  color: AppColor.primaryColor,
                ),
                title: "Email",
                subtitle: "info@victhon.ng",
              ),
              SizedBox(
                height: 24,
              ),
              ContactUsContainer(
                icon: Icon(
                  CupertinoIcons.phone_circle_fill,
                  color: AppColor.primaryColor,
                ),
                title: "Whatsapp",
                subtitle: "+234 9023456789",
              ),
              SizedBox(
                height: 24,
              ),
              ContactUsContainer(
                icon: Icon(
                  Icons.call,
                  color: AppColor.primaryColor,
                ),
                title: "Call Us",
                subtitle: "09023456789",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
