import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/AppColor.dart';

class SearchFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPressed;
  final String? initialText;

  const SearchFieldWidget({
    Key? key,
    required this.controller,
    required this.onPressed,
    this.initialText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(width: 1.0, color: Colors.grey),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                  color: Colors.white,
                ),
                child: const Center(
                  child: Icon(
                    Icons.search,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
            height: 10), // Adjust the space between the text field and button
        SizedBox(
          height: 50,
          width: 60,
          child: ElevatedButton(
            onPressed: () {
              // Update the controller's text property here
              controller.text = controller.text;
              onPressed(); // Call the provided onPressed callback
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              side: const BorderSide(color: AppColors.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text(
              'Search',
              style: TextStyle(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
