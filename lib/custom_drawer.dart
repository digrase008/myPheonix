import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Map<String, bool> expandedMenu = {}; // Stores open/closed state of submenus

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
                _buildMenuItem(
                  title: 'Logout',
                  icon: Icons.logout,
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    // Implement logout logic
                  },
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade900, // change approprite color properties
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(
                'assets/profile_pic.png'), // Mark location accordingky
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

  Widget _buildMenuItem(
      {required String title,
      required IconData icon,
      required Function() onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  Widget _buildExpandableMenuItem(
      {required String title,
      required IconData icon,
      required List<String> subMenu}) {
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
