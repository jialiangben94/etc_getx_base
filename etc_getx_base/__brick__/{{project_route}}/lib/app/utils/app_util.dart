import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:{{project_route}}/app/services/base/app_constant.dart';
import 'package:{{project_route}}/app/utils/custom_getx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:{{project_route}}/app/utils/constants.dart';
import 'package:{{project_route}}/app/utils/extensions.dart';
import 'package:{{project_route}}/app/utils/pro_base_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

Future<void> whatsappFunc(String contactNo) async {
  log('whatsapping: $contactNo');
  String url() {
    if (Platform.isIOS) {
      return "https://wa.me/$contactNo";
    } else {
      return "https://api.whatsapp.com/send?phone=$contactNo";
    }
  }

  await customLaunch(url());
}

Future<dynamic> showCupertinoPicker(
    List<Widget> cupertinoItemWidget, Function(int) onSelectedChangedFunction,
    {double itemExtend = 50,
    int index = 0,
    VoidCallback doneButton,
    VoidCallback cancelButton,
    bool dismissible = false}) {
  return Get.bottomSheet(
      Container(
        height: 250,
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 4,
                  width: 30,
                  //margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: cancelButton,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    // color: themeRed,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: themeColor, fontSize: 16.0),
                    ),
                  ),
                ),
                Container(
                  // color: themeGrey,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: InkWell(
                    onTap: doneButton,
                    child: const Text(
                      'Done',
                      style: TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              width: double.infinity,
              child: CupertinoPicker(
                //scrollController: ,
                scrollController:
                    FixedExtentScrollController(initialItem: index),
                magnification: 1,
                itemExtent: itemExtend,
                looping: false,
                children: cupertinoItemWidget,
                onSelectedItemChanged: onSelectedChangedFunction,
              ),
            ))
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.white);
}

Future<dynamic> showConfirmImage(
  BuildContext context,
  String message, {
  File file,
  VoidCallback confirm,
  String negative = 'No',
  String positive = 'Yes',
  String title = '',
  VoidCallback cancel,
  bool canBackPress = true,
  bool isCircleImage = false,
}) async {
  // flutter defined function
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // return object of type Dialog
      return WillPopScope(
        onWillPop: () {
          return Future.value(canBackPress);
        },
        child: AlertDialog(
          backgroundColor: themeWhite,
          // contentPadding: EdgeInsets.all(10),
          title: title != ''
              ? Text(title, style: const TextStyle(color: themeBlack))
              : null,
          content: isCircleImage
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(message, style: const TextStyle(color: themeBlack)),
                      const SizedBox(height: 20),
                      if (file != null)
                        ClipOval(
                            child: Image.file(file,
                                height: 200, width: 200, fit: BoxFit.cover)),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  //constraints: BoxConstraints(maxHeight: 310),
                  child: Column(
                    children: [
                      Text(message, style: const TextStyle(color: themeBlack)),
                      const SizedBox(height: 20),
                      if (file != null)
                        Image.file(file, height: 250, fit: BoxFit.contain),
                    ],
                  ),
                ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(negative),
              onPressed: () {
                // Navigator.of(context).pop(false);
                Get.back(result: false);
                if (cancel != null) {
                  cancel();
                }
              },
            ),
            TextButton(
              child: Text(positive),
              onPressed: () {
                // Navigator.of(context).pop(true);
                Get.back(result: true);
                if (confirm != null) {
                  confirm();
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

void showFlash(BuildContext context, String title, String message,
    {Function(GetSnackBar) onTap}) {
  Get.snackbar(
    title,
    message,
    colorText: themeTextGrey,
    snackPosition: SnackPosition.TOP, //Immutable
    reverseAnimationCurve: Curves.decelerate, //Immutable
    forwardAnimationCurve: Curves.easeOut, //Immutable
    isDismissible: true,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
    borderRadius: 9,
    backgroundColor: Colors.white,
    boxShadows: [
      const BoxShadow(
        color: Colors.black45,
        blurRadius: 12.0,
        offset: Offset(6.0, 6.0),
      ),
    ],
    duration: const Duration(seconds: 3),
    onTap: onTap,
  );
}

void showFlashWithIcon(String message) {
  Get.showSnackbar(GetSnackBar(
    messageText:
        Text(message, style: const TextStyle(fontSize: 16, color: colorBlack)),
    snackPosition: SnackPosition.TOP,
    snackStyle: SnackStyle.FLOATING,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    duration: const Duration(seconds: 3),
    icon: const Icon(Icons.check_circle, size: 20, color: colorBlack),
    borderRadius: 6,
    backgroundColor: colorBlack,
  ));
}

Future<bool> showBlockClose() {
  return Get.dialog(
        AlertDialog(
          title: const Text('Notice', style: TextStyle(color: themeBlack)),
          titleTextStyle: const TextStyle(color: themeBlack),
          content: const Text('Are you sure you would like to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: true);
                exitApp();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ) ??
      false;
}

Future<bool> showAlert(String title,
    {VoidCallback confirm, actionLabel = 'OK'}) async {
  // flutter defined function
  return Get.dialog(
          AlertDialog(
            title: Text(title),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: Text(actionLabel),
                onPressed: () {
                  // Navigator.of(context).pop(true);
                  Get.back(result: true);
                  if (confirm != null) {
                    confirm();
                  }
                },
              ),
            ],
          ),
          barrierDismissible: false) ??
      false;
}

Future<bool> showConfirmation(
  String message, {
  VoidCallback confirm,
  String actionLabel = 'OK',
  bool autoPop = true,
  bool disallowBackBtn = false,
}) async {
  void _handleBackPress() {
    disallowBackBtn ? confirm() : Get.back();
  }

  Future<bool> shouldPop() async {
    _handleBackPress();
    return false;
  }

  // flutter defined function
  return Get.dialog(
          WillPopScope(
            onWillPop: shouldPop,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              content: Text(message),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                TextButton(
                  child: Text(
                    actionLabel,
                    style: const TextStyle(color: colorBlack, fontSize: 16),
                  ),
                  onPressed: () {
                    if (autoPop) {
                      // Navigator.of(context).pop(true);
                      Get.back(result: true);
                    }
                    if (confirm != null) {
                      confirm();
                    }
                  },
                ),
              ],
            ),
          ),
          barrierDismissible: false) ??
      false;
}

Future<bool> showConfirmCancel(String title, String message,
    {VoidCallback confirm,
    VoidCallback cancel,
    String negative = 'Cancel',
    String positive = 'OK'}) async {
  // flutter defined function
  return Get.dialog(
          AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: Text(negative),
                onPressed: () {
                  // Navigator.of(context).pop(true);
                  Get.back(result: true);
                  if (cancel != null) {
                    cancel();
                  }
                },
              ),
              TextButton(
                child: Text(
                  positive,
                ),
                onPressed: () {
                  // Navigator.of(context).pop(true);
                  Get.back(result: true);
                  if (confirm != null) {
                    confirm();
                  }
                },
              ),
            ],
          ),
          barrierDismissible: false) ??
      false;
}

Future<int> showCupertinoActionSheet(BuildContext context, List<String> list,
    {String title}) {
  var listWidget = <Widget>[];
  for (var i = 0; i < list.length; i++) {
    listWidget.add(CupertinoActionSheetAction(
      child: Text(list[i]),
      onPressed: () {
        // Navigator.of(context).pop(i);
        Get.back(result: i);
      },
    ));
  }

  CupertinoActionSheet dialog = CupertinoActionSheet(
    title: title != null && title != '' ? Text(title) : null,
    actions: listWidget,
    cancelButton: CupertinoActionSheetAction(
      child: const Text('Cancel'),
      onPressed: () {
        // Navigator.of(context).pop();
        Get.back();
      },
    ),
  );

  return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      });
}

void openRoute(BuildContext context, double latitude, double longitude) async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    var mapSchema = 'geo:$latitude,$longitude?q=$latitude,$longitude';
    if (await customLaunch('geo:')) {
      customLaunch(mapSchema);
    } else {
      showConfirmation('Please install waze or google map to start navigator');
    }
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    bool canMap = await customLaunch('waze://');
    if (!canMap) {
      bool canGoogleMap = await customLaunch('comgooglemaps://');
      if (canGoogleMap) {
        customLaunch(
            'comgooglemaps://?saddr=&daddr=$latitude,$longitude&directionsmode=driving');
      } else {
        showConfirmation(
            'Please install waze or google map to start navigator');
      }
    } else {
      customLaunch('waze://?ll=$latitude,$longitude&navigate=yes&zoom=17');
    }
  }
}

Future launchURL(BuildContext context, String url, {bool pop = true}) async {
  if (url == null || url == '') {
    return;
  } else if (await customLaunch(url)) {
    if (pop) Get.back();
    await customLaunch(url);
  } else {
    showConfirmation('Could not launch URL');
    throw 'Could not launch $url';
  }
}

Future<bool> customLaunch(String url) async {
  if (url?.isEmpty ?? true) return null;
  return launchUrl(Uri.parse(url));
}

Future<bool> customCanLaunch(String url) async {
  return await canLaunchUrl(Uri.parse(url));
}

void dismissKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

Future<bool> openForceUpdateDialog(BuildContext context,
    {String title, String message}) async {
  if (title == null || title == '') {
    title = 'New Version Available';
  }
  if (message == null || message == '') {
    message =
        'There is a newer version available for download! Please update the app by visiting the ';
    if (Platform.isAndroid) {
      message += 'Play Store';
    } else {
      message += 'App Store';
    }
  }
  Get.dialog(
          AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  openAppStore();
                },
              ),
            ],
          ),
          barrierDismissible: false)
      .then((_) => false);
}

void openAppStore() async {
  String url;
  if (Platform.isAndroid) {
    bool isHMS = await ProBaseState.isHMS();
    if (isHMS &&
        (ProBaseState.hmsAppID != null && ProBaseState.hmsAppID != '')) {
      url =
          'https://appgallery.cloud.huawei.com/marketshare/app/C${ProBaseState.hmsAppID}';
    } else {
      url = 'https://play.google.com/store/apps/details?id=$packageName';
    }
  } else {
    url = 'https://itunes.apple.com/us/app/id${ProBaseState.iosAppID}?mt=8';
  }

  if (await customCanLaunch(url)) {
    log('opening: $url');
    await customLaunch(url);
  }
}

void makePhoneCall(String phoneNumber) {
  if (phoneNumber != null) {
    phoneNumber = phoneNumber.replaceAll(' ', '');
    if (Platform.isAndroid) {
      customLaunch('tel:$phoneNumber}');
    } else {
      customLaunch('tel://$phoneNumber');
    }
  }
}

void makePhoneCallToCallCenter(BuildContext context, {String number = ''}) {
  if (Platform.isAndroid) {
    customLaunch('tel:$number');
  } else {
    customLaunch('tel://${number.replaceAll(' ', '') ?? number}');
  }
}

Future<File> downloadFile(String url, String filename) async {
  var httpClient = HttpClient();
  var request = await httpClient.getUrl(Uri.parse(url));
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = File('$dir/$filename');
  await file.writeAsBytes(bytes);
  return file;
}

void exitApp() async {
  await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
}

Future<bool> showConfirmationWithoutTitle(String message,
    {VoidCallback confirm, actionLabel = 'OK'}) async {
  // flutter defined function
  return Get.dialog(
          AlertDialog(
            content: Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  // Navigator.of(context).pop(true);
                  Get.back(result: true);
                  if (confirm != null) {
                    confirm();
                  }
                },
              ),
            ],
          ),
          barrierDismissible: false) ??
      false;
}

Future<bool> showConfirmationWithTitle(
  String title,
  String message, {
  VoidCallback confirm,
  actionLabel = 'OK',
  bool autoPop = true,
}) async {
  // flutter defined function
  return Get.dialog(
          AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  if (autoPop) {
                    // Navigator.of(context).pop(true);
                    Get.back(result: true);
                  }
                  if (confirm != null) {
                    confirm();
                  }
                },
              ),
            ],
          ),
          barrierDismissible: false) ??
      false;
}

Future<bool> showConfirmCancelWithoutTitle(String message,
    {VoidCallback confirm,
    String negative = 'Cancel',
    String positive = 'OK'}) async {
  // flutter defined function
  return Get.dialog(
          AlertDialog(
            content: Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  // Navigator.of(context).pop(false);
                  Get.back(result: false);
                },
              ),
              TextButton(
                child: const Text(
                  'Yes',
                ),
                onPressed: () {
                  Get.back(result: true);
                  if (confirm != null) {
                    confirm();
                  }
                },
              ),
            ],
          ),
          barrierDismissible: false) ??
      false;
}

Future<int> showListDialogWithoutTitle(List<String> list) {
  var listWidget = <Widget>[];
  for (var i = 0; i < list.length; i++) {
    listWidget.add(InkWell(
      onTap: () {
        // Navigator.of(context).pop(i);
        Get.back(result: i);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(list[i]),
        ),
      ),
    ));
  }

  SimpleDialog dialog = SimpleDialog(
    children: listWidget,
  );

  return Get.dialog(dialog) ?? -1;
}

void openCustomDialog(BuildContext context, Widget customDialogWidget) {
  Get.dialog(customDialogWidget);
}

Widget loader(bool isLoading, {String label = '', Color color = Colors.white}) {
  return (isLoading
      ? GestureDetector(
          child: ProBaseState.loadingWidget ??
              Container(
                  color: colorBlack12,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  )),
          onTap: () {},
        )
      : const Center());
}

AppBar customerAppBar(String title) {
  return AppBar(
    title: Text(title ?? ""),
    centerTitle: true,
    actions: [
      IconButton(
          onPressed: () {
            // Get.find<GlobalController>().switchLanguage();
          },
          icon: const Icon(Icons.book))
    ],
  );
}

Widget checkBoxLabel(
    bool isChecked, String label, ValueChanged<bool> callback) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 0.0),
        child: Theme(
          data: ThemeData(
            unselectedWidgetColor: Colors.grey,
            disabledColor: colorBlack,
          ),
          child: SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                activeColor: colorBlack,
                checkColor: colorWhite,
                value: isChecked,
                onChanged: callback),
          ),
        ),
      ),
      if ((label ?? "").isNotEmpty) const SizedBox(width: 10),
      if ((label ?? "").isNotEmpty)
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: colorBlack, fontSize: 14),
          ),
        )
    ],
  );
}
