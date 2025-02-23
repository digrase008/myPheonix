import 'package:flutter/material.dart';
import 'package:my_pheonix/FormController/UIElements/SearchFieldWidget.dart';
import 'package:my_pheonix/Utility/AppColor.dart';
import 'package:my_pheonix/FormController/UIElements/BulletSelectionWidget.dart';

class KYCExitingCustomerView extends StatelessWidget {
  final Function(String) onCustomerSelection;
  final Function(String) onCustomerSearch;
  const KYCExitingCustomerView(
      {Key? key,
      required this.onCustomerSelection,
      required this.onCustomerSearch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController selectionController = TextEditingController();
    TextEditingController searchController = TextEditingController();
    List<String> options = ['New', 'Existing'];

    void handleSelection(String selectedOption) {
      // This function will receive the selected option ("New" or "Existing")
      onCustomerSelection(selectedOption);
      // If customer if existing show search field with search button or else don't shoe search field
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(width: 1.0, color: AppColors.appGreyColor),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                BulletSelectionWidget(
                  question: 'New or Existing Customer?',
                  options: options,
                  selectionController: selectionController,
                  onSelection:
                      handleSelection, // Use the provided callback here
                ),
                const SizedBox(height: 20),
                SearchFieldWidget(
                  controller: searchController, // Pass your controller here
                  onPressed: () {
                    // Logic for search button
                    String searchText = searchController.text;
                    onCustomerSearch(searchText);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
