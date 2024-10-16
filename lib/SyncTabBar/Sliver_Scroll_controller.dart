import 'package:flutter/cupertino.dart';
import 'package:spicy_eats/SyncTabBar/CategoryModel.dart';
import 'package:spicy_eats/SyncTabBar/MyHeader.dart';

class SliverScrollController {
  //list of products
  late List<Category> listCategory;

  //list of offset value
  List<double> listOffSetitemHeader = [];

  //Header Notifier
  final headerNotifier = ValueNotifier<MyHeader?>(null);

  //Global offset value
  final globalOffsetValues = ValueNotifier<double>(0);

  //indicator if we are going up or down in a application
  final goingDown = ValueNotifier<bool>(false);

  //value to do the validations of the top icons
  final valueScroll = ValueNotifier<double>(0);

  //to move top items in sliver
  late ScrollController scrollControllerItemHeader;

  //to have overall controll of scrolling
  late ScrollController scrollControllerGlobally;

  void refreshHeader({
    required int index,
    required bool visible,
    required int? lastIndex,
  }) {
    final headerValue = headerNotifier.value;
    final headerTitle = headerValue?.index ?? index;
    final headerVisible = headerValue?.visible ?? false;

    if (headerTitle != index || lastIndex == null || headerVisible != visible) {
      Future.microtask(() {
        if (!visible && lastIndex != null) {
          headerNotifier.value = MyHeader(visible: true, index: lastIndex);
        } else {
          headerNotifier.value = MyHeader(visible: visible, index: index);
        }
      });
    }
  }
}
