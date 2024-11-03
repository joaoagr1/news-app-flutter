import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/user.dart';

class UserDataDialog extends StatelessWidget {
  final User user;

  UserDataDialog({required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('User Data', style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfoRow('ID:', user.id),
          _buildUserInfoRow('Login:', user.login),
          _buildUserInfoRow('Email:', user.email),
          _buildUserInfoRow('Role:', user.role),
          _buildUserInfoRow('Document:', user.document),
          _buildUserInfoRow('Created At:', user.createdAt),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}