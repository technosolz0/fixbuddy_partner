import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbuddy_partner/app/constants/app_constants.dart';
import 'package:fixbuddy_partner/app/l10n/app_localizations.dart';
import 'package:fixbuddy_partner/app/utils/deep_link.dart';
import 'package:fixbuddy_partner/app/utils/local_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:device_info_plus/device_info_plus.dart';

// 🔹 Geolocator
import 'package:geolocator/geolocator.dart';

import 'app/routes/app_pages.dart';
import 'app/utils/firebase_notifications.dart';
import 'app/utils/local_notifications.dart';
import 'app/utils/servex_utils.dart';
import 'firebase_options.dart';

Rx<ThemeMode> appThemeMode = ThemeMode.system.obs;

enum AppMode { dev, test, live }

AppMode currentAppMode = AppMode.live;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ServexUtils.logPrint('---> Background message: ${message.notification?.title}');
}

LocalStorage localStorage = LocalStorage();
bool isLoggedIn = false;
String updateType = 'flexible';
DateTime? currentBackPressTime;
RemoteMessage? initialFMessage;
NotificationResponse? initialLocalNotification;
late DeepLink deepLink;

bool hasAlreadyAskedForHealthPermissions = false;

Future<void> fetchAndStoreDeviceLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return;

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;
  }

  if (permission == LocationPermission.deniedForever) return;

  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    await localStorage.setDeviceLatitude(position.latitude.toString());
    await localStorage.setDeviceLongitude(position.longitude.toString());
    ServexUtils.logPrint('📍 Location stored: ${position.latitude}, ${position.longitude}');
  } catch (e) {
    ServexUtils.logPrint('❌ Error fetching location: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
    kReleaseMode && currentAppMode == AppMode.live,
  );

  await FlutterLocalNotificationsPlugin().initialize(
    LocalNotifications.initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      LocalNotifications.onSelectNotification(details);
    },
  );

  tz.initializeTimeZones();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 🔹 Ask for required permissions
  await [
    Permission.location,
    Permission.notification,
    Permission.storage,
    Permission.camera,
  ].request();

  if (Platform.isIOS) {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
    );
    ServexUtils.logPrint('Notification permission: ${settings.authorizationStatus}');
  }

  // 🔹 Fetch and store FCM token
  String? token = await FirebaseMessaging.instance.getToken();
  ServexUtils.logPrint('FCM Token: $token');
  if (token != null) {
    await localStorage.setFirebaseToken(token);
  }

  await fetchAndStoreDeviceLocation();

  final deviceInfoPlugin = DeviceInfoPlugin();
  String deviceName = 'Unknown Device';
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    deviceName = androidInfo.model ?? 'Android Device';
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    deviceName = iosInfo.utsname.machine ?? 'iOS Device';
  }
  await localStorage.setDeviceName(deviceName);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const ServexApp());
}

class ServexApp extends StatefulWidget {
  const ServexApp({super.key});

  @override
  State<ServexApp> createState() => _ServexAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _ServexAppState? state = context.findAncestorStateOfType<_ServexAppState>();
    state?.setLocale(newLocale);
  }

  static void setThemeMode(BuildContext context, ThemeMode theme) {
    _ServexAppState? state = context.findAncestorStateOfType<_ServexAppState>();
    state?.setThemeMode(theme);
  }
}

class _ServexAppState extends State<ServexApp> with WidgetsBindingObserver {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String lang = await LocalStorage().getLanguage() ?? AppLanguage.english.locale;
      setState(() {
        _locale = Locale(lang, '');
      });

      bool? isDarkMode = await LocalStorage().getIsDarkMode();
      if (isDarkMode != null) {
        setState(() {
          appThemeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
        });
      }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseNotifications().notificationListeners();
    LocalNotifications.getTerminatedTapLaunchDetails();
  }

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  setThemeMode(ThemeMode theme) {
    setState(() {
      appThemeMode.value = theme;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!isLoggedIn) return;
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
        ServexUtils.dPrint("--->app state: inactive");
        break;
      case AppLifecycleState.resumed:
        ServexUtils.dPrint("--->app state: resumed");
        break;
      case AppLifecycleState.paused:
        ServexUtils.dPrint("--->app state: paused");
        break;
      case AppLifecycleState.detached:
        ServexUtils.dPrint("--->app state: detached");
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 834),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        title: "Servex App",
        debugShowCheckedModeBanner: currentAppMode != AppMode.live,
        locale: _locale,
        localizationsDelegates: [AppLocalizations.delegate],
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        themeMode: appThemeMode.value,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
      ),
    );
  }
}