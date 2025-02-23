import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/CustomerIDStorage.dart';
import 'package:my_pheonix/Utility/DatabaseHelper.dart';
import 'package:sqflite/sqlite_api.dart';
import '../Utility/AppColor.dart';
import 'FloatingFooterView.dart';
import 'CustomeHeader.dart';
import 'UIElements/TextField.dart';
import 'UIElements/DropDownField.dart';

class AddressDetails extends StatefulWidget {
  const AddressDetails({Key? key}) : super(key: key);

  @override
  _AddressDetailsState createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  bool isFormExpanded = true; // Track form expansion state

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _addressType = TextEditingController();
  final TextEditingController _sameAsType = TextEditingController();
  final TextEditingController _addressLine1 = TextEditingController();
  final TextEditingController _addressLine2 = TextEditingController();
  final TextEditingController _addressLine3 = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _tahsil = TextEditingController();
  final TextEditingController _district = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _landmark = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getAddressDetailsForUserFromSQLite(CustomerIDStorage.customerID ?? '');
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
                  title: 'ADDRESS DETAILS',
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
                              buildDropdownField(
                                'Address Type',
                                ['Home', 'Office', 'Other'],
                                _addressType,
                              ),
                              const SizedBox(height: 10),
                              buildDropdownField(
                                'Same As',
                                ['Home', 'Office', 'Other'],
                                _sameAsType,
                              ),
                              const SizedBox(height: 10),
                              buildFormField('Address Line 1', _addressLine1),
                              const SizedBox(height: 10),
                              buildFormField('Address Line 2', _addressLine2),
                              const SizedBox(height: 10),
                              buildFormField('Address Line 3', _addressLine3),
                              const SizedBox(height: 10),
                              buildFormField('Pin Code', _pincode),
                              const SizedBox(height: 10),
                              buildFormField('City/Village/Town', _city),
                              const SizedBox(height: 10),
                              buildFormField('Mandal/Tahsil', _tahsil),
                              const SizedBox(height: 10),
                              buildFormField('District', _district),
                              const SizedBox(height: 10),
                              buildFormField('State', _state),
                              const SizedBox(height: 10),
                              buildFormField('Landmark', _landmark,
                                  isMandatory: false),

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
        onBackButtonPressed: () {
          debugPrint("Inside onBackButtonPressed Property Details");
        },
        onSaveButtonPressed: () {
          debugPrint("Inside onSaveButtonPressed Property Details");
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
      _addressType.clear();
      _sameAsType.clear();
      _addressLine1.clear();
      _addressLine2.clear();
      _addressLine3.clear();
      _pincode.clear();
      _city.clear();
      _tahsil.clear();
      _district.clear();
      _state.clear();
      _landmark.clear();
    });
  }

// Method to collect and print form data
  void _saveFormData() {
    if (_formKey.currentState!.validate()) {
      saveAddressDetailsToSQLite(CustomerIDStorage.customerID ?? '');
    }
  }

  void saveAddressDetailsToSQLite(String customerId) async {
    Database db = await DatabaseHelper.instance.database;

    int result = await db.insert(
      'AddressDetails',
      {
        'CustomerID': customerId,
        'AddressType': _addressType.text,
        'SameAs': _sameAsType.text,
        'AddressLine1': _addressLine1.text,
        'AddressLine2': _addressLine2.text,
        'AddressLine3': _addressLine3.text,
        'Pincode': _pincode.text,
        'City': _city.text,
        'Tahsil': _tahsil.text,
        'District': _district.text,
        'State': _state.text,
        'Landmark': _landmark.text,
        // Add other columns and values for address details as needed
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (result != -1) {
      // Data successfully inserted
      showSuccessAlert(context);
    }
  }

  void getAddressDetailsForUserFromSQLite(String userId) async {
    Database db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> addressData = await db.query(
      'AddressDetails',
      where: 'CustomerID = ?',
      whereArgs: [userId],
    );

    if (addressData.isNotEmpty) {
      setState(() {
        _addressType.text = addressData[0]['AddressType'] ?? '';
        _sameAsType.text = addressData[0]['SameAs'] ?? '';
        _addressLine1.text = addressData[0]['AddressLine1'] ?? '';
        _addressLine2.text = addressData[0]['AddressLine2'] ?? '';
        _addressLine3.text = addressData[0]['AddressLine3'] ?? '';
        _pincode.text = addressData[0]['Pincode'] ?? '';
        _city.text = addressData[0]['City'] ?? '';
        _tahsil.text = addressData[0]['Tahsil'] ?? '';
        _district.text = addressData[0]['District'] ?? '';
        _state.text = addressData[0]['State'] ?? '';
        _landmark.text = addressData[0]['Landmark'] ?? '';
        // Set other fields based on retrieved data
      });
    }
  }

  void showSuccessAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Loan details saved successfully!'),
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
