import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Victhon/data/remote_services/remote_services.dart';
import 'package:Victhon/data/server/app_server.dart';

import '../../app/customerApp/auth/controller/auth_controller.dart';
import '../../app/customerApp/auth/views/create_profile_screen.dart';
import '../../app/customerApp/bottonNavBar/view/bottom_nav_bar.dart';
import '../../app/service_provider/bottomNavBar/view/service_provider_bottom_nav_bar.dart';
import '../../app/service_provider/createProfile/views/create_profile.dart';
import '../../config/theme/app_color.dart';
import '../../main.dart';
import '../../widget/custom_snackbar.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
  serverClientId:
      "808351711954-pkcc3epjnt50ihsmlm9gc6iu3e2rsg9f.apps.googleusercontent.com",
);

Future<void> signInWithGoogle(String userType, String authType) async {
  final authController = Get.put(AuthController());

  try {
    await _googleSignIn.signOut(); // optional: force sign-in prompt
    final GoogleSignInAccount? account = await _googleSignIn.signIn();

    if (account == null) {
      // User canceled
      return;
    }

    final GoogleSignInAuthentication auth = await account.authentication;
    print("----------------- ${auth.accessToken}");
    print("----------------- ${auth.idToken}");

    String? idToken = auth.idToken;
//     while (idToken!.length > 0) {
//     int initLength = (idToken.length >= 500 ? 500 : idToken.length);
//     print(idToken.substring(0, initLength));
//     int endLength = idToken.length;
//     idToken = idToken.substring(initLength, endLength);

// }

    if (idToken != null) {
      authController.isLoading.value = true;
      // Send idToken to your backend
      final ApiResponse response = await RemoteServices()
          .googleSignUp(idToken: idToken, userType: userType);
      print('Login successful: ${response}');
      print('Login : ${response.data}');
      print('Login : ${response.isSuccess}');
      print('Login : ${response.statusCode}');

      authController.isLoading.value = false;

      if (response.isSuccess) {
        final data = response.data;
        // ✅ Save auth token or user info if needed
        print('Login successful: $data');
        box.write('token', data["access_token"]);

        if (data["userProfile"] == null) {
          customSnackbar("SUCCESS".tr, "SignUp successful!", AppColor.success);
          if (userType == "customer") {
            Get.off(() => CreateProfileScreen(identifier: data["email"]));
          } else {
            Get.off(
                () => ProviderCreateProfileScreen(identifier: data["email"]));
          }
        } else {
          box.write("authStatus", "loggedIn");
          box.write("userType", userType);

          if (userType == "customer") {
            Get.offAll(() => const CustomerBottomNavBar());
          } else {
            Get.offAll(() => const ServiceProviderBottomNavBar());
          }
        }
      } else if (response.statusCode == 404) {
        //  print('Login failed: ${response.data}');
        if (authType == "signIn") {
          customSnackbar(
              "ERROR".tr, "No account found. Please SignUp", AppColor.error);
        }
      } else {
        customSnackbar("ERROR".tr, "$authType failed, please try again later",
            AppColor.error);
      }
    } else {
      customSnackbar("ERROR".tr, "Failed connection", AppColor.error);
    }
  } catch (e) {
    // print('Error during Google sign-in: $e');
    Get.snackbar(
      "Message".tr,
      "Poor Internet Connection, retry",
    );
  }
}
