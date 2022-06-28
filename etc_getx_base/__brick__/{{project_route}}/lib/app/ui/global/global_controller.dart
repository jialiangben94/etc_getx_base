import 'package:get/get.dart';
import 'package:{{project_route}}/app/services/base/app_constant.dart';
import 'package:{{project_route}}/app/utils/app_util.dart';
import 'package:{{project_route}}/app/utils/share_pref.dart';

class GlobalController extends GetxController {
  bool isDialogOpen = false;
  final AppConstant _app = AppConstant();

  @override
  void onInit() {
    // DatabaseController.db.initialize("{{project_route}}", 5);
    // NotificationController().init();
    super.onInit();
  }

  String version() {
    return _app.version;
  }

  void backtoLoginPage() {
    // loadPage(OnBoardingPage());
  }

  void popUpForceUpdate() async {
    if (!isDialogOpen) {
      isDialogOpen = true;
      var _ = await openForceUpdateDialog(Get.context);
      isDialogOpen = false;
    }
  }

  void popUpSessionExpired(String message) async {
    SharePref.sharePref.removeAccessToken();
    if (!isDialogOpen) {
      isDialogOpen = true;
      var _ = await showConfirmation(message, confirm: () {
        isDialogOpen = false;
        backtoLoginPage();
      });
      isDialogOpen = false;
    }
  }

  // void switchLanguage() {
  //   if (AppTranslation.getLanguage() == Language.Chinese) {
  //     AppTranslation.changeLanguage(Language.English);
  //   } else {
  //     AppTranslation.changeLanguage(Language.Chinese);
  //   }
  //   // currentLang.value = getLanguage().toString();
  // }

  // String currentLanguage() {
  //   return AppTranslation.getLanguage().toString();
  // }
}
