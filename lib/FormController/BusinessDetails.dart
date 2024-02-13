import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/CustomerIDStorage.dart';
import 'package:my_pheonix/Utility/DatabaseHelper.dart';
import 'package:sqflite/sqlite_api.dart';
import '../Utility/AppColor.dart';
import 'FloatingFooterView.dart';
import 'CustomeHeader.dart';
import 'UIElements/TextField.dart';
import 'UIElements/DropDownField.dart';
import 'UIElements/DateOfBirthField.dart';
import 'UIElements/BulletSelectionWidget.dart';

class BusinessDetails extends StatefulWidget {
  const BusinessDetails({super.key});

  @override
  _BusinessDetailsState createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  bool isFormExpanded = true; // Track form expansion state

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final TextEditingController _businessName = TextEditingController();
   final TextEditingController _businessActivity = TextEditingController();
   final TextEditingController _businessClassification = TextEditingController();
   final TextEditingController _businessVintage = TextEditingController();
   final TextEditingController _businessExpirience = TextEditingController();
   final TextEditingController _businessOperatedBy = TextEditingController();
   final TextEditingController _businessPremisesStatus = TextEditingController();
   final TextEditingController _agreeementAvailablity = TextEditingController(); 
   final TextEditingController _businessRentalValidity = TextEditingController();

  @override
void initState() {
  super.initState();
  getBusinessDetailsForUserFromSQLite(CustomerIDStorage.customerID ?? '');
}



 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.appGreyColor,
    body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: Column(
        children: [
          CustomHeader(
            title: 'BUSINESS DETAILS',
            onClearAll: () {
              clearAllFields();
            },
            onAdd: () {
              setState(() {
                isFormExpanded = !isFormExpanded; // Toggle form expansion state
              });
            },
            isExpanded: isFormExpanded, // Pass expansion state to the CustomHeader
          ),
          Expanded(
            child: Visibility(
              visible: isFormExpanded, // Show only when form is expanded
              maintainSize: false,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isFormExpanded ? null : 0, // Set the height when expanded
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildFormField('Business Name', _businessName),
                        const SizedBox(height: 8),
                        buildDropdownField('Business Activity', ['Activity 1', 'Activity 2', 'Activity 3'], _businessActivity),
                        const SizedBox(height: 8),
                        buildDropdownField('Business Classification', ['Category 1', 'Category 2', 'Categoty 3'], _businessClassification),
                        const SizedBox(height: 8),
                        buildFormField('Business Vintage', _businessVintage),
                        const SizedBox(height: 8),
                        buildFormField('Overall Business Experiance', _businessExpirience),
                        const SizedBox(height: 8),
                        buildDropdownField('Business Operated By', ['Activity 1', 'Activity 2', 'Activity 3'], _businessOperatedBy),
                        const SizedBox(height: 8),
                        buildDropdownField('Business Premises Status', ['Category 1', 'Category 2', 'Categoty 3'], _businessPremisesStatus),
                        const SizedBox(height: 12),
                        BulletSelectionWidget(question: 'Rental Agreement Availablity', options: const ['YES', 'NO'], selectionController: _agreeementAvailablity,),
                        const SizedBox(height: 12),
                        buildDateOfBirthField(context, 'Rental Agreement Valid Upto', _businessRentalValidity)
                        // Add other form fields here as needed
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      
      )
      
    ),
    bottomNavigationBar: FloatingFooterView(
      onBackButtonPressed: () {

      },
      onSaveButtonPressed: () {
        saveBusinessDetailsToSQLite(CustomerIDStorage.customerID ?? '');
      },
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  );
}


void handleDropdownChange(String? newValue) {
  // Handle the change in dropdown value here
  setState(() {
    // Update state variables or perform any necessary actions
  });
}

void clearAllFields() {
  setState(() {
    _businessName.clear();
    _businessActivity.clear();
    _businessClassification.clear();
    _businessVintage.clear();
    _businessExpirience.clear();
    _businessOperatedBy.clear();
    _businessPremisesStatus.clear();
    _businessRentalValidity.clear();
    _agreeementAvailablity.clear();
    
    // Reset dropdown values
    _businessActivity.text = '';
    _businessClassification.text = '';
    _businessOperatedBy.text = '';
    _businessPremisesStatus.text = '';
    
    // Reset date fields to null or initial value
    _businessRentalValidity.text = ''; // For DateOfBirthField
    
    // Reset bullet selection
    _agreeementAvailablity.text = ''; // For BulletSelectionWidget
  });
}

void saveBusinessDetailsToSQLite(String customerId) async {
  Database db = await DatabaseHelper.instance.database;

  int result = await db.insert(
    'BusinessDetails',
    {
      'CustomerID': customerId,
      'BusinessName': _businessName.text,
      'BusinessActivity': _businessActivity.text,
      'BusinessClassification': _businessClassification.text,
      'BusinessVintage': _businessVintage.text,
      'BusinessExperiance': _businessExpirience.text,
      'BusinessOperatedBy': _businessOperatedBy.text,
      'BusinessPremises': _businessPremisesStatus.text,
      'AgreementAvailable': _agreeementAvailablity.text,
      'BusinessRental': _businessRentalValidity.text,
      // Add other columns and values for business details as needed
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  if (result != -1) {
    // Data successfully inserted
    showSuccessAlert(context);
  }
}

void getBusinessDetailsForUserFromSQLite(String userId) async {
  Database db = await DatabaseHelper.instance.database;
  List<Map<String, dynamic>> businessData = await db.query(
    'BusinessDetails',
    where: 'CustomerID = ?',
    whereArgs: [userId],
  );
  
  if (businessData.isNotEmpty) {
    setState(() {
      _businessName.text = businessData[0]['BusinessName'] ?? '';
      _businessActivity.text = businessData[0]['BusinessActivity'] ?? '';
      _businessClassification.text = businessData[0]['BusinessClassification'] ?? '';
      _businessVintage.text = businessData[0]['BusinessVintage'] ?? '';
      _businessExpirience.text = businessData[0]['BusinessExperiance'] ?? '';
      _businessOperatedBy.text = businessData[0]['BusinessOperatedBy'] ?? '';
      _businessPremisesStatus.text = businessData[0]['BusinessPremises'] ?? '';
      _agreeementAvailablity.text = businessData[0]['AgreementAvailable'] ?? '';
      _businessRentalValidity.text = businessData[0]['BusinessRental'] ?? '';
      // Set other fields as needed
    });
  }
}



void showSuccessAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Success'),
        content: Text('Business details saved successfully!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}



}

