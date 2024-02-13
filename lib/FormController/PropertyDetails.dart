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
import 'UIElements/UploadPhotoField.dart';

class PropertyDetails extends StatefulWidget {
  const PropertyDetails({super.key});

  @override
  _PropertyDetailsState createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
  bool isFormExpanded = true; // Track form expansion state

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final TextEditingController _propertyType = TextEditingController();
   final TextEditingController _dateOfRegitration = TextEditingController();
   final TextEditingController _assetID = TextEditingController();
   final TextEditingController _subRegitration = TextEditingController();
   final TextEditingController _extentOfProperty = TextEditingController();
   final TextEditingController _imagePathController = TextEditingController();

    @override
void initState() {
  super.initState();
}

@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getPropertyDetailsForUserFromSQLite(CustomerIDStorage.customerID ?? '');
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
            title: 'PROPERTY DETAILS',
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
                        buildDropdownField('Property Type', ['Legal', 'Illegal', 'Rented'], _propertyType),
                        const SizedBox(height: 8),
                        buildDateOfBirthField(context, 'Date Of Registration', _dateOfRegitration),
                        const SizedBox(height: 8),
                        buildFormField('Asset ID', _assetID),
                        const SizedBox(height: 8),
                        buildFormField('Sub registrar/SRO', _subRegitration),
                        const SizedBox(height: 8),
                        buildFormField('Extent of the Property', _extentOfProperty),
                        UploadPhotoField(textEditingController: _imagePathController),
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
        _saveFormData();
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
    _propertyType.clear();
    _dateOfRegitration.clear();
    _assetID.clear();
    _subRegitration.clear();
    _extentOfProperty.clear();
    _imagePathController.clear();
  });
}



// Method to collect and print form data
  void _saveFormData() {
  if (_formKey.currentState!.validate()) {
    savePropertyDetailsToSQLite(CustomerIDStorage.customerID ?? '');
  }
}

void savePropertyDetailsToSQLite(String customerId) async {
  Database db = await DatabaseHelper.instance.database;

  int result = await db.insert(
    'PropertyDetails',
    {
      'CustomerID': customerId,
      'PropertyType': _propertyType.text,
      'DateOfRegistration': _dateOfRegitration.text,
      'AssetID': _assetID.text,
      'SubRegistration': _subRegitration.text,
      'ExtentOfProperty': _extentOfProperty.text,
      'ImagePath': _imagePathController.text,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  if (result != -1) {
    // Data successfully inserted
    showSuccessAlert(context);
  }
}

void getPropertyDetailsForUserFromSQLite(String userId) async {
  Database db = await DatabaseHelper.instance.database;
  
  List<Map<String, dynamic>> propertyData = await db.query(
    'PropertyDetails',
    where: 'CustomerID = ?',
    whereArgs: [userId],
  );

  if (propertyData.isNotEmpty) {
    setState(() {
      _propertyType.text = propertyData[0]['PropertyType'] ?? '';
      _dateOfRegitration.text = propertyData[0]['DateOfRegistration'] ?? '';
      _assetID.text = propertyData[0]['AssetID'] ?? '';
      _subRegitration.text = propertyData[0]['SubRegistration'] ?? '';
      _extentOfProperty.text = propertyData[0]['ExtentOfProperty'] ?? '';
      _imagePathController.text = propertyData[0]['ImagePath'] ?? '';
      // Set other fields based on retrieved data
    });
  }
}


void showSuccessAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Success'),
        content: Text('Property details saved successfully!'),
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
