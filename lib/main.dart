import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_flutter/pages/dash.dart';
import 'package:tv_flutter/widgets/system_bar.dart';

final _router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(name: "home", path: "/", builder: (context, state) => Dashboard()),
  ],
);

void main() {
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  MainApp({super.key});
  final bar = SystemBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: _router,
      builder: (context, child) {
        return Scaffold(appBar: bar, body: child);
      },
    );
  }
}
