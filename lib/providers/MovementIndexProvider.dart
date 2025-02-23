import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_flutter/providers/DashboardListProvider.dart';
import 'package:tv_flutter/providers/MovementLocationProvider.dart';

class MovementInfo {
  final String key;
  final FocusNode focusNode;
  final MovementLocation mode;
  final List<int> rowColumnsCount;
  final List<int> rowPositions;
  final int currentY;

  MovementInfo({
    required this.rowColumnsCount,
    required this.mode,
    required this.key,
    required this.focusNode,
    required this.rowPositions,
    this.currentY = 0,
  });

  MovementInfo copyWith({
    List<int>? rowColumnsCount,
    MovementLocation? mode,
    String? key,
    FocusNode? focusNode,
    List<int>? rowPositions,
    int? currentY,
  }) {
    return MovementInfo(
      key: key ?? this.key,
      mode: mode ?? this.mode,
      focusNode: focusNode ?? this.focusNode,
      rowColumnsCount: rowColumnsCount ?? this.rowColumnsCount,
      rowPositions: rowPositions ?? this.rowPositions,
      currentY: currentY ?? this.currentY,
    );
  }
}

class MovementInfoProvider
    extends AutoDisposeFamilyNotifier<MovementInfo, String> {
  @override
  build(arg) {
    switch (arg) {
      case "dash":
        {
          var provider = ref.watch(dashboardListProvider);

          var result = provider.when(
            data: (data) {
              return MovementInfo(
                key: "dash",
                mode: MovementLocation.page,
                focusNode: FocusNode(),
                rowColumnsCount: List.generate(data.keys.length, (index) {
                  return data.values.elementAt(index).length;
                }),
                rowPositions: List.generate(data.length, (_) => 0),
              );
            },
            error: (_, _) {
              return MovementInfo(
                key: "dash",
                mode: MovementLocation.page,
                focusNode: FocusNode(),
                rowColumnsCount: [0],
                rowPositions: [0],
              );
            },
            loading: () {
              return MovementInfo(
                key: "dash",
                mode: MovementLocation.page,
                focusNode: FocusNode(),
                rowColumnsCount: [0],
                rowPositions: [0],
              );
            },
          );

          return result;
        }

      case "appbar":
        return MovementInfo(
          key: "appbar",
          mode: MovementLocation.appBar,
          focusNode: FocusNode(),
          rowColumnsCount: [2],
          rowPositions: [0],
        );
      default:
        return MovementInfo(
          key: "placeholder",
          mode: MovementLocation.overlay,
          focusNode: FocusNode(),
          rowColumnsCount: [0],
          rowPositions: [0],
        );
    }
  }

  void moveDown() {
    if (ref.read(movementLocationProvider) != state.mode) {
      return;
    }

    if (state.currentY < state.rowColumnsCount.length - 1) {
      state = state.copyWith(currentY: state.currentY + 1);
    } else if (ref.read(movementLocationProvider) == MovementLocation.appBar) {
      ref
          .read(movementLocationProvider.notifier)
          .setLocation(MovementLocation.page);
    }
  }

  void moveUp() {
    if (ref.read(movementLocationProvider) != state.mode) {
      return;
    }

    if (state.currentY > 0) {
      state = state.copyWith(currentY: state.currentY - 1);
    } else if (ref.read(movementLocationProvider) == MovementLocation.page) {
      ref
          .read(movementLocationProvider.notifier)
          .setLocation(MovementLocation.appBar);
    }
  }

  void moveRight() {
    if (ref.read(movementLocationProvider) != state.mode) {
      print('wat');
      print(state.mode);
      print(ref.read(movementLocationProvider));
      return;
    }

    print("ello");

    if (state.rowColumnsCount[state.currentY] - 1 >
        state.rowPositions[state.currentY]) {
      var local = state.rowPositions;
      local[state.currentY] = local[state.currentY] + 1;
      state = state.copyWith(rowPositions: local);
    }
  }

  void moveLeft() {
    if (ref.read(movementLocationProvider) != state.mode) {
      return;
    }

    if (state.rowPositions[state.currentY] > 0) {
      var local = state.rowPositions;
      local[state.currentY] = local[state.currentY] - 1;
      state = state.copyWith(rowPositions: local);
    }
  }
}

final movementInfoProvider = NotifierProvider.family
    .autoDispose<MovementInfoProvider, MovementInfo, String>(
      MovementInfoProvider.new,
    );
