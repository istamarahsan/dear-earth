import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class ProfilePage extends StatelessWidget {
  final PocketBase pb;

  ProfilePage({required this.pb});

  @override
  Widget build(BuildContext context) {
    // Retrieve the current user information from PocketBase
    final currentUser = pb.authStore.isValid;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Profile Page',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 16),
          Text(
            'User Name: ${currentUser}', // Replace 'name' with the actual property
            style: TextStyle(fontSize: 16),
          ),
          // Add more user information if needed
        ],
      ),
    );
  }
}
