import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/AppColor.dart';


Widget buildFormField(
  String title,
  TextEditingController controller, {
  bool isMandatory = true,
  String? Function(String?)? validator,
  bool showValidation = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isMandatory) // Conditionally show the asterisk
            const Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Text(
                '*', // Red asterisk to indicate mandatory field
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 8.0),
      Container(
        decoration: BoxDecoration(
          color: AppColors.fieldBackground,
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextFormField(
          controller: controller,
          validator: validator, // Set the validator function here
          decoration: const InputDecoration(
            border: InputBorder.none, // Removes the underline
            focusedBorder: InputBorder.none, // Removes the underline when focused
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0), // Adjust the padding
          ),
        ),
      ),
      // at any cost validation message is getting shown inside above box decoration which I don't want
      if (validator != null && showValidation)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Text(
            validator(controller.text) ?? '',
            style: const TextStyle(color: Colors.red),
          ),
        ),

        const SizedBox(height: 12.0),
    ],
  );
}
