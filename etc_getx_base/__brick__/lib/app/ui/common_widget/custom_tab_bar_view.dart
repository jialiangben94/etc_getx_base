import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTabBarView extends StatelessWidget {
  final List<String> tabList;
  final List<Widget> children;
  final TabController controller;
  final bool isScrollable;

  CustomTabBarView(
      {this.tabList,
      this.children,
      this.controller,
      this.isScrollable = true,
      Key key})
      : super(key: key);

  List<Tab> tabs = [];

  @override
  Widget build(BuildContext context) {
    tabs = tabList
        .map(
          (e) => Tab(
            text: e,
          ),
        )
        .toList();
    return Column(
      children: [_tabbar(), Expanded(child: _body())],
    );
  }

  Widget _tabbar() {
    return DefaultTabController(
      length: tabList.length,
      child: TabBar(
        controller: controller,
        tabs: tabs,
        labelColor: colorBlack,
        unselectedLabelColor: colorBlack,
        indicatorColor: colorBlack,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 3,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
        isScrollable: isScrollable,
      ),
    );
  }

  Widget _body() {
    return TabBarView(controller: controller, children: children);
  }
}
