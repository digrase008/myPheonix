import 'package:flutter/material.dart';
import '../../Utility/AppColor.dart';

class KYCDetailsHeader extends StatelessWidget {
  const KYCDetailsHeader({super.key});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'KYC Details',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // Implement clear all button action
                    },
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
                      onTap: () {
                        // Implement add button action
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.add,
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
          Container(
            height: 1.0,
            color: Colors.grey, // Adjust color as needed
            margin: const EdgeInsets.symmetric(vertical: 8.0), // Add margin to space the line
          ),
        ],
      ),
    );
  }
}

