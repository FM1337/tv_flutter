import 'package:flutter/material.dart';
import 'package:tv_flutter/providers/DashboardListProvider.dart';
import 'package:tv_flutter/widgets/dashboard_card.dart';
import 'package:collection/collection.dart';

class DashboardList extends StatelessWidget {
  const DashboardList({
    super.key,
    required this.title,
    required this.isActive,
    required this.activeIndex,
    required this.items,
  });

  final String title;
  final bool isActive;
  final int activeIndex;
  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 35)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 40,
            children:
                items.mapIndexed((index, item) {
                  return DashboardCard(
                    title: item.name,
                    icon: item.icon,
                    activeColor: Colors.red,
                    isActive: isActive && activeIndex == index,
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
