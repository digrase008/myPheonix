import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/CustomerIDStorage.dart';
import 'package:my_pheonix/Utility/DatabaseHelper.dart';
import 'package:sqflite/sqlite_api.dart';
import '../Utility/AppColor.dart';
import 'FloatingFooterView.dart';
import 'CustomeHeader.dart';
import 'UIElements/TextField.dart';
import 'UIElements/DropDownField.dart';
import 'UIElements/BulletSelectionWidget.dart';
import 'UIElements/DateOfBirthField.dart';
import 'UIElements/DropDownWithItem.dart';

class InsuaranceQues extends StatefulWidget {
  const InsuaranceQues({super.key});

  @override
  _InsuaranceQuesState createState() => _InsuaranceQuesState();
}

class _InsuaranceQuesState extends State<InsuaranceQues> {
  bool isFormExpanded = true; // Track form expansion state

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final TextEditingController _height = TextEditingController();
   final TextEditingController _weight = TextEditingController();
   final TextEditingController _noOfEarner = TextEditingController();
   final TextEditingController _weightChange = TextEditingController();
   final TextEditingController _weightReason = TextEditingController();
   final TextEditingController _covidSymtoms = TextEditingController();
   final TextEditingController _covidSuffer = TextEditingController();
   final TextEditingController _covidReason = TextEditingController();
   final TextEditingController _relationship = TextEditingController();
   final TextEditingController _firstName = TextEditingController();
   final TextEditingController _surname = TextEditingController();
   final TextEditingController _gender = TextEditingController();
   final TextEditingController _dob = TextEditingController();
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
    getInsuranceDetailsForClientFromSQLite(CustomerIDStorage.customerID ?? '');
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
            title: 'INSURANCE QUEASIONARY',
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
                        DropDownWithItem(title: 'Height', controller: _height, items: const ['Feet', 'Meter', 'Inch'],),
                        const SizedBox(height: 8),
                        buildFormField('Weight', _weight),
                        const SizedBox(height: 8),
                        buildFormField('Number of Earners', _noOfEarner),
                        const SizedBox(height: 8),
                        BulletSelectionWidget(
                          question: 'Was there a change in weight of more than 5 kg in the last one year?', 
                          options: const ['NO', 'YES'], 
                          selectionController: _weightChange
                          ),
                          const SizedBox(height: 8),
                        buildFormField('If yes reason for same', _weightReason),
                        const SizedBox(height: 8),
                        BulletSelectionWidget(
                          question: 'COVID-19 (excluding mandatory government orders to remain at home) or had a persistent cough, fever, raised temperature or been in contact with an individual suspected or confirmed to have COVID-19?', 
                          options: const ['NO', 'YES'], 
                          selectionController: _covidSymtoms
                          ),
                          const SizedBox(height: 8),
                          BulletSelectionWidget(
                          question: 'Did you suffer from any complications of lung (respiratory), kidney, liver, or heart problems related to the COVID-19 infection or Long COVID?', 
                          options: const ['NO', 'YES'], 
                          selectionController: _covidSuffer
                          ),
                          const SizedBox(height: 8),
                          buildFormField('If yes reason for same', _covidReason),
                          const SizedBox(height: 8),
                          buildDropdownField('Relation Ship with Applicant', ['Mother', 'Child'], _relationship),
                          const SizedBox(height: 8),
                          buildFormField('Nominee First Name', _firstName),
                          const SizedBox(height: 8),
                          buildFormField('Nominee Surname', _surname),
                          const SizedBox(height: 8),
                          buildDropdownField('Nominee Gender', ['Male', 'Female'], _gender),
                          const SizedBox(height: 8),
                          buildDateOfBirthField(context, 'Nominee DOB', _dob),
                          const SizedBox(height: 8),
                          buildFormField('Address Line 1', _addressLine1),
                          const SizedBox(height: 8),
                          buildFormField('Address Line 2', _addressLine2),
                          const SizedBox(height: 8),
                          buildFormField('Address Line 3', _addressLine3),
                          const SizedBox(height: 8),
                          buildFormField('Pin Code', _pincode),
                          const SizedBox(height: 8),
                          buildFormField('City/Village/Town', _city),
                          const SizedBox(height: 8),
                          buildFormField('Mandal/Tahsil', _tahsil),
                          const SizedBox(height: 8),
                          buildFormField('District', _district),
                          const SizedBox(height: 8),
                          buildFormField('State', _state),
                          const SizedBox(height: 8),
                          buildFormField('Landmark', _landmark, isMandatory: false),

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
    _height.clear();
    _weight.clear();
    _noOfEarner.clear();
    _weightChange.clear();
    _weightReason.clear();
    _covidSymtoms.clear();
    _covidSuffer.clear();
    _covidReason.clear();
    _relationship.clear();
    _firstName.clear();
    _surname.clear();
    _gender.clear();
    _dob.clear();
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
  saveInsuranceDetailsToSQLite(CustomerIDStorage.customerID ?? '');
  }
}

void saveInsuranceDetailsToSQLite(String clientId) async {
  Database db = await DatabaseHelper.instance.database;
  
  int result = await db.insert(
    'InsuranceDetails',
    {
      'ClientID': clientId,
      'Height': _height.text,
      'Weight': _weight.text,
      'NumberOfEarners': _noOfEarner.text,
      'WeightChange': _weightChange.text,
      'WeightChangeReason': _weightReason.text,
      'CovidSymptoms': _covidSymtoms.text,
      'CovidComplications': _covidSuffer.text,
      'CovidComplicationsReason': _covidReason.text,
      'RelationshipWithApplicant': _relationship.text,
      'NomineeFirstName': _firstName.text,
      'NomineeSurname': _surname.text,
      'NomineeGender': _gender.text,
      'NomineeDOB': _dob.text,
      'AddressLine1': _addressLine1.text,
      'AddressLine2': _addressLine2.text,
      'AddressLine3': _addressLine3.text,
      'Pincode': _pincode.text,
      'City': _city.text,
      'Tahsil': _tahsil.text,
      'District': _district.text,
      'State': _state.text,
      'Landmark': _landmark.text,
      // Add other columns and values for insurance details as needed
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  if (result != -1) {
    // Data successfully inserted
    showSuccessAlert(context);
  }
}

Future<void> getInsuranceDetailsForClientFromSQLite(String clientId) async {
  Database db = await DatabaseHelper.instance.database;
  List<Map<String, dynamic>> insuranceData = await db.query(
    'InsuranceDetails',
    where: 'ClientID = ?',
    whereArgs: [clientId],
  );

  if (insuranceData.isNotEmpty) {
    setState(() {
      _height.text = insuranceData[0]['Height'] ?? '';
      _weight.text = insuranceData[0]['Weight'] ?? '';
      _noOfEarner.text = insuranceData[0]['NumberOfEarners'] ?? '';
      _weightChange.text =
          insuranceData[0]['WeightChange'] ?? '';
      _weightReason.text = insuranceData[0]['WeightChangeReason'] ?? '';
      _covidSymtoms.text =
          insuranceData[0]['CovidSymptoms'] ?? '';
      _covidSuffer.text =
          insuranceData[0]['CovidComplications'] ?? '';
      _covidReason.text = insuranceData[0]['CovidReason'] ?? '';
      _relationship.text = insuranceData[0]['Relationship'] ?? '';
      _firstName.text = insuranceData[0]['NomineeFirstName'] ?? '';
      _surname.text = insuranceData[0]['NomineeSurname'] ?? '';
      _gender.text = insuranceData[0]['NomineeGender'] ?? '';
      _dob.text = insuranceData[0]['NomineeDOB'] ?? '';
      _addressLine1.text = insuranceData[0]['AddressLine1'] ?? '';
      _addressLine2.text = insuranceData[0]['AddressLine2'] ?? '';
      _addressLine3.text = insuranceData[0]['AddressLine3'] ?? '';
      _pincode.text = insuranceData[0]['PinCode'] ?? '';
      _city.text = insuranceData[0]['City'] ?? '';
      _tahsil.text = insuranceData[0]['Tahsil'] ?? '';
      _district.text = insuranceData[0]['District'] ?? '';
      _state.text = insuranceData[0]['State'] ?? '';
      _landmark.text = insuranceData[0]['Landmark'] ?? '';
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
        content: Text('Insuarance details saved successfully!'),
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

