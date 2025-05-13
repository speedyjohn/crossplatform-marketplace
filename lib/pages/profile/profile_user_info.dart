import 'package:flutter/material.dart';
import '../../models/user.dart';

class ProfileUserInfo extends StatelessWidget {
  final AppUser user;

  const ProfileUserInfo({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.email),
          title: const Text('Email'),
          subtitle: Text(user.email),
        ),
        if (user.name != null)
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Name'),
            subtitle: Text(user.name!),
          ),
      ],
    );
  }
} 