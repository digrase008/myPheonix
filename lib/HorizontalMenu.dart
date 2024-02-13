import 'package:flutter/material.dart';
import 'Utility/AppColor.dart';

class HorizontalMenu extends StatelessWidget {
  final List<String> menuItems;
  final Function(int) onItemSelected;
  final Function(String) onContentSelected;
  final int selectedIndex;

  const HorizontalMenu({
    Key? key,
    required this.menuItems,
    required this.onItemSelected,
    required this.onContentSelected,
    required this.selectedIndex,
  }) : super(key: key);

  void updateSelectedIndex() {
    print('Received callback in HorizontalMenu - Update Index');
    // Add logic to update the selected index or perform necessary actions
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0), // Add extra space at the bottom
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(menuItems.length, (index) {
            return GestureDetector(
              onTap: () {
                onItemSelected(index);
                onContentSelected(menuItems[index]);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  menuItems[index],
                  style: TextStyle(
                    color: selectedIndex == index ? AppColors.primaryColor : Colors.grey,
                    fontWeight: FontWeight.w600,
                    decoration: selectedIndex == index ? TextDecoration.underline : TextDecoration.none,
                    decorationThickness: selectedIndex == index ? 1.0 : null,
                    fontSize: 20,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
