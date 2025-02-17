import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MovementLocation { appBar, page, overlay }

class MovementLocationProvider extends AutoDisposeNotifier<MovementLocation> {
  @override
  MovementLocation build() {
    return MovementLocation.page;
  }

  void setLocation(MovementLocation location) {
    state = location;
  }
}

final movementLocationProvider =
    NotifierProvider.autoDispose<MovementLocationProvider, MovementLocation>(
      () => MovementLocationProvider(),
    );
