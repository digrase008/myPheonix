import 'package:flutter/material.dart';
import '../Utility/AppColor.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClearAll;
  final VoidCallback? onAdd;
  final bool isExpanded; // Expansion state

  const CustomHeader({super.key, 
    required this.title,
    this.onClearAll,
    this.onAdd,
    required this.isExpanded, // Receive expansion state
  });

  @override
 Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(12.0),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
      color: Colors.white,
    ),
    child: Stack( // Use Stack to overlay the underline
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            Row(
              children: [
                if (onClearAll != null)
                  TextButton(
                    onPressed: onClearAll,
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                      side: MaterialStateProperty.all(
                        const BorderSide(
                          width: 1.0,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(width: 2),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.0),
                    onTap: onAdd,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        isExpanded ? Icons.remove : Icons.add, // Toggle icon based on expansion state
                        color: AppColors.primaryColor,
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
       // GIVE LITTLE gap between underline 
        Positioned( // Positioned widget to place the underline at the bottom
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 1.0,
            color: Colors.grey, // Color of the underline
          ),
        ),
      ],
    ),
  );
}

}
