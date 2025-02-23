import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_flutter/models/DesktopFile.dart';
import 'package:tv_flutter/utilities/desktop_parser.dart';

enum ItemType { app, website }

class Item {
  String name;
  String command;
  ItemType type;
  String icon;

  Item({
    required this.name,
    required this.command,
    required this.type,
    required this.icon,
  });
}

class DashboardListProvider
    extends AutoDisposeAsyncNotifier<Map<String, List<Item>>> {
  Future<Map<String, List<Item>>> _loadApps() async {
    var apps = <String, List<Item>>{};

    var desktopFiles = await getDesktopFiles();

    for (var desktopFile in desktopFiles) {
      for (var category in desktopFile.categories ?? []) {
        if (!apps.containsKey(category)) {
          apps[category] = [];
        }

        var iconPath = await getIconPath(desktopFile.icon);
        if (iconPath == null) {
          print(desktopFile.icon);
        }

        apps[category]?.add(
          Item(
            name: desktopFile.name,
            command: desktopFile.exec ?? '',
            type: ItemType.app,
            icon: iconPath ?? "",
          ),
        );
      }
    }

    return apps;
  }

  @override
  FutureOr<Map<String, List<Item>>> build() async {
    return _loadApps();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _loadApps();
    });
  }
}

final dashboardListProvider = AsyncNotifierProvider.autoDispose<
  DashboardListProvider,
  Map<String, List<Item>>
>(DashboardListProvider.new);
