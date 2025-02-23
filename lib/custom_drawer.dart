import 'package:flutter/material.dart';
import 'package:my_pheonix/Utility/DatabaseHelper.dart';
import 'package:my_pheonix/login.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Map<String, bool> expandedMenu = {}; // Stores open/closed state of submenus

  void _signOut(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginForm()),
      (route) => false,
    );
  }

  void _clearData(BuildContext context) async {
    try {
      Navigator.pop(context);
      DatabaseHelper helper = DatabaseHelper.instance;
      await helper.clearAllTables();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All data cleared successfully.')),
      );
    } catch (e) {
      print('Error while clearing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF072F88), // Blue background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  title: 'Dashboard',
                  icon: Icons.dashboard,
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    // Implement navigation
                  },
                ),
                _buildExpandableMenuItem(
                  title: 'Settings',
                  icon: Icons.settings,
                  subMenu: ['Account', 'Privacy', 'Notifications'],
                ),
                const Divider(color: Colors.white54), // Divider line
                _buildMenuItem(
                  title: 'Clear All Data',
                  icon: Icons.delete,
                  onTap: () => _clearData(context),
                ),
                _buildMenuItem(
                  title: 'Sign Out',
                  icon: Icons.logout,
                  onTap: () => _signOut(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade900, // Adjusted color properties
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage:
                AssetImage('assets/profile_pic.png'), // Profile image
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Advaya',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'advayadev@example.com',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required Function() onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  Widget _buildExpandableMenuItem({
    required String title,
    required IconData icon,
    required List<String> subMenu,
  }) {
    bool isExpanded = expandedMenu[title] ?? false;

    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          trailing: Icon(
            isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: Colors.white,
          ),
          onTap: () {
            setState(() {
              expandedMenu[title] = !isExpanded;
            });
          },
        ),
        if (isExpanded)
          Column(
            children: subMenu
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: _buildMenuItem(
                      title: item,
                      icon: Icons.circle, // Small icon for submenus
                      onTap: () {
                        Navigator.pop(context);
                        // Implement submenu action
                      },
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
