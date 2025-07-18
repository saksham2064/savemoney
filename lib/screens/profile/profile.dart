import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.black87,
    );

    const valueStyle = TextStyle(
      fontSize: 16,
      color: Colors.black54,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Logout logic here
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              child: Icon(
                Icons.person,
                size: 80,
                color: Colors.white70,
              ),
              backgroundColor: Colors.deepPurple,
            ),
            const SizedBox(height: 30),

            // Name
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Name', style: labelStyle),
              subtitle: const Text('John Doe', style: valueStyle),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO: Edit name
                },
              ),
            ),
            const Divider(),

            // Email
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Email', style: labelStyle),
              subtitle: const Text('john.doe@example.com', style: valueStyle),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO: Edit email
                },
              ),
            ),
            const Divider(),

            // Profession
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Profession', style: labelStyle),
              subtitle: const Text('Software Developer', style: valueStyle),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO: Edit profession
                },
              ),
            ),
            const Divider(),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Logout logic here
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromARGB(255, 17, 158, 190),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
