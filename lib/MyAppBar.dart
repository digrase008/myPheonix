import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/AppColor.dart';
import 'package:my_pheonix/Utility/DatabaseHelper.dart';
import 'package:my_pheonix/login.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.home_filled,
              color: Colors.black,
            ),
            onPressed: () {
              // Implement action for the home button here
            },
          ),
          const Text(
            'Fri, 21 Apr 8:10AM',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14,
            ),
          ),
          PopupMenuButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
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
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            const LoginForm(), // Navigate to login page
      ),
      (route) => false, // Clear all existing routes
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
}
