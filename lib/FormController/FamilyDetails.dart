import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/CustomerIDStorage.dart';
import 'package:my_pheonix/Utility/DatabaseHelper.dart';
import 'package:sqflite/sqlite_api.dart';
import '../Utility/AppColor.dart';
import 'FloatingFooterView.dart';
import 'CustomeHeader.dart';
import 'UIElements/TextField.dart';

class FamilyDetails extends StatefulWidget {
  const FamilyDetails({super.key});

  @override
  _FamilyDetailsState createState() => _FamilyDetailsState();
}

class _FamilyDetailsState extends State<FamilyDetails> {
  bool isFormExpanded = true; // Track form expansion state

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _noOfFamilyMember = TextEditingController();
  final TextEditingController _noOfAdult = TextEditingController();
  final TextEditingController _noOfKids = TextEditingController();
  final TextEditingController _noOfEarner = TextEditingController();
  final TextEditingController _noOfDependent = TextEditingController();
  final TextEditingController _fatherFirstName = TextEditingController();
  final TextEditingController _fatherMiddleName = TextEditingController();
  final TextEditingController _fatherLastName = TextEditingController();
  final TextEditingController _motherFirstName = TextEditingController();
  final TextEditingController _motherMiddleName = TextEditingController();
  final TextEditingController _motherLastName = TextEditingController();
  final TextEditingController _spouseFirstName = TextEditingController();
  final TextEditingController _spouseMiddleName = TextEditingController();
  final TextEditingController _spouseLastName = TextEditingController();

  @override
  void initState() {
    super.initState();
    getFamilyDetailsForUserFromSQLite(CustomerIDStorage.customerID ?? '');
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
                  title: 'FAMILY DETAILS',
                  onClearAll: () {
                    clearAllFields();
                  },
                  onAdd: () {
                    setState(() {
                      isFormExpanded =
                          !isFormExpanded; // Toggle form expansion state
                    });
                  },
                  isExpanded:
                      isFormExpanded, // Pass expansion state to the CustomHeader
                ),
                Expanded(
                  child: Visibility(
                    visible: isFormExpanded, // Show only when form is expanded
                    maintainSize: false,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: isFormExpanded
                          ? null
                          : 0, // Set the height when expanded
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
                              const SizedBox(height: 10),
                              buildFormField(
                                  'Number Of Family Member', _noOfFamilyMember),
                              const SizedBox(height: 10),
                              buildFormField('No. of Adults', _noOfAdult),
                              const SizedBox(height: 10),
                              buildFormField('No. of Kids', _noOfKids),
                              const SizedBox(height: 10),
                              buildFormField('No. of Earners', _noOfEarner),
                              const SizedBox(height: 10),
                              buildFormField(
                                  'No. of Dependents', _noOfDependent),
                              const SizedBox(height: 10),
                              buildFormField(
                                  'Father First Name', _fatherFirstName),
                              const SizedBox(height: 10),
                              buildFormField(
                                  'Father Middle Name', _fatherMiddleName),
                              const SizedBox(height: 10),
                              buildFormField(
                                  'Father Last Name', _fatherLastName),
                              const SizedBox(height: 10),
                              buildFormField(
                                  'Mother First Name', _motherFirstName),
                              const SizedBox(height: 10),
                              buildFormField(
                                  'Mother Middle Name', _motherMiddleName),
                              const SizedBox(height: 10),
                              buildFormField(
                                  'Mother Last Name', _motherLastName),
                              const SizedBox(height: 10),
                              buildFormField(
                                  'Spouse First Name', _spouseFirstName),
                              const SizedBox(height: 10),
                              buildFormField(
                                  'Spouse Middle Name', _spouseMiddleName),
                              const SizedBox(height: 10),
                              buildFormField(
                                  'Spouse Last Name', _spouseLastName),
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
          )),
      bottomNavigationBar: FloatingFooterView(
        onBackButtonPressed: () {},
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
    _noOfFamilyMember.clear();
    _noOfAdult.clear();
    _noOfKids.clear();
    _noOfEarner.clear();
    _noOfDependent.clear();
    _fatherFirstName.clear();
    _fatherMiddleName.clear();
    _fatherLastName.clear();
    _motherFirstName.clear();
    _motherMiddleName.clear();
    _motherLastName.clear();
    _spouseFirstName.clear();
    _spouseMiddleName.clear();
    _spouseLastName.clear();
    // Clear other form fields similarly
  }

// Method to collect and print form data
  void _saveFormData() {
    if (_formKey.currentState!.validate()) {
      saveFamilyDetailsToSQLite();
    }
  }

  void getFamilyDetailsForUserFromSQLite(String clientId) async {
    Database db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> userData = await db.query(
      'FamilyDetails',
      where: 'ClientID = ?',
      whereArgs: [clientId],
    );

    if (userData.isNotEmpty) {
      setState(() {
        _noOfFamilyMember.text = userData[0]['NoOfFamilyMember'] ?? '';
        _noOfAdult.text = userData[0]['NoOfAdult'] ?? '';
        _noOfKids.text = userData[0]['NoOfKids'] ?? '';
        _noOfEarner.text = userData[0]['NoOfEarner'] ?? '';
        _noOfDependent.text = userData[0]['NoOfDependents'] ?? '';
        _fatherFirstName.text = userData[0]['FatherFirstName'] ?? '';
        _fatherMiddleName.text = userData[0]['FatherMiddleName'] ?? '';
        _fatherLastName.text = userData[0]['FatherLastName'] ?? '';
        _motherFirstName.text = userData[0]['MotherFirstName'] ?? '';
        _motherMiddleName.text = userData[0]['MotherMiddleName'] ?? '';
        _motherLastName.text = userData[0]['MotherLastName'] ?? '';
        _spouseFirstName.text = userData[0]['SpouseFirstName'] ?? '';
        _spouseMiddleName.text = userData[0]['SpouseMiddleName'] ?? '';
        _spouseLastName.text = userData[0]['SpouseLastName'] ?? '';
        // Retrieve other fields similarly
      });
    }
  }

  void saveFamilyDetailsToSQLite() async {
    Database db = await DatabaseHelper.instance.database;

    await db.insert(
      'FamilyDetails',
      {
        'ClientID': CustomerIDStorage.customerID ?? '',
        'NoOfFamilyMember': _noOfFamilyMember.text,
        'NoOfAdult': _noOfAdult.text,
        'NoOfKids': _noOfKids.text,
        'NoOfEarner': _noOfEarner.text,
        'NoOfDependents': _noOfDependent.text,
        'FatherFirstName': _fatherFirstName.text,
        'FatherMiddleName': _fatherMiddleName.text,
        'FatherLastName': _fatherLastName.text,
        'MotherFirstName': _motherFirstName.text,
        'MotherMiddleName': _motherMiddleName.text,
        'MotherLastName': _motherLastName.text,
        'SpouseFirstName': _spouseFirstName.text,
        'SpouseMiddleName': _spouseMiddleName.text,
        'SpouseLastName': _spouseLastName.text,
      },
      conflictAlgorithm: ConflictAlgorithm
          .replace, // Use the conflict algorithm as per your requirement
    );

    showSuccessAlert(context);
  }

  void showSuccessAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Family details saved successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
