import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/AppColor.dart';

class DropDownWithItem extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final List<String> items;
  final bool isMandatory;

  const DropDownWithItem({
    Key? key,
    required this.title,
    required this.controller,
    this.items = const ['+1', '+91', '+44'],
    this.isMandatory = true,
  }) : super(key: key);

  @override
  _MobileNumberFieldState createState() => _MobileNumberFieldState();
}

class _MobileNumberFieldState extends State<DropDownWithItem> {
  late String dropdownValue; // Define dropdownValue in the state

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.items.first; // Initialize dropdownValue in initState
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.isMandatory)
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
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButton<String>(
                    items: widget.items.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: AppColors.primaryColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          dropdownValue = newValue; // Update dropdownValue with setState
                        });
                      }
                    },
                    underline: const SizedBox(), // Remove the underline for DropdownButton
                    value: dropdownValue, // Use dropdownValue from the state
                    icon: const Icon(
                      Icons.arrow_drop_down_outlined,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: widget.controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    // Add form field properties
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
