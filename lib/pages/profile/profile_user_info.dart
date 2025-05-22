import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user.dart';
import '../../providers/AuthProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileUserInfo extends StatefulWidget {
  final AppUser user;

  const ProfileUserInfo({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfileUserInfo> createState() => _ProfileUserInfoState();
}

class _ProfileUserInfoState extends State<ProfileUserInfo> {
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  bool _isEditingEmail = false;
  bool _isEditingName = false;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user.email);
    _nameController = TextEditingController(text: widget.user.name);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges(String key, String value) async {
    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);

    // Save to Firebase
    try {
      await _firestore.collection('users').doc(widget.user.uid).update({
        key == 'user_email' ? 'email' : 'name': value,
      });

      // Update the user data in AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final updatedUser = AppUser(
        uid: widget.user.uid,
        email: key == 'user_email' ? value : widget.user.email,
        name: key == 'user_name' ? value : widget.user.name,
        address: widget.user.address,
        phone: widget.user.phone,
        theme: widget.user.theme,
        language: widget.user.language,
      );
      
      // Force rebuild of the widget with new data
      setState(() {
        if (key == 'user_email') {
          _emailController.text = value;
        } else {
          _nameController.text = value;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.failedToUpdateFirebase(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.email),
          title: Text(AppLocalizations.of(context)!.email),
          subtitle: _isEditingEmail
              ? TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: '',
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      _isEditingEmail = false;
                    });
                    _saveChanges('user_email', value);
                  },
                )
              : Text(_emailController.text),
          trailing: IconButton(
            icon: Icon(_isEditingEmail ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditingEmail = !_isEditingEmail;
                if (!_isEditingEmail) {
                  _saveChanges('user_email', _emailController.text);
                }
              });
            },
          ),
        ),
        if (widget.user.name != null)
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(AppLocalizations.of(context)!.name),
            subtitle: _isEditingName
                ? TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: '',
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        _isEditingName = false;
                      });
                      _saveChanges('user_name', value);
                    },
                  )
                : Text(_nameController.text),
            trailing: IconButton(
              icon: Icon(_isEditingName ? Icons.save : Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditingName = !_isEditingName;
                  if (!_isEditingName) {
                    _saveChanges('user_name', _nameController.text);
                  }
                });
              },
            ),
          ),
      ],
    );
  }
} 