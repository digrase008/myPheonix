import 'package:flutter/material.dart';
import '../Utility/AppColor.dart';

class FloatingFooterView extends StatelessWidget {
  final Function() onBackButtonPressed;
  final Function() onSaveButtonPressed;

  const FloatingFooterView({
    Key? key,
    required this.onBackButtonPressed,
    required this.onSaveButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.grey),
          bottom: BorderSide(width: 1.0, color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15.0),
              child: TextButton(
                onPressed: onBackButtonPressed,
                style: ButtonStyle(
                  side: WidgetStateProperty.all(
                    const BorderSide(
                        width: 1.0,
                        color: Colors.white // AppColors.primaryColor,
                        ),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    '',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 15.0),
              child: ElevatedButton(
                onPressed: onSaveButtonPressed,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Text(
                  'Save',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
