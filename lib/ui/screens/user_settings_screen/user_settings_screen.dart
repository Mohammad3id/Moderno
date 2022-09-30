import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/bloc/user_bloc.dart';

import 'widgets/user_payment_methods_list.dart';
import 'widgets/user_settings_fields.dart';
import 'widgets/user_settings_top_bar.dart';
import 'widgets/user_shipping_adrdesses_list.dart';

class UserSettingsScreen extends StatefulWidget {
  final UserBloc userBloc;
  const UserSettingsScreen({super.key, required this.userBloc});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  bool _scrolled = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      setState(() {
        _scrolled = _scrollController.offset > 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.userBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
          state as UserLoginSuccess;
          return DefaultTextStyle(
            style: const TextStyle(color: Colors.white),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserSettingsTopBar(elevated: _scrolled),
                  Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.fromSwatch(
                        accentColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            const UserSettingsFields(),
                            UserPaymentMethodsList(userBloc: widget.userBloc),
                            const SizedBox(height: 20),
                            UserShippingAddresses(userBloc: widget.userBloc),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
