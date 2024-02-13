import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../Utility/AppColor.dart';
import 'dart:io';

class UploadDocumentField extends StatefulWidget {
  final bool isMandatory;
  final File? selectedFile;
  final TextEditingController? textEditingController;
  final Function()? onDeleteFile;
  final Function()? onChooseFile;
  final File? _selectedFile;

  const UploadDocumentField({
    Key? key, 
    this.textEditingController, 
    this.isMandatory = true, 
    this.selectedFile,
    this.onDeleteFile,
    this.onChooseFile,
    }) : _selectedFile = selectedFile, super(key: key);

  @override
  _UploadDocumentFieldState createState() => _UploadDocumentFieldState();
}

class _UploadDocumentFieldState extends State<UploadDocumentField> {
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _selectedFile = widget._selectedFile; // Assign the _selectedFile with the value from the widget
  }

  Future<void> _chooseFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        if (_selectedFile != null && widget.textEditingController != null) {
        widget.textEditingController!.text = _selectedFile!.path; 
        }
      });
    }
  }

  void _deleteFile() {
    setState(() {
      _selectedFile = null;
      if (widget.textEditingController != null) {
        widget.textEditingController!.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Upload KYC',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.isMandatory)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    '*', // Red asterisk to indicate mandatory field
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              color: AppColors.fieldBackground,
              border: Border.all(width: 1.0, color: Colors.grey),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: _selectedFile != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.picture_as_pdf), // PDF icon
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _selectedFile!.path.split('/').last, // Display file name
                            style: const TextStyle(fontSize: 16.0),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _deleteFile,
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: AppColors.primaryColor,
                          size: 25,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: _chooseFile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(width: 2.0, color: AppColors.primaryColor),
                        ),
                        child: const Text(
                          'Choose Document',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            ),
                        ),
                      ),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('No file selected'),
                        ),
                      ),
                      const Icon(
                        Icons.description_rounded,
                        color: AppColors.primaryColor,
                      ),
                      
                    ],
                    
                  ),
                  
          ),
         /* SizedBox(height: 8,),
           // Below consition suppose to execute when click on save button
                    if (_selectedFile == null )
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Please select a file', // Your validation message
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12.0,
                          ),
                        ),
                      ),*/
        ],
      ),
    );
  }
}
