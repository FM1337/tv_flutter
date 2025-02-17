import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_flutter/providers/MovementLocationProvider.dart';

class DashboardCard extends ConsumerWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color activeColor;
  final bool isActive;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.activeColor,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var loc = ref.watch(movementLocationProvider);

    var localIsActive = isActive && loc == MovementLocation.page;
    if (localIsActive) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (context.mounted) {
          Scrollable.ensureVisible(
            context,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,

            alignment: 1,
          );
        }
      });
    }

    return Card(
      // want a border with a color
      color: Colors.blueGrey,
      shape:
          localIsActive
              ? RoundedRectangleBorder(
                side: BorderSide(color: activeColor, width: 7),
                borderRadius: BorderRadius.circular(10),
              )
              : null,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.network(
                  "https://picsum.photos/250?image=9",
                  width: 250,
                  height: 250,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
