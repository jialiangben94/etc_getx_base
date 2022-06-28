import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:{{project_route}}/app/routes/global_middleware.dart';
import 'package:{{project_route}}/app/ui/base/base_page.dart';

GetPage cGetPageInitial<T extends BasePage>(T page, {Bindings binding}) {
  return GetPage(name: page.routeName, page: () => page, binding: binding);
}

GetPage cGetPage<T extends BasePage>(T page, {Bindings binding}) {
  return GetPage(
      name: page.routeName,
      page: () {
        T _page = Get.arguments;
        return _page;
      },
      binding: binding,
      middlewares: [GlobalMiddleware()]);
}

Future<dynamic> loadPage(BasePage page) async {
  var result = await Get.toNamed(page.routeName, arguments: page);
  return result;
}

loadPageWithRemovePrevious(
  BasePage toRoute,
  BasePage fromRoute,
) {
  Get.offNamedUntil(toRoute.routeName, ModalRoute.withName(fromRoute.routeName),
      arguments: toRoute);
}

loadPageWithRemoveAllPrevious(
  BasePage page,
) {
  Get.offNamedUntil(page.routeName, (route) => route == null, arguments: page);
}

backTo(BasePage page) {
  Get.until((route) => Get.currentRoute == page.routeName);
}

T getController<T extends GetxController>(T controller) {
  if (Get.isRegistered<T>()) {
    return Get.find<T>();
  } else {
    return null;
  }
}
