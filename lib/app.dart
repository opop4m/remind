// import 'package:dim/commom/route.dart';
import 'package:client/pages/root/root_page.dart';
import 'package:client/provider/global_cache.dart';
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      routes: {
        '/': (context) {
          return Global.get().hasLogin ? new RootPage() : new LoginBeginPage();
          // return new LoginBeginPage();
        }
      },
    );
  }
}
