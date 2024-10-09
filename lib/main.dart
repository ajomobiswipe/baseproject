/* ===============================================================
| Project : SIFR
| Page    : MAIN.DART
| Date    : 21-MAR-2023
*  ===============================================================*/

// Dependencies or Plugins - Models - Services - Global Functions
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:baseproject/services/connection.dart';
import 'package:baseproject/storage/secure_storage.dart';
import 'package:baseproject/widgets/app/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:freerasp/freerasp.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:baseproject/theme/app_themes.dart';
import 'package:baseproject/theme/hive_storage_services.dart';
import 'package:baseproject/theme/theme_provider.dart';

import 'config/config.dart';
import 'config/state_key.dart';
import 'providers/providers.dart';

// Global Key - unauthorized login
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// CustomAlert customAlert = CustomAlert();
// AlertService alertService = AlertService();

// main function - flutter startup function
void main() {
  runZonedGuarded<Future<void>>(() async {
    setUpServiceLocator();
    final StorageService storageService = getIt<StorageService>();
    await storageService.init();
    await Hive.initFlutter(); // THIS IS FOR THEME STORAGE
    await Hive.openBox('SIFR_USER_CONTROLS'); // THIS IS FOR USER STORAGE
    HttpOverrides.global = MyHttpOverrides();
    // ByteData data = await PlatformAssetBundle()
    //     .load('assets/ca/omaemirates_root_certificate.cer');
    // SecurityContext.defaultContext
    //     .setTrustedCertificatesBytes(data.buffer.asUint8List());
    Timer.periodic(const Duration(seconds: 120), (timer) async {
      BoxStorage boxStorage = BoxStorage();

      var token = boxStorage.getUserDetails();
      if (token == null) {
        print("User not loged in ");
      } else {
        DataMonitoringProvider dataMonitoringProvider =
            DataMonitoringProvider();
        dataMonitoringProvider.getDashboardData();
        // String token = boxStorage.getToken();
        // // var url = '${EndPoints.baseApiPublic}/NanoPay/Middleware/UiApi/getMerchantOnboardingInfo/$number';
        // var url = '${EndPoints.baseApiPublic9097}refreshToken/$token';

        // final headers = {
        //   'Authorization': 'Bearer $token',
        //   'Bearer': token,
        //   'Content-Type': 'application/json'
        // };

        // Connection connection = Connection();

        // var res = await connection.getWithOutToken(url);

        // print('refreshToken${res.body}');

        // var decodedData = jsonDecode(res.body);

        // if (res.statusCode == 401) {
        //   navigatorKey.currentState?.pushReplacementNamed('login');
        //   AlertService alertService = AlertService();
        //   alertService.error(Constants.unauthorized);
        //   clearStorage();
        //   return;
        // }

        // // /// OLD Shared Preferences STORAGE CONTROLS
        // // SharedPreferences prefs = await SharedPreferences.getInstance();
        // // prefs.setString('token', decodedData['bearerToken'].toString());

        // await boxStorage.saveUserDetails(decodedData);

        // print("user Loged In");
      }
      // print(token);
      // print(DateTime.now());
      // print("30 seconds passed");
    });

    // --- Root
    WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.bottom]);
    runApp(MainPage(
      storageService: storageService,
    ));
  }, (e, _) => throw e);
}

// FCM - Background Services
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

// Stateless Widget for main page
class MainPage extends StatelessWidget {
  // local variable declaration
  final StorageService storageService;
  const MainPage({Key? key, required this.storageService}) : super(key: key);

  /*
  * This is the main page of project. we are using multiple provider.
  * ThemeProvider - for theme mode & theme color option
  * ConnectivityProvider - for internet check
  */
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataMonitoringProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(storageService),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (c, themeProvider, home) => MaterialApp(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: StateKey.snackBarKey,
          initialRoute: 'splash',
          onGenerateRoute: CustomRoute.allRoutes,
          navigatorKey: navigatorKey,
          locale: Locale(themeProvider.currentLanguage),
          theme: AppThemes.main(
            primaryColor: themeProvider.selectedPrimaryColor,
          ),
          // Dark mode design
          darkTheme: AppThemes.main(
            isDark: true,
            primaryColor: themeProvider.selectedPrimaryColor,
          ),
          // this is Theme Mode Selection
          themeMode: themeProvider.selectedThemeMode,
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
