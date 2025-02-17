import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_flutter/providers/MovementIndexProvider.dart';
import 'package:tv_flutter/providers/MovementLocationProvider.dart';
import 'package:tv_flutter/widgets/dashboard_list.dart';

class Dashboard extends ConsumerWidget {
  Dashboard({super.key});

  final info = MovementInfo(
    key: "dash",
    focusNode: FocusNode(),
    mode: MovementLocation.page,
    rowColumnsCount: [8, 8, 8, 8],
    rowPositions: [0, 0, 0, 0],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movement = ref.watch(movementInfoProvider(info));
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

        if (value.physicalKey == PhysicalKeyboardKey.arrowUp) {
          ref.read(movementInfoProvider(info).notifier).moveUp();
        } else if (value.physicalKey == PhysicalKeyboardKey.arrowDown) {
          ref.read(movementInfoProvider(info).notifier).moveDown();
        } else if (value.physicalKey == PhysicalKeyboardKey.arrowLeft) {
          ref.read(movementInfoProvider(info).notifier).moveLeft();
        } else if (value.physicalKey == PhysicalKeyboardKey.arrowRight) {
          ref.read(movementInfoProvider(info).notifier).moveRight();
        }
      },

      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            spacing: 100,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardList(
                title: "Recent",
                isActive: movement.currentY == 0,
                activeIndex: movement.rowPositions[0],
              ),
              DashboardList(
                title: "Applications",
                isActive: movement.currentY == 1,
                activeIndex: movement.rowPositions[1],
              ),
              DashboardList(
                title: "Games",
                isActive: movement.currentY == 2,
                activeIndex: movement.rowPositions[2],
              ),
              DashboardList(
                title: "Games",
                isActive: movement.currentY == 3,
                activeIndex: movement.rowPositions[3],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
