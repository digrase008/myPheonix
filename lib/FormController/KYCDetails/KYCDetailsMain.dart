import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_pheonix/FormController/CollapsibleSection.dart';
import 'package:my_pheonix/FormController/UIElements/DropDownField.dart';
import 'package:my_pheonix/FormController/UIElements/TextField.dart';
import 'package:my_pheonix/FormController/UIElements/UploadDocumentField.dart';
import 'package:my_pheonix/Utility/CustomerIDStorage.dart';
import 'package:my_pheonix/Utility/DatabaseHelper.dart';
import 'package:sqflite/sqlite_api.dart';
import '../../Utility/AppColor.dart';
import '../FloatingFooterView.dart';

class KYCDetailsMain extends StatefulWidget {
  final VoidCallback formSaveCallback;
  const KYCDetailsMain({Key? key, required this.formSaveCallback})
      : super(key: key);
  @override
  _KYCDetailsMainState createState() => _KYCDetailsMainState();
}

class _KYCDetailsMainState extends State<KYCDetailsMain> {
  final List<Widget> _additionalKYCForms = [];

  final TextEditingController _ckycNoController = TextEditingController();
  final TextEditingController _kycTypeController = TextEditingController();
  final TextEditingController _kycIDController = TextEditingController();
  final TextEditingController _documentPathController = TextEditingController();

  final List<TextEditingController> _kycTypeControllers = [];
  final List<TextEditingController> _kycIDControllers = [];
  final List<TextEditingController> _documentPathControllers = [];

  @override
  void initState() {
    super.initState();
    _loadFormDataForClient(CustomerIDStorage.customerID ?? '');
    // _handleAddMoreClick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appGreyColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            // key: _formKey,
            child: Column(
              children: [
                // KYCExitingCustomerView(),
                // const SizedBox(height: 10),
                CollapsibleSection(
                  title: 'KYC DETAILS',
                  content: Column(
                    children: [
                      const SizedBox(height: 2),
                      buildFormField('CKYC Number', _ckycNoController),
                      const SizedBox(height: 5),
                      _buildUnderline(),
                      const SizedBox(height: 5),
                      // default add more KYC form needs here
                      Column(
                        children: _additionalKYCForms,
                      ),
                      const SizedBox(height: 10),
                      _buildAddMoreButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: FloatingFooterView(
        onBackButtonPressed: () {},
        onSaveButtonPressed: () {
          saveFormData();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Method to collect and print form data
  void saveFormData() {
    saveKYCDataToSQLite();
    widget.formSaveCallback();
  }

  Future<void> saveKYCDataToSQLite() async {
    Database db = await DatabaseHelper.instance.database;

    // Get CKYC number
    String ckycNumber = _ckycNoController.text;
    CustomerIDStorage.setCKYCIDToSave(ckycNumber);

    for (int i = 0; i < _kycTypeControllers.length; i++) {
      await db.insert(
        'KYCData',
        {
          'CustomerID': CustomerIDStorage.customerID ?? '',
          'ckycNumber': ckycNumber,
          'kycType': _kycTypeControllers[i].text,
          'kycID': _kycIDControllers[i].text,
          'documentPath': _documentPathControllers[i].text,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    showSuccessAlert(context);
  }

  void showSuccessAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('KYC details saved successfully!'),
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

  void _loadFormDataForClient(String clientId) async {
    List<Map<String, dynamic>> kycData = await getKYCDataForClient(clientId);
    print('_loadFormDataForClient: $kycData');
    if (kycData.isNotEmpty) {
      // Clear existing data structures or initialize them as needed
      _kycTypeControllers.clear();
      _kycIDControllers.clear();
      _documentPathControllers.clear();
      _additionalKYCForms.clear();

      // for (var data in kycData) {
      for (int i = 0; i < kycData.length; i++) {
        var data = kycData[i];
        TextEditingController kycTypeController =
            TextEditingController(text: data['kycType']);
        TextEditingController kycIDController =
            TextEditingController(text: data['kycID']);
        TextEditingController documentPathController =
            TextEditingController(text: data['documentPath']);

        _ckycNoController.text = data['ckycNumber'];
        _kycTypeControllers.add(kycTypeController);
        _kycIDControllers.add(kycIDController);
        _documentPathControllers.add(documentPathController);
        _additionalKYCForms.add(_buildAddMoreForm(i, data['documentPath']));
      }
    } else {
      _handleAddMoreClick(); // No saved data, add one default form
    }
  }

  Future<List<Map<String, dynamic>>> getKYCDataForClient(
      String clientId) async {
    Database db = await DatabaseHelper.instance.database;

    return await db.query(
      'KYCData',
      where: 'CustomerID = ?',
      whereArgs: [clientId],
    );
  }

  void clearAllFields() {
    _ckycNoController.clear();
    _kycTypeController.clear();
    _kycIDController.clear();
    _documentPathController.clear();
  }

  Widget _buildAddMoreButton() {
    return TextButton(
      onPressed: () {
        _handleAddMoreClick();
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.add_rounded,
            color: AppColors.primaryColor,
          ),
          SizedBox(width: 8),
          Text(
            'Add More KYC',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAddMoreClick() {
    setState(() {
      int newIndex = _additionalKYCForms.length;
      _kycTypeControllers.add(TextEditingController());
      _kycIDControllers.add(TextEditingController());
      _documentPathControllers.add(TextEditingController());
      _additionalKYCForms.add(_buildAddMoreForm(newIndex, ''));
    });
  }

  Widget _buildUnderline() {
    return Container(
      height: 1,
      color: Colors.grey, // Set the color of the underline here
    );
  }

  Widget _buildAddMoreForm(int index, String? storedDocumentPath) {
    File? selectedFile =
        (storedDocumentPath != null && storedDocumentPath.isNotEmpty)
            ? File(storedDocumentPath)
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildDropdownField(
          'KYC Type',
          ['PAN Card', 'Aadhar Card'],
          _kycTypeControllers[index],
        ),
        const SizedBox(height: 10),
        UploadDocumentField(
          textEditingController: _documentPathControllers[index],
          selectedFile: selectedFile,
          onDeleteFile: () {
            _deleteFile(index);
          },
          onChooseFile: () async {
            await _chooseFile(index);
          },
        ),
        const SizedBox(height: 10),
        buildFormField('KYC ID No.', _kycIDControllers[index]),
        const SizedBox(height: 10),
        _buildUnderline(),
      ],
    );
  }

// Define the _deleteFile method to handle file deletion
  void _deleteFile(int index) {
    setState(() {
      _documentPathControllers[index].clear();
      // Perform additional operations for file deletion as needed
    });
  }

// Define the _chooseFile method to handle file selection
  Future<void> _chooseFile(int index) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _documentPathControllers[index].text =
            File(result.files.single.path!).path;
        // Additional operations if needed after file selection
      });
    }
  }
}
