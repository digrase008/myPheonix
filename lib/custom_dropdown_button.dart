import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/DatabaseHelper.dart';
import 'package:my_pheonix/login.dart';

class CustomDropdownButton extends StatelessWidget {
  const CustomDropdownButton({super.key});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginForm(),
      ),
      (route) => false,
    );
  }

  void _clearData(BuildContext context) async {
    try {
      DatabaseHelper helper = DatabaseHelper.instance;
      await helper.clearAllTables();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All data cleared successfully.'),
        ),
      );
    } catch (e) {
      print('Error while clearing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 50),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) {
        if (value == 'logout') {
          _logout(context);
        } else if (value == 'clearData') {
          _clearData(context);
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: 'logout',
          child: Text('Logout'),
        ),
        const PopupMenuItem(
          value: 'clearData',
          child: Text('Clear All Data'),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 6, 10, 111), // Background color
          borderRadius: BorderRadius.circular(20), // Capsule shape
          border: Border.all(color: Colors.black54), // Border color
        ),
        child: Row(
          children: [
            const Text(
              'Products',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
