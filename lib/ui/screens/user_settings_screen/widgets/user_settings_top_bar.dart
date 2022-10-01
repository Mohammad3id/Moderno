import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/bloc/user_bloc.dart';

class UserSettingsTopBar extends StatelessWidget {
  const UserSettingsTopBar({
    Key? key,
    required bool elevated,
  })  : _scrolled = elevated,
        super(key: key);

  final bool _scrolled;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: _scrolled
            ? [
                const BoxShadow(
                  color: Color.fromARGB(100, 0, 0, 0),
                  offset: Offset(0, 3),
                  blurRadius: 4,
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.only(
        left: 8,
        right: 20,
        top: 10,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              const Text(
                "Your Account",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
            ),
            onPressed: () {
              BlocProvider.of<UserBloc>(context).add(UserLogedOut());
            },
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
