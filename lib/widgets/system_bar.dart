import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_flutter/providers/MovementIndexProvider.dart';
import 'package:tv_flutter/providers/MovementLocationProvider.dart';
import 'package:tv_flutter/widgets/current_time.dart';

class SystemBar extends ConsumerWidget implements PreferredSizeWidget {
  SystemBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  final info2 = MovementInfo(
    key: "appbar",
    focusNode: FocusNode(),
    mode: MovementLocation.appBar,
    rowColumnsCount: [2],
    rowPositions: [0],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movement = ref.watch(movementInfoProvider(info2));
    final loc = ref.watch(movementLocationProvider);

    if (!movement.focusNode.hasFocus && loc == MovementLocation.appBar) {
      Future.delayed(Duration(milliseconds: 10), () {
        movement.focusNode.requestFocus();
      });
    }

    return KeyboardListener(
      focusNode: movement.focusNode,
      onKeyEvent: (value) {
        if (value is KeyUpEvent || loc != MovementLocation.appBar) {
          return;
        }

        if (value.physicalKey == PhysicalKeyboardKey.arrowUp) {
          ref.read(movementInfoProvider(info2).notifier).moveUp();
        } else if (value.physicalKey == PhysicalKeyboardKey.arrowDown) {
          ref.read(movementInfoProvider(info2).notifier).moveDown();
        } else if (value.physicalKey == PhysicalKeyboardKey.arrowLeft) {
          ref.read(movementInfoProvider(info2).notifier).moveLeft();
        } else if (value.physicalKey == PhysicalKeyboardKey.arrowRight) {
          ref.read(movementInfoProvider(info2).notifier).moveRight();
        }
      },
      child: AppBar(
        title: CurrentTime(),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
        actions: [
          Icon(
            Icons.settings,
            color:
                movement.rowPositions[0] == 0 && loc == MovementLocation.appBar
                    ? Colors.orange
                    : Colors.white,
          ),
          Icon(
            Icons.power,
            color:
                movement.rowPositions[0] == 1 && loc == MovementLocation.appBar
                    ? Colors.orange
                    : Colors.white,
          ),
        ],
      ),
    );
  }
}
