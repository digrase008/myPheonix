import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/AppColor.dart';


Widget buildDropdownField(
  String title,
  List<String> options,
  TextEditingController controller, {
  bool isMandatory = true,
  void Function(String?)? onChanged,
  GlobalKey<FormState>? dropdownKey,
}) {
  // GlobalKey to access the DropdownButtonFormField state

  String? dropdownValue = controller.text.isNotEmpty ? controller.text : null;
  bool showError = false; // Variable to track whether to show error message

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$title',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isMandatory)
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.fieldBackground,
                border: Border.all(width: 1.0, color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButtonFormField<String>(
                key: dropdownKey, // Assign the GlobalKey to the DropdownButtonFormField
                value: dropdownValue,
                items: options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (onChanged != null) {
                    onChanged(newValue);
                  }
                  dropdownValue = newValue;
                  controller.text = newValue ?? '';
                  showError = false;
                  // Call validate() to revalidate and update the validator message
                  dropdownKey?.currentState?.validate();
                },
                icon: const Icon(Icons.arrow_drop_down),
                style: const TextStyle(color: Colors.black),
                dropdownColor: AppColors.fieldBackground,
                iconEnabledColor: AppColors.primaryColor,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                validator: (value) {
                  showError = value == null && isMandatory;
                  return showError ? 'Please select $title' : null;
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
