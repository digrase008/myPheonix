import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/CustomerIDStorage.dart';
import 'package:my_pheonix/Utility/DatabaseHelper.dart';
import 'package:sqflite/sqlite_api.dart';
import '../Utility/AppColor.dart';
import 'FloatingFooterView.dart';
import 'package:file_picker/file_picker.dart';
import 'CollapsibleSection.dart';
import 'UIElements/DropDownField.dart';
import 'UIElements/TextField.dart';
import 'package:permission_handler/permission_handler.dart';


class UploadDocument extends StatefulWidget {
  const UploadDocument({Key? key}) : super(key: key);

  @override
  _DocumentUploadState createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<UploadDocument> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _documentType = TextEditingController();
  final TextEditingController _documentName = TextEditingController();
  final TextEditingController _documentPathController = TextEditingController();

   List<Map<String, dynamic>> clientDocuments = [];

   @override
void initState() {
  super.initState();
  initDatabase();
  }

  // Initialize the database
  void initDatabase() async {
    // createUploadedDocumentsTable();
  }

@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    fetchDocumentsForClient(CustomerIDStorage.customerID ?? '');
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.appGreyColor,
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CollapsibleSection(
                title: 'UPLOAD DOCUMENT',
                content: Column(
                  children: [
                    buildDropdownField('Document Type', ['Adhar', 'Pan'], _documentType),
                    const SizedBox(height: 10),
                    buildFormField('Document Name', _documentName),
                    const SizedBox(height: 10),
                    _buildUploadDocumentView(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CollapsibleSection(
                title: 'DOCUMENTS',
                content: Column(
                  children: [
                    _buildUploadedDocumentsList(clientDocuments),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    bottomNavigationBar: FloatingFooterView(
      onBackButtonPressed: () {
      },
      onSaveButtonPressed: () {
        saveUploadedDocumentToSQLite(CustomerIDStorage.customerID ?? '');
      },
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    // ...
    // Rest of your scaffold properties
    // ...
  );
}


  Widget _buildUploadDocumentView() {
  // String? filePath; // Store the path of the selected file

  return Padding(
    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0), // Adjust the values as needed
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Border around the container
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_upload_outlined, // Upload document icon
            size: 48.0,
            color: Colors.grey,
          ),
          const SizedBox(height: 10.0),
          TextButton(
        onPressed: () async {
          

        if (await Permission.storage.request().isGranted) {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null) {
                  setState(() {
              _documentPathController.text = result.files.single.path ?? ''; 
            });
              } 
          } else {
          // Permission is denied - guilde user to grant permission
        }
      },
      child: const Text(
     'Click to Upload',
    style: TextStyle(
      color: AppColors.primaryColor,
      fontSize: 18,
      fontWeight: FontWeight.bold // Set the text color to blue
    ),
  ),
),
          const SizedBox(height: 10.0),
          const Text(
            'PNG, SVG, JPG or GIF (max. 800 x 400px)', // Information text about allowed formats
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15
            ),
          ), // Display the selected file path
        ],
      ),
    ),
  );
}

Widget _buildUploadedDocumentsList(List<Map<String, dynamic>> documents) {
  return Column(
    children: List.generate(documents.length, (index) {
      Map<String, dynamic> document = documents[index];

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _extractFileName(document['DocumentPath']),  // Use document name here
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Upload Date: ${document['UploadDate']}', // Use document data here
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Uploaded By: ${document['DocumentName']}', // Use document data here
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.primaryColor),
                      onPressed: () {
                        // Implement logic for editing the document
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        // Implement logic for deleting the document
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }),
  );
}



void saveUploadedDocumentToSQLite(String customerId) async {
  Database db = await DatabaseHelper.instance.database;
  
  String currentDate = DateTime.now().toLocal().toString().split(' ')[0];

  await db.insert(
    'UploadedDocuments',
    {
      'DocumentType': _documentType.text,
      'DocumentName': _documentName.text,
      'DocumentPath': _documentPathController.text,
      'UploadDate': currentDate,
      'CustomerID': customerId,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  fetchDocumentsForClient(CustomerIDStorage.customerID ?? '');
  showSuccessAlert(context);
}

// Call the method to get documents for a specific client
void fetchDocumentsForClient(String clientId) async {
  List<Map<String, dynamic>> documents = await getDocumentsForClient(clientId);

  setState(() {
    clientDocuments = documents;
  });
}


Future<List<Map<String, dynamic>>> getDocumentsForClient(String clientId) async {
  Database db = await DatabaseHelper.instance.database;
  
  List<Map<String, dynamic>> documents = await db.query(
    'UploadedDocuments',
    where: 'CustomerID = ?',
    whereArgs: [clientId],
  );
 
  return documents;
}

// Helper function to extract the file name from the path
String _extractFileName(String fullPath) {
  List<String> pathParts = fullPath.split('/');
  String fileName = pathParts.isNotEmpty ? pathParts.last : '';
  return fileName;
}

void showSuccessAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Success'),
        content: Text('Document uploaded successfully !!'),
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

