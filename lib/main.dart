/* ===============================================================
| Project : SIFR
| Page    : MAIN.DART
| Date    : 21-MAR-2023
*  ===============================================================*/

// Dependencies or Plugins - Models - Services - Global Functions
import 'dart:async';
import 'dart:io';

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

    // ByteData data = await PlatformAssetBundle()
    //     .load('assets/ca/omaemirates_root_certificate.cer');
    // SecurityContext.defaultContext
    //     .setTrustedCertificatesBytes(data.buffer.asUint8List());

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
