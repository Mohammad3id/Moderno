import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class UserSettingsFieldEditDialog extends StatefulWidget {
  final String label;
  final String? initialValue;
  final String? placeHolder;
  final bool isPassword;
  final bool isPhoneNumber;
  final bool isEmail;
  final void Function(String value, String? password) onSave;
  final String? Function(String? value) validator;
  const UserSettingsFieldEditDialog({
    super.key,
    required this.label,
    this.isPassword = false,
    this.isPhoneNumber = false,
    this.isEmail = false,
    required this.onSave,
    required this.validator,
    this.initialValue,
    this.placeHolder,
  });

  @override
  State<UserSettingsFieldEditDialog> createState() =>
      _UserSettingsFieldEditDialogState();
}

class _UserSettingsFieldEditDialogState
    extends State<UserSettingsFieldEditDialog> {
  late final TextEditingController _textEditingController;

  final TextEditingController _oldPasswordTextEditingController =
      TextEditingController();
  final TextEditingController _newPasswordTextEditingController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _textEditingController = TextEditingController(
      text: widget.isPassword ? null : widget.initialValue,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, keyboardVisible) {
      return KeyboardDismissOnTap(
        child: WillPopScope(
          onWillPop: () async {
            if (keyboardVisible) {
              if (FocusManager.instance.primaryFocus != null) {
                FocusManager.instance.primaryFocus!.unfocus();
              }
              return false;
            }
            return true;
          },
          child: Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            clipBehavior: Clip.hardEdge,
            backgroundColor: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    widget.label,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.loose(
                    Size(
                        double.infinity,
                        (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).viewInsets.bottom) -
                            150),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  keyboardType: widget.isPhoneNumber
                                      ? TextInputType.phone
                                      : widget.isEmail
                                          ? TextInputType.emailAddress
                                          : null,
                                  cursorColor: Theme.of(context).primaryColor,
                                  obscureText: widget.isPassword,
                                  decoration: InputDecoration(
                                    hintText: widget.isPassword
                                        ? "Old Password"
                                        : "${widget.initialValue != null ? "Edit" : "Add"} ${widget.label}",
                                    labelText: widget.isPassword
                                        ? "Old Password"
                                        : "${widget.initialValue != null ? "Edit" : "Add"} ${widget.label}",
                                    alignLabelWithHint: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    floatingLabelStyle: const TextStyle(
                                        color: Colors.transparent),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  validator: widget.isPassword
                                      ? null
                                      : widget.validator,
                                  controller: widget.isPassword
                                      ? _oldPasswordTextEditingController
                                      : _textEditingController,
                                ),
                                if (widget.isPassword) ...[
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    cursorColor: Theme.of(context).primaryColor,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: "New Password",
                                      labelText: "New Password",
                                      alignLabelWithHint: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      floatingLabelStyle: const TextStyle(
                                          color: Colors.transparent),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                    validator: widget.validator,
                                    controller:
                                        _newPasswordTextEditingController,
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    cursorColor: Theme.of(context).primaryColor,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: "Confirm New Password",
                                      labelText: "Confirm New Password",
                                      alignLabelWithHint: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      floatingLabelStyle: const TextStyle(
                                          color: Colors.transparent),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                    validator: (password) {
                                      if (password !=
                                          _newPasswordTextEditingController
                                              .text) {
                                        return "Passwords don't match";
                                      }
                                      return null;
                                    },
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context).primaryColor,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (widget.isPassword) {
                                    widget.onSave(
                                      _newPasswordTextEditingController.text,
                                      _oldPasswordTextEditingController.text,
                                    );
                                  } else if (widget.initialValue !=
                                      _textEditingController.text) {
                                    widget.onSave(
                                        _textEditingController.text, null);
                                  }
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text("Save"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
