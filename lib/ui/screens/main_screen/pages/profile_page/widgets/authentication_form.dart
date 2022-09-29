import 'package:flutter/material.dart';

import 'authentication_form_text_field.dart';

class AuthenticationForm extends StatefulWidget {
  final void Function(String email, String password) onUserLogIn;
  final void Function(
    String firstName,
    String lastName,
    String email,
    String password,
  ) onUserCreation;
  const AuthenticationForm({
    Key? key,
    required this.onUserLogIn,
    required this.onUserCreation,
  }) : super(key: key);

  @override
  State<AuthenticationForm> createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  bool _showCreateAccountForm = false;
  bool _showForm = true;
  final _firstNameFieldController = TextEditingController();
  final _lastNameFieldController = TextEditingController();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameFieldController.dispose();
    _lastNameFieldController.dispose();
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _showForm ? 1 : 0,
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 50),
                Text(
                  _showCreateAccountForm
                      ? "Create a Moderno account"
                      : "Log in to your account",
                  style: const TextStyle(fontSize: 40),
                  textAlign: TextAlign.center,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_showCreateAccountForm)
                        AutheticationFormTextField(
                          label: "First Name",
                          controller: _firstNameFieldController,
                          validator: (str) {
                            if (str != null && str.isEmpty) {
                              return "This field can't be empty";
                            }
                            return null;
                          },
                        ),
                      if (_showCreateAccountForm)
                        AutheticationFormTextField(
                          label: "Last Name",
                          controller: _lastNameFieldController,
                          validator: (str) {
                            if (str != null && str.isEmpty) {
                              return "This field can't be empty";
                            }
                            return null;
                          },
                        ),
                      AutheticationFormTextField(
                        label: "Email",
                        controller: _emailFieldController,
                        validator: (str) {
                          if (str != null && str.isEmpty) {
                            return "This field can't be empty";
                          }
                          if (str != null &&
                              (!str.contains("@") || !str.contains("."))) {
                            return "Invalid email address";
                          }
                          return null;
                        },
                      ),
                      AutheticationFormTextField(
                        label: "Password",
                        controller: _passwordFieldController,
                        isPassword: true,
                        validator: (str) {
                          if (str != null && str.length < 8) {
                            return "Password should be at least 8 characters long";
                          }
                          return null;
                        },
                      ),
                      if (_showCreateAccountForm)
                        AutheticationFormTextField(
                          label: "Confirm Password",
                          isPassword: true,
                          validator: (str) {
                            if (_passwordFieldController.text != str) {
                              return "Passwords not matching";
                            }
                            return null;
                          },
                        )
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          if (_showCreateAccountForm) {
                            widget.onUserCreation(
                              _firstNameFieldController.text.trim(),
                              _lastNameFieldController.text.trim(),
                              _emailFieldController.text.trim(),
                              _passwordFieldController.text,
                            );
                          } else {
                            widget.onUserLogIn(
                              _emailFieldController.text.trim(),
                              _passwordFieldController.text,
                            );
                          }
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        textStyle: const TextStyle(fontSize: 20),
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: Text(_showCreateAccountForm ? "Create" : "Log in"),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _showForm = false;
                        });
                        await Future.delayed(const Duration(milliseconds: 200));
                        _formKey.currentState!.reset();
                        setState(() {
                          _showCreateAccountForm = !_showCreateAccountForm;
                        });
                        await Future.delayed(const Duration(milliseconds: 50));
                        setState(() {
                          _showForm = true;
                        });
                      },
                      child: Text(
                        _showCreateAccountForm
                            ? "Already have an account? Log in"
                            : "Don't have an account? Create a one",
                        style: const TextStyle(
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
