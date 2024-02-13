import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/AppColor.dart';

class CustomFormField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final bool isMandatory;
  final String? Function(String?)? validator;
  final bool showValidation;

  const CustomFormField({
    Key? key,
    required this.title,
    required this.controller,
    this.isMandatory = true,
    required this.validator,
    this.showValidation = false,
  }) : super(key: key);

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late bool showValidation;

  @override
  void initState() {
    super.initState();
    showValidation = widget.showValidation;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: widget.controller,
                onChanged: (value) {
                  setState(() {
                    showValidation = value.isEmpty;
                    debugPrint('Show validation c id: $showValidation');
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                ),
              ),
            ],
          ),
        ),
        if (showValidation && widget.validator != null) // Ensure validator is not null
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Text(
              widget.validator!(widget.controller.text) ?? '',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}

