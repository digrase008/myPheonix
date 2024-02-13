import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/AppColor.dart';

Widget buildDateOfBirthField(BuildContext context, String title, TextEditingController controller, {bool isMandatory = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
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
        Container(
          decoration: BoxDecoration(
            color: AppColors.fieldBackground,
            border: Border.all(width: 1.0, color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  readOnly: true,
                  onTap: () {
                    _selectDate(context, controller); // Pass the controller to the date picker function
                  },
                  decoration: const InputDecoration(
                    hintText: 'Select Date',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryColor,
                ),
                onPressed: () {
                  _selectDate(context, controller); // Pass the controller to the date picker function
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Function to select date
Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );

  if (pickedDate != null) {
    // Handle selected date
    String formattedDate = pickedDate.toLocal().toString().split(' ')[0]; // Format the date as needed
    controller.text = formattedDate; // Set the selected date to the text field
  }
}
