import 'package:flutter/material.dart';
import 'package:my_pheonix/FormController/KYCDetails/KYCExitingCustomerView.dart';
import 'package:my_pheonix/Utility/AppColor.dart';
import 'package:my_pheonix/MyAppBar.dart';
import 'package:my_pheonix/Utility/CustomerIDStorage.dart';
import 'package:my_pheonix/Utility/DatabaseHelper.dart';
import 'package:my_pheonix/Utility/DatabaseManager.dart';
import 'package:my_pheonix/custom_drawer.dart';
import 'package:my_pheonix/landing_page.dart';
import 'package:sqflite/sqlite_api.dart';

class IntrestedLanding extends StatefulWidget {
  const IntrestedLanding({super.key});

  @override
  _IntrestedLandingState createState() => _IntrestedLandingState();
}

class _IntrestedLandingState extends State<IntrestedLanding> {
  bool _yesSelected = false;
  bool _noSelected = false;
  String? newOrExisting;
  bool _showNextButton = false;
  int? selectedRowIndex;
  List<Map<String, dynamic>>? searchResults;
  final DatabaseManager _dbManager = DatabaseManager();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    await _dbManager.initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const CustomDrawer(),
      backgroundColor: AppColors.appGreyColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColors.appGreyColor),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'INTERESTED?',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _yesSelected = true;
                            _noSelected = false;
                          });
                        },
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _yesSelected
                                  ? AppColors.primaryColor
                                  : Colors.black,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.circle_outlined,
                                    color: _yesSelected
                                        ? AppColors.primaryColor
                                        : Colors.black),
                                const SizedBox(width: 5),
                                const Text(
                                  'YES',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _yesSelected = false;
                            _noSelected = true;
                          });
                        },
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _noSelected
                                  ? AppColors.primaryColor
                                  : Colors.black,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.circle_outlined,
                                    color: _noSelected
                                        ? AppColors.primaryColor
                                        : Colors.black),
                                const SizedBox(width: 5),
                                const Text(
                                  'NO',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: _yesSelected,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: KYCExitingCustomerView(
                onCustomerSelection: handleCustomerSelection,
                onCustomerSearch: handleCustomerSearch,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (searchResults != null && searchResults!.isNotEmpty) ...[
            const SizedBox(height: 10), // Padding between content and list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0), // Padding for the list
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.grey), // Border around the list
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: ListView.builder(
                    itemCount: searchResults!.length,
                    itemBuilder: (context, index) {
                      bool isSelected = index == selectedRowIndex;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedRowIndex =
                                index; // Update the selected row index
                          });
                          // Handle tapping on the list item
                          String customerID =
                              searchResults![index]['CustomerID'];
                          CustomerIDStorage.setCustomerID(customerID);
                          _showNextButton = true;
                        },
                        child: Container(
                          color: isSelected
                              ? Colors.blue.withOpacity(0.2)
                              : Colors
                                  .transparent, // Change the background color for the selected row
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0), // Add padding to the tile
                          child: ListTile(
                            title: Text(
                                '${searchResults![index]['FirstNameP']} ${searchResults![index]['LastNameP']}'),
                            subtitle: Text(
                                'Customer ID: ${searchResults![index]['CustomerID']}'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(
            height: 30,
          ),
          Visibility(
            visible: _showNextButton, // Show/hide based on condition
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LandingPage()),
                );
              },
              child: const Icon(Icons.arrow_forward),
            ), // Replace this with your floating button widget
          ),
        ],
      ),
    );
  }

  void handleCustomerSelection(String selectedOption) {
    setState(() {
      newOrExisting = selectedOption; // Update the selected option in the state
      _showNextButton = selectedOption == 'New';
      if (selectedOption == 'New') {
        searchResults = null;
        selectedRowIndex = null;
        CustomerIDStorage.setCustomerID('');
        CustomerIDStorage.setCKYCIDToSave('');
      }
    });
    // Perform further actions based on the selected option
  }

  void handleCustomerSearch(String selectedOption) async {
    setState(() {
      newOrExisting = selectedOption;

      // _showNextButton = selectedOption == 'Advaya';
    });

    List<Map<String, dynamic>> results =
        await searchByFirstName(selectedOption);

    setState(() {
      searchResults = results.isNotEmpty ? results : null;
    });
  }

  Future<List<Map<String, dynamic>>> searchByFirstName(
      String searchString) async {
    Database db = await DatabaseHelper.instance.database;

    // Replace 'PersonalDetails' with your table name if different
    List<Map<String, dynamic>> results = await db.query(
      'PersonalDetails',
      where: 'FirstNameP LIKE ?',
      whereArgs: ['%$searchString%'], // % at both ends to match substring
    );

    for (Map<String, dynamic> result in results) {
      String firstName = result['FirstNameP'];
      String lastName = result['LastNameP'];
      String customerId = result['CustomerID'];

      // Use the extracted data as needed
      print(
          'First Name: $firstName, Last Name: $lastName, Customer ID: $customerId');
    }

    return results;
  }
}

void main() {
  runApp(MaterialApp(home: IntrestedLanding()));
}
