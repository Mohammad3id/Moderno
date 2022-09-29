import 'package:flutter/material.dart';

class AutheticationFormTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  const AutheticationFormTextField({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.validator,
    this.controller,
  }) : super(key: key);

  @override
  State<AutheticationFormTextField> createState() =>
      _AutheticationFormTextFieldState();
}

class _AutheticationFormTextFieldState
    extends State<AutheticationFormTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        focusNode: _focusNode,
        cursorColor: Colors.white,
        obscureText: widget.isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          fillColor: _isFocused
              ? const Color.fromARGB(75, 0, 0, 0)
              : const Color.fromARGB(25, 0, 0, 0),
          filled: true,
          constraints: const BoxConstraints.tightFor(width: 250),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          labelText: widget.label,
          labelStyle: const TextStyle(
            color: Color.fromARGB(128, 255, 255, 255),
          ),
          errorStyle: TextStyle(color: Colors.red[900]),
          errorMaxLines: 2,
          floatingLabelStyle: const TextStyle(color: Colors.white),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(128, 255, 255, 255),
            ),
          ),
        ),
      ),
    );
  }
}
