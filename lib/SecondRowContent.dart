import 'package:flutter/material.dart';
import 'HorizontalMenu.dart';
import 'Utility/AppColor.dart';

class SecondRowContent extends StatefulWidget {

 final Function(String) onContentSelected;
 final Function() incrementIndexCallback;
 const SecondRowContent({
    Key? key,
    required this.onContentSelected,
    required this.incrementIndexCallback,
  }) : super(key: key);


void updateSelectedIndex(Function() incrementIndexCallback) {
  incrementIndexCallback();

  /*int selectedIndex = (SecondRowContent.secondRowContentKey.currentState?._selectedMenuItem ?? 0) + 1;
SecondRowContent.secondRowContentKey.currentState?._selectedMenuItem = selectedIndex;
  SecondRowContent.secondRowContentKey.currentState?.setState(() {
    print('Updated Index: $selectedIndex');
    SecondRowContent.secondRowContentKey.currentState?._selectedMenuItem = selectedIndex;
  });*/
}

  @override
  _SecondRowContentState createState() => _SecondRowContentState();

  static GlobalKey<_SecondRowContentState> secondRowContentKey =
      GlobalKey<_SecondRowContentState>();

  
}

class _SecondRowContentState extends State<SecondRowContent> {
  int _selectedMenuItem = 0;
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Implement back button action here
                },
              ),
              const Expanded(
                child: Text(
                  'Visit',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8.0),
                width: 130, // Set your desired width here
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedOption == null || _selectedOption!.isEmpty
                        ? AppColors.primaryColor // Border color when no option is selected
                        : AppColors.primaryColor, // Border color when an option is selected
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(4.0), // Optional: Add border radius
                ),
                child: DropdownButton<String>(
                  value: _selectedOption ?? 'Applicant 1',
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue;
                    });
                    // Implement dropdown action here
                  },
                  items: <String>['Applicant 1', 'Applicant 2', 'Applicant 3']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                    padding: const EdgeInsets.only(left: 8.0), 
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    );
                  }).toList(),
                  icon: const Row(
                    children: [
                      Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 1), // Add some space between icon and text
                    ],
                  ),
                  underline: Container(), // Hide the default underline
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // Add some space between the rows
          HorizontalMenu(
            menuItems: const [
              'KYC Details', 'Personal Details', 'Family Details', 
              'Loan Details', 'Business Details', 'Address Details', 
              'Property Details', 'Banking Details','Insurance Questionnaries', 'Documents'
            ],
            selectedIndex: _selectedMenuItem,
            onItemSelected: (index) {
              setState(() {
                _selectedMenuItem = index;
              });
              // Implement menu item selection action here
            },
            onContentSelected: widget.onContentSelected,
          ),
        ],
      ),
    );
  }
}
