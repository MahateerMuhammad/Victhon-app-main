import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Victhon/config/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Victhon/config/routes/app_routes.dart';
import 'package:Victhon/data/server/onesignal_notification_setup.dart';
import 'config/theme/app_color.dart';
import 'data/remote_services/network_service.dart';
import 'data/server/socket_server.dart';

final box = GetStorage();
FirebaseMessaging messaging = FirebaseMessaging.instance;
late SharedPreferences prefs;

Future<void> main() async {
  debugPrint('DEBUG: Starting main() function...');

  try {
    debugPrint('DEBUG: Ensuring Flutter widgets binding...');
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('DEBUG: Flutter widgets binding initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('ERROR: Failed to initialize Flutter widgets binding: $e');
    debugPrint('STACK TRACE: $stackTrace');
    return; // Critical error - can't continue
  }

  // Initialize Firebase
  if (!kIsWeb) {
    try {
      debugPrint('DEBUG: Initializing Firebase for mobile platform...');
      await Firebase.initializeApp();
      debugPrint('DEBUG: Firebase initialized successfully for mobile');
    } catch (e, stackTrace) {
      debugPrint('ERROR: Failed to initialize Firebase: $e');
      debugPrint('STACK TRACE: $stackTrace');
      debugPrint('INFO: App will continue without Firebase functionality');
    }
  } else {
    debugPrint('DEBUG: Skipping Firebase initialization on web platform');
  }

  // Initialize GetStorage
  try {
    debugPrint('DEBUG: Initializing GetStorage...');
    await GetStorage.init();
    debugPrint('DEBUG: GetStorage initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('ERROR: Failed to initialize GetStorage: $e');
    debugPrint('STACK TRACE: $stackTrace');
    // Continue execution - but storage-dependent features might fail
  }

  // Initialize OneSignal notifications
  if (!kIsWeb) {
    try {
      debugPrint('DEBUG: Initializing OneSignal notification service...');
      await OnesignalNotificationService.init();
      debugPrint(
          'DEBUG: OneSignal notification service initialized successfully');
    } catch (e, stackTrace) {
      debugPrint(
          'ERROR: Failed to initialize OneSignal notification service: $e');
      debugPrint('STACK TRACE: $stackTrace');
      // Continue execution - notifications might not work
    }
  } else {
    debugPrint('DEBUG: Skipping OneSignal initialization on web platform');
  }

  // Initialize NetworkService
  try {
    debugPrint('DEBUG: Initializing NetworkService...');
    await Get.putAsync(() => NetworkService().init());
    debugPrint('DEBUG: NetworkService initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('ERROR: Failed to initialize NetworkService: $e');
    debugPrint('STACK TRACE: $stackTrace');
    // Continue execution - but network monitoring might not work
  }

  // Initialize Socket
  try {
    debugPrint('DEBUG: Initializing Socket connection...');
    initSocket();
    debugPrint('DEBUG: Socket initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('ERROR: Failed to initialize Socket: $e');
    debugPrint('STACK TRACE: $stackTrace');
    // Continue execution - real-time features might not work
  }

  // Initialize SharedPreferences
  try {
    debugPrint('DEBUG: Initializing SharedPreferences...');
    prefs = await SharedPreferences.getInstance();
    debugPrint('DEBUG: SharedPreferences initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('ERROR: Failed to initialize SharedPreferences: $e');
    debugPrint('STACK TRACE: $stackTrace');
    // Continue execution - but preferences might not persist
  }

  debugPrint('DEBUG: All initialization completed. Running app...');

  try {
    runApp(
      DevicePreview(
        enabled: false,
        builder: (context) => MyApp(),
      ),
    );
    debugPrint('DEBUG: App started successfully');
  } catch (e, stackTrace) {
    debugPrint('FATAL ERROR: Failed to start app: $e');
    debugPrint('STACK TRACE: $stackTrace');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('DEBUG: Building MyApp widget...');

    String? authStatus;
    String? userType;
    String initialRoute = AppPages.initial;

    try {
      // Read authentication status
      debugPrint('DEBUG: Reading authentication status from storage...');
      authStatus = box.read("authStatus");
      debugPrint('DEBUG: authStatus = "${authStatus ?? 'null'}"');
    } catch (e, stackTrace) {
      debugPrint('ERROR: Failed to read authStatus from storage: $e');
      debugPrint('STACK TRACE: $stackTrace');
      authStatus = null; // Default to null if reading fails
    }

    try {
      // Read user type
      debugPrint('DEBUG: Reading user type from storage...');
      userType = box.read("userType");
      debugPrint('DEBUG: userType = "${userType ?? 'null'}"');
    } catch (e, stackTrace) {
      debugPrint('ERROR: Failed to read userType from storage: $e');
      debugPrint('STACK TRACE: $stackTrace');
      userType = null; // Default to null if reading fails
    }

    try {
      // Determine initial route
      debugPrint('DEBUG: Determining initial route...');
      debugPrint('DEBUG: Default initial route = ${AppPages.initial}');

      if (authStatus == "loggedIn") {
        if (userType == "customer") {
          initialRoute = Routes.customerNavBarView;
          debugPrint('DEBUG: User is logged in as customer');
        } else if (userType == "serviceProvider") {
          initialRoute = Routes.serviceProviderNavBarView;
          debugPrint('DEBUG: User is logged in as service provider');
        } else {
          debugPrint(
              'WARNING: Unknown user type: $userType, using default route');
          initialRoute = AppPages.initial;
        }
      } else {
        debugPrint('DEBUG: User is not logged in, using default route');
        initialRoute = AppPages.initial;
      }

      debugPrint('DEBUG: Final initialRoute = $initialRoute');
    } catch (e, stackTrace) {
      debugPrint('ERROR: Failed to determine initial route: $e');
      debugPrint('STACK TRACE: $stackTrace');
      initialRoute = AppPages.initial; // Fallback to default route
    }

    try {
      debugPrint('DEBUG: Building ScreenUtilInit widget...');
      return ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: (context, child) {
          debugPrint('DEBUG: Building GetMaterialApp...');

          try {
            return GetMaterialApp(
              title: 'Victhon',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: AppColor.primaryColor),
                useMaterial3: true,
              ),
              initialRoute: initialRoute,
              getPages: AppPages.pages,
              builder: (context, child) {
                debugPrint(
                    'DEBUG: Building app with network status overlay...');

                NetworkService? networkService;
                try {
                  networkService = Get.find<NetworkService>();
                  debugPrint('DEBUG: NetworkService found successfully');
                } catch (e) {
                  debugPrint('WARNING: NetworkService not found: $e');
                  // Return child without network status if service is not available
                  return child!;
                }

                try {
                  return Obx(
                    () {
                      final showMessage =
                          networkService?.showRestoredMessage.value ?? false;
                      final isConnected =
                          networkService?.isConnected.value ?? true;

                      debugPrint(
                          'DEBUG: Network status - showMessage: $showMessage, isConnected: $isConnected');

                      return Stack(
                        children: [
                          child!,
                          showMessage
                              ? Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Material(
                                    child: Container(
                                      color: !isConnected
                                          ? Colors.red
                                          : AppColor.primaryColor,
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(0),
                                      child: SafeArea(
                                        child: Text(
                                          !isConnected
                                              ? 'No Internet Connection'
                                              : "Internet Restored",
                                          style: const TextStyle(
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      );
                    },
                  );
                } catch (e, stackTrace) {
                  debugPrint(
                      'ERROR: Failed to build network status overlay: $e');
                  debugPrint('STACK TRACE: $stackTrace');
                  // Return child without overlay if there's an error
                  return child!;
                }
              },
            );
          } catch (e, stackTrace) {
            debugPrint('ERROR: Failed to build GetMaterialApp: $e');
            debugPrint('STACK TRACE: $stackTrace');
            // Return a basic MaterialApp as fallback
            return MaterialApp(
              title: 'Victhon',
              home: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to initialize app',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Please restart the application'),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      );
    } catch (e, stackTrace) {
      debugPrint('FATAL ERROR: Failed to build MyApp: $e');
      debugPrint('STACK TRACE: $stackTrace');

      // Return absolute minimal fallback
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'Critical Error\nPlease restart the app',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),
        ),
      );
    }
  }
}
