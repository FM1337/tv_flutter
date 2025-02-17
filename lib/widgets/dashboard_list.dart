import 'package:flutter/material.dart';
import 'package:tv_flutter/widgets/dashboard_card.dart';

class DashboardList extends StatelessWidget {
  const DashboardList({
    super.key,
    required this.title,
    required this.isActive,
    required this.activeIndex,
  });

  final String title;
  final bool isActive;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    // ScrollController _scrollController = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 35)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 40,
            children: List.generate(10, (index) {
              return DashboardCard(
                title: "YouTube",
                value: "abc",
                icon: Icons.import_contacts,
                activeColor: Colors.red,
                isActive: isActive && activeIndex == index,
              );
            }),
          ),
        ),
      ],
    );
  }
}
