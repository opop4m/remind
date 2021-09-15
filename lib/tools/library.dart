export 'dart:ui';
export 'dart:async';
export 'package:flutter/services.dart';
export 'dart:io';
// if (dart.library.js) "dart:html";
export 'package:cached_network_image/cached_network_image.dart';
export 'package:connectivity/connectivity.dart';
export 'package:client/ui/bar/commom_bar.dart';
export 'package:client/config/const.dart';
export 'package:client/ui/button/commom_button.dart';
// export 'package:client/generated/i18n.dart';
export 'package:client/ui/dialog/show_snack.dart';
export 'package:client/ui/dialog/show_toast.dart';
export 'package:client/ui/view/main_input.dart';
export 'package:client/config/contacts.dart';
export 'package:client/config/strings.dart';
export 'package:client/tools/shared_util.dart';
export 'package:client/ui/web/web_view.dart';
export 'package:client/ui/view/loading_view.dart';
export 'package:client/ui/view/image_view.dart';
export 'package:client/config/api.dart';
// export 'package:client/http/req.dart';
export 'package:client/tools/check.dart';
export 'package:client/ui/view/null_view.dart';
export 'package:client/ui/win_media.dart';
export 'package:client/ui/ui.dart';
export 'package:client/ui/route.dart';
export 'package:client/tools/check.dart';
export 'package:client/tools/bus/notice.dart';
export 'package:client/tools/bus/event.dart';
export 'package:client/l10n/l18n.dart';
export 'package:logging/logging.dart';
export 'package:client/provider/global_cache.dart';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
// import 'package:dim/dim.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Dim im = new Dim();

var subscription = Connectivity();

typedef Callback(data);

DefaultCacheManager cacheManager = new DefaultCacheManager();

const String defGroupAvatar =
    'http://www.flutterj.com/content/uploadfile/zidingyi/g.png';

const Color mainBGColor = Color.fromRGBO(240, 240, 245, 1.0);
