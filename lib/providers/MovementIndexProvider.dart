import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    extends AutoDisposeFamilyNotifier<MovementInfo, MovementInfo> {
  @override
  build(arg) {
    return arg;
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
      return;
    }

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
    .autoDispose<MovementInfoProvider, MovementInfo, MovementInfo>(
      MovementInfoProvider.new,
    );
