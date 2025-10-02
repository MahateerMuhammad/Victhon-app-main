import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/auth/views/onboarding_screen.dart';
import 'package:Victhon/app/customerApp/notifications/view/customer_notification_view.dart';
import 'package:Victhon/app/service_provider/createProfile/views/create_profile.dart';
import 'package:Victhon/app/service_provider/createProfile/views/selfie_verification_screen.dart';
import 'package:Victhon/app/customerApp/bottonNavBar/view/bottom_nav_bar.dart';
import 'package:Victhon/app/service_provider/bottomNavBar/view/service_provider_bottom_nav_bar.dart';

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static String initial = "/unboarding/";


  static final pages = [
    GetPage(
      name: initial,
      page: () => const OnboardingScreen(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.customerNavBarView,
      page: () => const CustomerBottomNavBar(),
      // bindings: [
      //   HomeBindings(),
      //   NavbarBinding(),
      //   CategoryTreeBindings(),
      // ],
    ),
    GetPage(
      name: Routes.serviceProviderNavBarView,
      page: () => const ServiceProviderBottomNavBar(),
      // binding: HomeBindings(),
    ),
    // GetPage(
    //   name: Routes.selfieVeirfication,
    //   page: () => SelfieVerificationScreen(),
    //   // binding: HomeBindings(),
    // ),
    GetPage(
      name: Routes.createProviderProfile,
      page: () =>  const ProviderCreateProfileScreen(identifier: "umunubo.lg@gmail.com",),
      // binding: LanguageBindings(),
    ),
    GetPage(
      name: Routes.customerNotificationsScreen,
      page: () =>   CustomerNotificationView(),
      // binding: LanguageBindings(),
    )
  ];
}
