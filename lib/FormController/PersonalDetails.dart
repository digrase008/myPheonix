import 'package:flutter/material.dart';
import 'package:my_pheonix/FormController/UIElements/UploadPhotoField.dart';
import 'package:my_pheonix/Utility/CustomerIDStorage.dart';
import 'package:my_pheonix/Utility/DatabaseHelper.dart';
import 'package:sqflite/sqlite_api.dart';
import '../Utility/AppColor.dart';
import 'FloatingFooterView.dart';
import 'CustomeHeader.dart';
import 'UIElements/TextField.dart';
import 'UIElements/DropDownField.dart';
import 'UIElements/DropDownWithItem.dart';
import 'UIElements/DateOfBirthField.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({Key? key}) : super(key: key);

  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  bool isFormExpanded = true; // Track form expansion state
  String imagePath = '';
  // late Database _db;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _customerIdController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _applicantNameControllerPAN =
      TextEditingController();
  final TextEditingController _applicantNameControllerAdhar =
      TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _mobileNoSecondaryController =
      TextEditingController();
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final TextEditingController _customerEntityTypeController =
      TextEditingController();
  final TextEditingController _applicantTypeController =
      TextEditingController();
  final TextEditingController _salutationController = TextEditingController();
  final TextEditingController _relionController = TextEditingController();
  final TextEditingController _castController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _maritalStatusController =
      TextEditingController();

  final GlobalKey<FormState> _dropdownEntityType = GlobalKey<FormState>();
  final GlobalKey<FormState> _dropdownApplicationType = GlobalKey<FormState>();
  final GlobalKey<FormState> _dropdownSolutation = GlobalKey<FormState>();
  final GlobalKey<FormState> _dropdownReligion = GlobalKey<FormState>();
  final GlobalKey<FormState> _dropdownCastType = GlobalKey<FormState>();
  final GlobalKey<FormState> _dropdownOccupation = GlobalKey<FormState>();
  final GlobalKey<FormState> _dropdownQualification = GlobalKey<FormState>();
  final GlobalKey<FormState> _dropdownMaritalStatus = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // initDatabase();
    getDataForUserFromSQLite(CustomerIDStorage.customerID ?? '');
  }

  // Initialize the database
  /*void initDatabase() async {
    _db = await DatabaseHelper.instance.database;
    createPersonalDetailsTable(_db);
  }*/

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
                  title: 'PERSONAL DETAILS',
                  onClearAll: () {
                    clearAll();
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
                                  'Customer ID', _customerIdController),
                              /*CustomFormField(
                          title: 'Customer ID', 
                          controller: _customerIdController, 
                          validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid Customer ID';
                          }
                          return null;
                        },),*/
                              const SizedBox(height: 10),
                              UploadPhotoField(
                                textEditingController: _imagePathController,
                                selectedImagePath: imagePath,
                              ),
                              const SizedBox(height: 10),
                              buildDropdownField('Customer Entity Type',
                                  ['Individual'], _customerEntityTypeController,
                                  onChanged: handleDropdownChange,
                                  dropdownKey: _dropdownEntityType),
                              const SizedBox(height: 10),
                              buildDropdownField('Applicant Type',
                                  ['Individual'], _applicantTypeController,
                                  dropdownKey: _dropdownApplicationType),
                              const SizedBox(height: 10),
                              buildDropdownField('Salutation', ['Mr', 'Mrs'],
                                  _salutationController,
                                  dropdownKey: _dropdownSolutation),
                              const SizedBox(height: 10),
                              _buildNameFields(
                                  'First Name', 'Middle Name', 'Last Name'),
                              const SizedBox(height: 10),
                              buildFormField("Applicant name as per PAN",
                                  _applicantNameControllerPAN),
                              const SizedBox(height: 10),
                              buildFormField("Applicant name as per Adhar",
                                  _applicantNameControllerAdhar),
                              const SizedBox(height: 10),
                              buildDropdownField(
                                  "Religion",
                                  ["Hinduism", "Muslim", "Bhudhism"],
                                  _relionController,
                                  dropdownKey: _dropdownReligion),
                              const SizedBox(height: 10),
                              buildDropdownField(
                                  "Caste", ["General", "OBC"], _castController,
                                  dropdownKey: _dropdownCastType),
                              const SizedBox(height: 10),
                              buildDropdownField("Occupation",
                                  ["Sales", "Backend"], _occupationController,
                                  dropdownKey: _dropdownOccupation),
                              const SizedBox(height: 10),
                              buildDropdownField(
                                  "Education Qualification",
                                  ["Engineer", "Doctor", "Other"],
                                  _educationController,
                                  dropdownKey: _dropdownQualification),
                              const SizedBox(height: 10),
                              DropDownWithItem(
                                  title: 'Mobile Number',
                                  controller: _mobileNoController),
                              const SizedBox(height: 10),
                              DropDownWithItem(
                                  title: 'Phone no. - Secondary',
                                  controller: _mobileNoSecondaryController),
                              const SizedBox(height: 10),
                              buildFormField('Email Id', _emailIdController),
                              const SizedBox(height: 10),
                              buildDateOfBirthField(
                                  context, 'Date Of Birth', _dobController),
                              const SizedBox(height: 10),
                              buildFormField('Age', _ageController),
                              const SizedBox(height: 10),
                              buildDropdownField(
                                  'Marital Status',
                                  ['Married', 'Unmarried'],
                                  _maritalStatusController,
                                  dropdownKey: _dropdownMaritalStatus)
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
          // Call back to previous page
        },
        onSaveButtonPressed: () {
          _saveFormData();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildNameFields(
      String firstNameTitle, String middleNameTitle, String lastNameTitle) {
    // bool showValidation = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /*buildFormField(
        firstNameTitle,
        _firstNameController ,
        isMandatory: true, 
        validator: (value) {
          if(value == null || value.isEmpty) {
            showValidation = false; // due to alignment issue passing false for now
            return 'Please enter your first name';
          } else {
            showValidation = false;
          }
          return '';
        },
        showValidation: showValidation
        ),*/
        buildFormField(firstNameTitle, _firstNameController, isMandatory: true),
        const SizedBox(height: 8.0),
        buildFormField(middleNameTitle, _middleNameController,
            isMandatory: true),
        const SizedBox(height: 8.0),
        buildFormField(lastNameTitle, _lastNameController, isMandatory: true),
      ],
    );
  }

  void handleDropdownChange(String? newValue) {
    // Handle the change in dropdown value here
    setState(() {
      // Update state variables or perform any necessary actions
    });
  }

  void clearAll() {
    _customerIdController.clear();
    _imagePathController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _middleNameController.clear();
    _applicantNameControllerPAN.clear();
    _applicantNameControllerAdhar.clear();
    _mobileNoController.clear();
    _mobileNoSecondaryController.clear();
    _emailIdController.clear();
    _ageController.clear();
    _dobController.clear();
    _customerEntityTypeController.clear();
    _applicantTypeController.clear();
    _salutationController.clear();
    _relionController.clear();
    _castController.clear();
    _occupationController.clear();
    _educationController.clear();
    _maritalStatusController.clear();
  }

// Method to collect and print form data
  void _saveFormData() {
    if (_formKey.currentState!.validate()) {
      saveDataToSQLite();
    }
  }

  void saveDataToSQLite() async {
    Database db = await DatabaseHelper.instance.database;

    await db.insert(
      'PersonalDetails',
      {
        'CustomerID': _customerIdController.text,
        'ImagePathPersonal': _imagePathController.text,
        'FirstNameP': _firstNameController.text,
        'MiddleNameP': _middleNameController.text,
        'LastNameP': _lastNameController.text,
        'ApplicantNamePAN': _applicantNameControllerPAN.text,
        'ApplicantNameAdhar': _applicantNameControllerAdhar.text,
        'MobileNumberP': _mobileNoController.text,
        'PhoneNoSecondary': _mobileNoSecondaryController.text,
        'EmailId': _emailIdController.text,
        'Age': _ageController.text,
        'DOBP': _dobController.text,
        'CustomerEntityType': _customerEntityTypeController.text,
        'ApplicantTypeP': _applicantTypeController.text,
        'Salutation': _salutationController.text,
        'Religion': _relionController.text,
        'Caste': _castController.text,
        'Occupation': _occupationController.text,
        'EducationQualification': _educationController.text,
        'MaritalStatus': _maritalStatusController.text,
        // Add other fields similarly
      },
      conflictAlgorithm: ConflictAlgorithm
          .replace, // You can define the conflict algorithm as per your needs
    );

    CustomerIDStorage.setCustomerID(_customerIdController.text);
    String cKYCToUpdate = CustomerIDStorage.cKYCIDToSave ?? '';
    updateCustomerIDForCKYCNumber(cKYCToUpdate, _customerIdController.text);
    showSuccessAlert(context);
  }

  void showSuccessAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Personal details saved successfully!'),
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

  Future<void> updateCustomerIDForCKYCNumber(
      String ckycNumber, String newCustomerID) async {
    Database db = await DatabaseHelper.instance.database;

    await db.update(
      'KYCData',
      {'CustomerID': newCustomerID},
      where: 'ckycNumber = ?',
      whereArgs: [ckycNumber],
    );
  }

// Retrieve Data from SQLite for a specific user
  void getDataForUserFromSQLite(String userId) async {
    Database db = await DatabaseHelper.instance.database;
    // Query the database for the specific user's data and populate the form fields
    // Use the db.query function to fetch data based on the user's profile

    List<Map<String, dynamic>> userData = await db.query(
      'PersonalDetails',
      where: 'CustomerID = ?',
      whereArgs: [userId],
    );

    if (userData.isNotEmpty) {
      setState(() {
        _customerIdController.text = userData[0]['CustomerID'] ?? '';
        _imagePathController.text = userData[0]['ImagePathPersonal'] ?? '';
        _firstNameController.text = userData[0]['FirstNameP'] ?? '';
        _middleNameController.text = userData[0]['MiddleNameP'] ?? '';
        _lastNameController.text = userData[0]['LastNameP'] ?? '';
        _applicantNameControllerPAN.text =
            userData[0]['ApplicantNamePAN'] ?? '';
        _applicantNameControllerAdhar.text =
            userData[0]['ApplicantNameAdhar'] ?? '';
        _mobileNoController.text = userData[0]['MobileNumberP'] ?? '';
        _mobileNoSecondaryController.text =
            userData[0]['PhoneNoSecondary'] ?? '';
        _emailIdController.text = userData[0]['EmailId'] ?? '';
        _ageController.text = userData[0]['Age'] ?? '';
        _dobController.text = userData[0]['DOBP'] ?? '';
        _customerEntityTypeController.text =
            userData[0]['CustomerEntityType'] ?? '';
        _applicantTypeController.text = userData[0]['ApplicantTypeP'] ?? '';
        _salutationController.text = userData[0]['Salutation'] ?? '';
        _relionController.text = userData[0]['Religion'] ?? '';
        _castController.text = userData[0]['Caste'] ?? '';
        _occupationController.text = userData[0]['Occupation'] ?? '';
        _educationController.text = userData[0]['EducationQualification'] ?? '';
        _maritalStatusController.text = userData[0]['MaritalStatus'] ?? '';
      });
    }
  }
}
