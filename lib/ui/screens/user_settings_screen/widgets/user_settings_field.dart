import 'package:flutter/material.dart';

import 'user_settings_field_edit_dialog.dart';

class UserSettingsField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final String? placeHolder;
  final bool isPassword;
  final bool isPhoneNumber;
  final bool isEmail;
  final void Function(String value, String? password) onSave;
  final String? Function(String? value) validator;
  const UserSettingsField({
    super.key,
    required this.label,
    required this.onSave,
    required this.validator,
    this.isPassword = false,
    this.isPhoneNumber = false,
    this.isEmail = false,
    this.initialValue,
    this.placeHolder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 10),
              ),
              Text(
                isPassword ? "********" : initialValue ?? placeHolder ?? "",
                style: TextStyle(
                  fontSize: 20,
                  color: initialValue == null && !isPassword
                      ? const Color.fromARGB(128, 255, 255, 255)
                      : Colors.white,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => UserSettingsFieldEditDialog(
                  initialValue: initialValue,
                  placeHolder: placeHolder,
                  isPassword: isPassword,
                  isPhoneNumber: isPhoneNumber,
                  isEmail: isEmail,
                  label: label,
                  onSave: onSave,
                  validator: validator,
                ),
              );
            },
            icon: Icon(
                initialValue == null && !isPassword ? Icons.add : Icons.edit),
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
