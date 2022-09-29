import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/bloc/user_bloc.dart';

import 'user_settings_field.dart';

class UserSettingsFields extends StatelessWidget {
  const UserSettingsFields({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        state as UserLoginSuccess;
        return Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              UserSettingsField(
                label: "First Name",
                initialValue: state.userInfo.firstName,
                validator: (value) {
                  if (value != null && value.trim().isEmpty) {
                    return "This field can't be empty";
                  }
                  return null;
                },
                onSave: (newFirstName, _) {
                  BlocProvider.of<UserBloc>(context).add(
                    UserInfoChanged(
                      firstName: newFirstName.trim(),
                    ),
                  );
                },
              ),
              UserSettingsField(
                label: "Last Name",
                initialValue: state.userInfo.lastName,
                validator: (value) {
                  if (value != null && value.trim().isEmpty) {
                    return "This field can't be empty";
                  }
                  return null;
                },
                onSave: (newLastName, _) {
                  BlocProvider.of<UserBloc>(context).add(
                    UserInfoChanged(
                      lastName: newLastName.trim(),
                    ),
                  );
                },
              ),
              UserSettingsField(
                label: "Email",
                initialValue: state.userInfo.email,
                isEmail: true,
                validator: (value) {
                  if (value != null) {
                    if (value.trim().isEmpty) {
                      return "This field can't be empty";
                    }
                    if (!value.contains("@") || !value.contains(".")) {
                      return "Invalid email";
                    }
                  }
                  return null;
                },
                onSave: (newEmail, _) {
                  BlocProvider.of<UserBloc>(context).add(
                    UserInfoChanged(
                      email: newEmail.trim(),
                    ),
                  );
                },
              ),
              UserSettingsField(
                label: "Phone Number",
                initialValue: state.userInfo.phoneNumber,
                placeHolder: "No phone number",
                isPhoneNumber: true,
                validator: (value) {
                  if (value != null) {
                    if (value.trim().isEmpty) {
                      return "This field can't be empty";
                    }
                    if (RegExp("^[0-9]*\$").hasMatch(value)) {
                      return "Invalid phone number";
                    }
                  }
                  return null;
                },
                onSave: (newPhoneNumber, _) {
                  BlocProvider.of<UserBloc>(context).add(
                    UserInfoChanged(
                      phoneNumber: newPhoneNumber.trim(),
                    ),
                  );
                },
              ),
              UserSettingsField(
                label: "Password",
                isPassword: true,
                validator: (value) {
                  if (value != null) {
                    if (value.length < 8) {
                      return "Password should be at least 8 characters long.";
                    }
                  }
                  return null;
                },
                onSave: (newPassword, oldPassword) {
                  BlocProvider.of<UserBloc>(context).add(
                    UserInfoChanged(
                      password: newPassword,
                      oldPassword: oldPassword,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
