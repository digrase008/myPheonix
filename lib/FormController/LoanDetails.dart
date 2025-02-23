import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/CustomerIDStorage.dart';
import 'package:my_pheonix/Utility/DatabaseHelper.dart';
import 'package:sqflite/sqlite_api.dart';
import '../Utility/AppColor.dart';
import 'FloatingFooterView.dart';
import 'CustomeHeader.dart';
import 'UIElements/TextField.dart';
import 'UIElements/DropDownField.dart';
import 'UIElements/DropDownWithItem.dart';

class LoanDetails extends StatefulWidget {
  const LoanDetails({super.key});

  @override
  _LoanDetailsState createState() => _LoanDetailsState();
}

class _LoanDetailsState extends State<LoanDetails> {
  bool isFormExpanded = true; // Track form expansion state

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _applicationID = TextEditingController();
  final TextEditingController _product = TextEditingController();
  final TextEditingController _applicationCategoty = TextEditingController();
  final TextEditingController _appliedLoanAmount = TextEditingController();
  final TextEditingController _appliedTenure = TextEditingController();
  final TextEditingController _endUseOfTheLoan = TextEditingController();

  @override
  void initState() {
    super.initState();
    getLoanDetailsForUserFromSQLite(CustomerIDStorage.customerID ?? '');
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
                  title: 'LOAN DETAILS',
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
                              const SizedBox(height: 8),
                              buildFormField('Application ID', _applicationID),
                              const SizedBox(height: 8),
                              buildDropdownField(
                                  'Product',
                                  ['Product 1', 'Product 2', 'Product 3'],
                                  _product),
                              const SizedBox(height: 8),
                              buildDropdownField(
                                  'Application Categoty',
                                  ['Category 1', 'Category 2', 'Categoty 3'],
                                  _applicationCategoty),
                              const SizedBox(height: 8),
                              DropDownWithItem(
                                  title: 'Applied Loan Amount',
                                  items: const ['INR', 'USD', 'EUR'],
                                  controller: _appliedLoanAmount),
                              const SizedBox(height: 12),
                              buildFormField(
                                  'Applied Tenure(Months)', _appliedTenure),
                              const SizedBox(height: 12),
                              buildFormField(
                                  'End use of the Loan', _endUseOfTheLoan),
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
    _applicationID.clear();
    _product.clear();
    _applicationCategoty.clear();
    _appliedLoanAmount.clear();
    _appliedTenure.clear();
    _endUseOfTheLoan.clear();
    // Clear other form fields similarly
  }

// Method to collect and print form data
  void _saveFormData() {
    if (_formKey.currentState!.validate()) {
      saveLoanDetailsToSQLite(CustomerIDStorage.customerID ?? '');
    }
  }

  void saveLoanDetailsToSQLite(String customerId) async {
    Database db = await DatabaseHelper.instance.database;

    int result = await db.insert(
      'LoanDetails',
      {
        'CustomerID': customerId,
        'ApplicationID': _applicationID.text,
        'Product': _product.text,
        'ApplicationCategory': _applicationCategoty.text,
        'AppliedLoanAmount': _appliedLoanAmount.text,
        'AppliedTenure': _appliedTenure.text,
        'EndUseOfTheLoan': _endUseOfTheLoan.text,
        // Add other columns and values for loan details as needed
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (result != -1) {
      // Data successfully inserted
      showSuccessAlert(context);
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

  void getLoanDetailsForUserFromSQLite(String userId) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> loanData = await db.query(
      'LoanDetails',
      where: 'CustomerID = ?',
      whereArgs: [userId],
    );

    if (loanData.isNotEmpty) {
      setState(() {
        _applicationID.text = loanData[0]['ApplicationID'] ?? '';
        _product.text = loanData[0]['Product'] ?? '';
        _applicationCategoty.text = loanData[0]['ApplicationCategory'] ?? '';
        _appliedLoanAmount.text = loanData[0]['AppliedLoanAmount'] ?? '';
        _appliedTenure.text = loanData[0]['AppliedTenure'] ?? '';
        _endUseOfTheLoan.text = loanData[0]['EndUseOfTheLoan'] ?? '';
        // Retrieve other columns for loan details as needed
        // Retrieve other fields similarly
      });
    }
  }
}
