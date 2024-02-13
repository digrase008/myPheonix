import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/CustomerIDStorage.dart';
import 'package:my_pheonix/Utility/DatabaseHelper.dart';
import 'package:sqflite/sqlite_api.dart';
import '../Utility/AppColor.dart';
import 'FloatingFooterView.dart';
import 'CustomeHeader.dart';
import 'UIElements/TextField.dart';
import 'UIElements/DropDownField.dart';

class BankingDetails extends StatefulWidget {
  const BankingDetails({super.key});

  @override
  _BankingDetailsState createState() => _BankingDetailsState();
}

class _BankingDetailsState extends State<BankingDetails> {
  bool isFormExpanded = true; // Track form expansion state
  // late Database _db;

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final TextEditingController _accountNo = TextEditingController();
   final TextEditingController _accountHolderName = TextEditingController();
   final TextEditingController _accountType = TextEditingController();
   final TextEditingController _ifscCode = TextEditingController();
   final TextEditingController _bankName = TextEditingController();
   final TextEditingController _uploadStatement = TextEditingController();


 @override
void initState() {
  super.initState();
  initDatabase();
}

// Initialize the database
  void initDatabase() async {
    // _db = await DatabaseHelper.instance.database;
    // createBankingDetailsTable(_db);
  }

@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getBankingDetailsForUserFromSQLite(CustomerIDStorage.customerID ?? '');
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
            title: 'BANKING DETAILS',
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
                        const SizedBox(height: 10),
                        buildFormField('Account Number', _accountNo),
                        const SizedBox(height: 10),
                        buildFormField('Account Holder Name', _accountHolderName),
                        const SizedBox(height: 10),
                        buildDropdownField('Account Type', ['Saving', 'Current'], _accountType),
                        const SizedBox(height: 10),
                        buildFormField('IFSC Code', _ifscCode),
                        const SizedBox(height: 10),
                        buildFormField('Bank Name', _bankName),
                        const SizedBox(height: 10),
                        buildDropdownField('Upload Statement', ['Proprietorship', 'Other'], _uploadStatement),

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
        debugPrint("Inside onBackButtonPressed Banking Details");
      },
      onSaveButtonPressed: () {
        debugPrint("Inside onSaveButtonPressed Banking Details");
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
    _accountNo.clear();
    _accountHolderName.clear();
    _accountType.clear();
    _bankName.clear();
    _ifscCode.clear();
    _uploadStatement.clear();
  });
}



// Method to collect and print form data
  void _saveFormData() {
  if (_formKey.currentState!.validate()) {
    saveBankingDetailsToSQLite(CustomerIDStorage.customerID ?? '');
  }
}

void saveBankingDetailsToSQLite(String customerId) async {
  Database db = await DatabaseHelper.instance.database;

  int result = await db.insert(
    'BankingDetails',
    {
      'CustomerID': customerId,
      'AccountNumber': _accountNo.text,
      'AccountHolderName': _accountHolderName.text,
      'AccountType': _accountType.text,
      'IFSCCode': _ifscCode.text,
      'BankName': _bankName.text,
      'UploadStatement': _uploadStatement.text,
      // Add other columns and values for banking details as needed
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  if (result != -1) {
    // Data successfully inserted
    showSuccessAlert(context);
  }
}

void getBankingDetailsForUserFromSQLite(String userId) async {
  Database db = await DatabaseHelper.instance.database;
  List<Map<String, dynamic>> bankingData = await db.query(
    'BankingDetails',
    where: 'CustomerID = ?',
    whereArgs: [userId],
  );

  if (bankingData.isNotEmpty) {
    setState(() {
      _accountNo.text = bankingData[0]['AccountNumber'] ?? '';
      _accountHolderName.text = bankingData[0]['AccountHolderName'] ?? '';
      _accountType.text = bankingData[0]['AccountType'] ?? '';
      _ifscCode.text = bankingData[0]['IFSCCode'] ?? '';
      _bankName.text = bankingData[0]['BankName'] ?? '';
      _uploadStatement.text = bankingData[0]['UploadStatement'] ?? '';
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
        content: Text('Loan details saved successfully!'),
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

