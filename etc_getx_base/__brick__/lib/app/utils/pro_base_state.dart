import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:{{project_route}}/app/utils/constants.dart';

typedef GeneralErrorHandle = bool Function(
    BuildContext context, int code, String message);

class ProBaseState {
  //set a default loading widget if needed.
  static Widget loadingWidget;

  //set customise default app bar if needed.
  static AppBar defaultAppBar;

  //set the statusBarText into white, default false(black).
  static bool statusBarTextWhiteColor = false;

  //set the statusBar background color into your desired color.
  static Color statusBarBackgroundColor;

  //a General Error Handle all all pages using this.
  static GeneralErrorHandle onFailed;

  //by default have a function called forceUpdate(), which straight redirect user to the store when needed, but ios and hms required to manually insert the id.
  static String iosAppID;
  static String hmsAppID;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // override the default error widget by doing so -> ErrorWidget.builder = ProBaseState.customErrorWidget;
  static Widget customErrorWidget(FlutterErrorDetails error) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(top: 30, bottom: 10),
                child: Icon(Icons.warning_amber_outlined,
                    size: 50, color: Colors.red[900])),
            const Text('Something Went Wrong',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            const Text(
                'We has encountered an error. If this problem persists, contact us at $Company_email',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            InkWell(
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  // color: themeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  child: const Center(
                      child: Text('Close',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500))),
                  onTap: () {
                    // var key = Get.key;
                    // Navigator.of(navigatorKey.currentContext)
                    //     .pushAndRemoveUntil(
                    //         MaterialPageRoute(
                    //             builder: (context) => ProRoute(
                    //                   HomePage,
                    //                   gotAppBar: false,
                    //                   key: key,
                    //                   childKey: UniqueKey(),
                    //                   closePopup: true,
                    //                 )),
                    //         (route) => route == null);
                  },
                ),
              ),
            ),
          ]),
    );
  }

  static Widget debugErrorWidget(FlutterErrorDetails error) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: <Widget>[
        Container(
            padding: const EdgeInsets.only(top: 30, bottom: 10),
            child: const Icon(Icons.announcement, size: 40, color: Colors.red)),
        const Text(
          'An application error has occurred.',
          style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: Colors.orangeAccent),
        ),
        Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Error message:',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline)),
                Text(
                  error.exceptionAsString(),
                  style: const TextStyle(color: Colors.orangeAccent),
                ),
              ],
            )),
        Expanded(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Stack Trace:',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline)),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Text(
                    error.stack.toString(),
                    style: const TextStyle(color: Colors.orangeAccent),
                  ))),
                ],
              )),
        ),
      ]),
    );
  }

  static const MethodChannel _methodChannel =
      MethodChannel('com.etctech.recycle_detector/ml');

  static Future<bool> isHMS() async {
    try {
      bool result = await _methodChannel.invokeMethod('isHmsAvailable');
      return result;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> isGMS() async {
    try {
      bool result = await _methodChannel.invokeMethod('isGmsAvailable');
      return result;
    } on PlatformException {
      log('Failed to get _isGmsAvailable.');
      return false;
    }
  }

  static void lockScreenOrientation(DeviceOrientation orientation) {
    SystemChrome.setPreferredOrientations([
      orientation,
    ]);
  }

  static void allowedOrientation(List<DeviceOrientation> orientationList) {
    SystemChrome.setPreferredOrientations(orientationList);
  }
}
