import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_flutter/providers/DashboardListProvider.dart';
import 'package:tv_flutter/providers/MovementIndexProvider.dart';
import 'package:tv_flutter/providers/MovementLocationProvider.dart';
import 'package:tv_flutter/utilities/launcher.dart';
import 'package:tv_flutter/widgets/dashboard_list.dart';

class Dashboard extends ConsumerWidget {
  Dashboard({super.key});

  final movementKey = "dash";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movement = ref.watch(movementInfoProvider(movementKey));
    if (!movement.focusNode.hasFocus &&
        ref.read(movementLocationProvider) == MovementLocation.page) {
      Future.delayed(Duration(milliseconds: 10), () {
        movement.focusNode.requestFocus();
      });
    }

    return KeyboardListener(
      focusNode: movement.focusNode,
      onKeyEvent: (value) {
        if (value is KeyUpEvent ||
            ref.read(movementLocationProvider) != MovementLocation.page) {
          return;
        }

        if (value is KeyRepeatEvent &&
            value.physicalKey == PhysicalKeyboardKey.enter) {
          print("Would show overlay");
          ref
              .read(movementLocationProvider.notifier)
              .setLocation(MovementLocation.overlay);
          return;
        }

        if (value.physicalKey == PhysicalKeyboardKey.arrowUp) {
          ref.read(movementInfoProvider(movementKey).notifier).moveUp();
        } else if (value.physicalKey == PhysicalKeyboardKey.arrowDown) {
          ref.read(movementInfoProvider(movementKey).notifier).moveDown();
        } else if (value.physicalKey == PhysicalKeyboardKey.arrowLeft) {
          ref.read(movementInfoProvider(movementKey).notifier).moveLeft();
        } else if (value.physicalKey == PhysicalKeyboardKey.arrowRight) {
          ref.read(movementInfoProvider(movementKey).notifier).moveRight();
        } else if (value.physicalKey == PhysicalKeyboardKey.keyR) {
          ref.read(dashboardListProvider.notifier).refresh();
        } else if (value.physicalKey == PhysicalKeyboardKey.enter) {
          Future.delayed(Duration(milliseconds: 512), () {
            if (ref.read(movementLocationProvider) == MovementLocation.page) {
              var keyIndex = movement.currentY;
              var appIndex = movement.rowPositions[movement.currentY];
              ref.read(dashboardListProvider).whenData((data) {
                var app = data[data.keys.elementAt(keyIndex)]![appIndex];
                if (app.type == ItemType.website) {
                  launchWebsite(app.command);
                } else if (app.type == ItemType.app) {
                  launchApplication(app.command, true);
                }
              });
            }
          });
        }
      },

      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            spacing: 100,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ref
                .read(dashboardListProvider)
                .when(
                  data: (data) {
                    return List.generate(data.keys.length, (index) {
                      return DashboardList(
                        items: data.values.elementAt(index),
                        title: data.keys.elementAt(index),
                        isActive: movement.currentY == index,
                        activeIndex: movement.rowPositions[index],
                      );
                    });
                    // return DashboardList(
                    //   apps: data["apps"]!,
                    //   title: "Apps",
                    //   isActive: movement.currentY == 0,
                    //   activeIndex: movement.rowPositions[0],
                    // );
                  },
                  loading: () => [CircularProgressIndicator()],
                  error: (error, stack) => [Text("Error: $error")],
                ),
          ),
        ),
      ),
    );
  }
}
