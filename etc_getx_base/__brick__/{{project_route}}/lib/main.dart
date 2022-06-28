import 'package:{{project_route}}/app/routes/app_routes.dart';
import 'package:{{project_route}}/app/ui/global/global_binding.dart';
import 'package:{{project_route}}/app/ui/loading/loading_page.dart';
import 'package:{{project_route}}/app/utils/app_theme.dart';
import 'package:{{project_route}}/app/utils/pro_base_state.dart';
import 'package:{{project_route}}/app/utils/share_pref.dart';
import 'package:{{project_route}}/app/utils/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ProBaseState.allowedOrientation([DeviceOrientation.portraitUp]);
  await SharePref.sharePref.initialize();
  ProBaseState.onFailed = (context, code, message) {
    if (code == 401 || code == 426) {
      return true;
    }
    return false;
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '{{{project_name}}}',
      theme: appThemeData,
      getPages: AppPages.routes,
      initialRoute: LoadingPage().routeName,
      initialBinding: GlobalBinding(),
    );
  }
}
