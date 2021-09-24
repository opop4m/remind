// import 'package:dim/commom/route.dart';
import 'package:client/pages/chat/chat_page.dart';
import 'package:client/pages/root/root_page.dart';
import 'package:client/provider/global_cache.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imApi.dart';
import 'package:client/provider/service/imData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
// import 'package:client/config/storage_manager.dart';
import 'package:client/pages/login/login_begin_page.dart';
// import 'package:client/pages/root/root_page.dart';
import 'package:client/provider/global_model.dart';
import 'package:client/tools/library.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _log = Logger("app");

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  void initializeFlutterFire() async {
    await Global.get().init();
    FirebaseApp app = await Firebase.initializeApp();
    if (API.env != "release" && PlatformUtils.isMobile) {
      // Force disable Crashlytics collection while doing every day development.
      // Temporarily toggle this to true if you want to test crash reporting in your app.
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }
    // await setupInteractedMessage();
    print('Initialized default app $app');
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    getPushToken();
    createAndroidNotificationChannel();
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void createAndroidNotificationChannel() {
    if (!PlatformUtils.isAndroid) return;
    _log.info("createAndroidNotificationChannel");
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'unicorn_1', // id
      'unicorn', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  late BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context = context;
    final model = Provider.of<GlobalModel>(context)..setContext(context);

    return new MaterialApp(
      navigatorKey: navGK,
      title: model.appName,
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        hintColor: Colors.grey.withOpacity(0.3),
        splashColor: Colors.transparent,
        canvasColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: model.currentLocale,
      navigatorObservers: [routeObserver],
      routes: {
        '/': (context) {
          return Global.get().hasLogin ? new RootPage() : new LoginBeginPage();
          // return new LoginBeginPage();
        }
      },
      // home: Global.get().hasLogin ? new RootPage() : new LoginBeginPage(),
    );
  }

  getPushToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    if (PlatformUtils.isIOS || PlatformUtils.isMacOS) {
      var token = await messaging.getAPNSToken();
      _log.info("push APN token: $token");
      // if (strNoEmpty(token)) {
      //   ImApi.appStart(token!);
      // }
      // return;
    }

    var token = await messaging.getToken();
    _log.info("push token: $token");
    if (strNoEmpty(token)) {
      ImApi.appStart(token!);
    }
    messaging.onTokenRefresh.listen((token) {
      _log.info("onTokenRefresh : $token");
      if (strNoEmpty(token)) {
        ImApi.appStart(token);
      }
    });
  }
}
