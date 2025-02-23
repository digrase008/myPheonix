import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Utility/AppColor.dart';
import 'dart:io';

class UploadPhotoField extends StatefulWidget {
  final bool isMandatory;
  final TextEditingController? textEditingController;
  final String? selectedImagePath;

  const UploadPhotoField({
    Key? key,
    this.textEditingController,
    this.isMandatory = true,
    this.selectedImagePath = '',
  }) : super(key: key);

  @override
  _UploadPhotoFieldState createState() => _UploadPhotoFieldState();
}

class _UploadPhotoFieldState extends State<UploadPhotoField> {
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();

    if (widget.selectedImagePath != null &&
        widget.selectedImagePath!.isNotEmpty) {
      _selectedImage = XFile(widget.selectedImagePath!);
    }
  }

  Future<void> _choosePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
      if (pickedImage != null && widget.textEditingController != null) {
        widget.textEditingController!.text = pickedImage.path;
      }
    });
  }

  void _deletePhoto() {
    setState(() {
      _selectedImage = null;
      if (widget.textEditingController != null) {
        widget.textEditingController!.clear();
      }
    });
  }

  void _editPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
      if (pickedImage != null && widget.textEditingController != null) {
        widget.textEditingController!.text = pickedImage.path;
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
              const Text(
                'Upload Photo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.isMandatory)
                const Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Text(
                    '*', // Red asterisk to indicate mandatory field
                    style: TextStyle(
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
            child: _selectedImage != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(8.0), // Add padding here
                          child: Image.file(
                            File(_selectedImage!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 250,
                          ),
                        ),
                      ),
                      // Add edit and delete icons here if an image is selected
                      IconButton(
                        onPressed: _editPhoto,
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.primaryColor,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: _deletePhoto,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: _choosePhoto,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                              width: 2.0, color: AppColors.primaryColor),
                        ),
                        child: const Text(
                          'Choose Photo',
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
                      // this camera icon suppose to be out of decoration box
                      const Icon(
                        Icons.camera_alt_rounded,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
