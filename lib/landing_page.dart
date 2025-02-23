import 'package:flutter/material.dart';
import 'package:my_pheonix/MyAppBar.dart';
import 'SecondRowContent.dart';
// import 'Utility/AppColor.dart';

import 'FormController/PersonalDetails.dart';
import 'FormController/FamilyDetails.dart';
import 'FormController/LoanDetails.dart';
import 'FormController/BusinessDetails.dart';
import 'FormController/AddressDetails.dart';
import 'FormController/PropertyDetails.dart';
import 'FormController/BankingDetails.dart';
import 'FormController/InsuaranceQues.dart';
import 'FormController/Documents.dart';
import 'FormController/KYCDetails/KYCDetailsMain.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String selectedContent = '';
  late Widget currentWidget;
  int selectedMenuItem = 0;
  late SecondRowContent horizontalMenu;

  @override
  void initState() {
    super.initState();
    currentWidget = KYCDetailsMain(
      formSaveCallback: handleFormSave,
    );

    horizontalMenu = SecondRowContent(
      onContentSelected: (selectedContent) {
        onContentChange(selectedContent);
      },
      incrementIndexCallback: incrementHorizontalMenuIndex,
    );
  }

  void handleFormSave() {
    horizontalMenu.updateSelectedIndex(() {
      // Callback function to update the selected index in horizontal menu
    });
  }

  void incrementHorizontalMenuIndex() {
    debugPrint('Reached call in incrementIndexCallback');
    // Perform actions related to incrementing index in horizontalMenu here
  }

  void onContentChange(String content) {
    setState(() {
      selectedContent = content;
      switch (selectedContent) {
        case 'KYC Details':
          currentWidget = KYCDetailsMain(
            formSaveCallback: handleFormSave,
          );
          break;
        case 'Personal Details':
          currentWidget = const PersonalDetails();
          break;
        case 'Family Details':
          currentWidget = const FamilyDetails();
          break;
        case 'Loan Details':
          currentWidget = const LoanDetails();
          break;
        case 'Business Details':
          currentWidget = const BusinessDetails();
          break;
        case 'Address Details':
          currentWidget = const AddressDetails();
          break;
        case 'Property Details':
          currentWidget = const PropertyDetails();
          break;
        case 'Banking Details':
          currentWidget = const BankingDetails();
          break;
        case 'Insurance Questionnaries':
          currentWidget = const InsuaranceQues();
          break;
        case 'Documents':
          currentWidget = const UploadDocument();
          break;
        default:
          currentWidget = KYCDetailsMain(
            formSaveCallback: handleFormSave,
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: const MyAppBar(),
        body: Column(
          children: [
            // Your other widgets here...
            SecondRowContent(
              onContentSelected: (selectedContent) {
                onContentChange(selectedContent);
              },
              incrementIndexCallback: () {
                debugPrint('Reached call in incrementIndexCallback');
                horizontalMenu.updateSelectedIndex(() {
                  // Callback function to update the selected index in horizontal menu
                });
              },
            ),
            Expanded(
              child: Stack(
                children: [
                  Center(child: currentWidget),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const LandingPage());
}
