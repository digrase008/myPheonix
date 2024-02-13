import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/AppColor.dart';

class BulletSelectionWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final TextEditingController selectionController; // Text editing controller for selection
  final Function(String)? onSelection;

  const BulletSelectionWidget({super.key, 
    required this.question,
    required this.options,
    required this.selectionController,
    this.onSelection,
  });

  @override
  _BulletSelectionWidgetState createState() => _BulletSelectionWidgetState();
}

class _BulletSelectionWidgetState extends State<BulletSelectionWidget> {
  int _selectedOptionIndex = -1; // Keep track of selected option index
  bool showError = false;

 @override
  void initState() {
    super.initState();
    _selectedOptionIndex = widget.options.indexOf(widget.selectionController.text);
  }

  // Validator for BulletSelectionWidget
   String? validateSelection() {
    if (_selectedOptionIndex == -1) {
      return 'Please select an option';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (value) => validateSelection(), // Validator function call
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                widget.question,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                for (int i = 0; i < widget.options.length; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedOptionIndex = i;
                        widget.selectionController.text = widget.options[i];
                      });

                      if (widget.onSelection != null) {
                        widget.onSelection!(widget.options[i]);
                      }

                      // Update the showError flag based on option selection
                      setState(() {
                        showError = _selectedOptionIndex == -1;
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedOptionIndex == i
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                            ),
                          ),
                          child: _selectedOptionIndex == i
                              ? const Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: AppColors.primaryColor,
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.options[i],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (state.hasError && _selectedOptionIndex == -1) // Display validation error if triggered
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

