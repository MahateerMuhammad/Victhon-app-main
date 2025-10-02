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

  print('[DEBUG] signInWithGoogle called with userType: $userType, authType: $authType');
  try {
    print('[DEBUG] Signing out of previous Google session...');
    await _googleSignIn.signOut(); // optional: force sign-in prompt
    print('[DEBUG] Prompting user to sign in with Google...');
    final GoogleSignInAccount? account = await _googleSignIn.signIn();

    if (account == null) {
      print('[DEBUG] Google sign-in cancelled by user.');
      return;
    }

    print('[DEBUG] Google account selected: \\${account.email}');
    final GoogleSignInAuthentication auth = await account.authentication;
    print('[DEBUG] Google accessToken: \\${auth.accessToken}');
    print('[DEBUG] Google idToken: \\${auth.idToken}');

    String? idToken = auth.idToken;

    if (idToken != null) {
      print('[DEBUG] Sending idToken to backend for $authType...');
      authController.isLoading.value = true;
      final ApiResponse response = await RemoteServices()
          .googleSignUp(idToken: idToken, userType: userType);
      print('[DEBUG] Backend response: $response');
      print('[DEBUG] Response data: ${response.data}');
      print('[DEBUG] Response isSuccess: ${response.isSuccess}');
      print('[DEBUG] Response statusCode: ${response.statusCode}');

      authController.isLoading.value = false;

      if (response.isSuccess) {
        final data = response.data;
        print('[DEBUG] Login successful: $data');
        box.write('token', data["access_token"]);

        if (data["userProfile"] == null) {
          print('[DEBUG] No userProfile found, redirecting to profile creation.');
          customSnackbar("SUCCESS".tr, "SignUp successful!", AppColor.success);
          if (userType == "customer") {
            Get.off(() => CreateProfileScreen(identifier: data["email"]));
          } else {
            Get.off(
                () => ProviderCreateProfileScreen(identifier: data["email"]));
          }
        } else {
          print('[DEBUG] User profile exists, logging in.');
          box.write("authStatus", "loggedIn");
          box.write("userType", userType);

          if (userType == "customer") {
            Get.offAll(() => const CustomerBottomNavBar());
          } else {
            Get.offAll(() => const ServiceProviderBottomNavBar());
          }
        }
      } else if (response.statusCode == 404) {
        print('[DEBUG] Login failed: 404 Not Found');
        if (authType == "signIn") {
          customSnackbar(
              "ERROR".tr, "No account found. Please SignUp", AppColor.error);
        }
      } else {
        print('[DEBUG] Login failed: $authType failed, please try again later');
        customSnackbar("ERROR".tr, "$authType failed, please try again later",
            AppColor.error);
      }
    } else {
      print('[DEBUG] idToken is null, failed connection.');
      customSnackbar("ERROR".tr, "Failed connection", AppColor.error);
    }
  } catch (e) {
    print('[DEBUG] Exception during Google sign-in: $e');
    Get.snackbar(
      "Message".tr,
      "Poor Internet Connection, retry",
    );
  }
}
