import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/bloc/user_bloc.dart';
import 'package:moderno/data/models/order.dart';
import 'package:moderno/ui/screens/main_screen/pages/profile_page/widgets/orders_cards_list.dart';
import 'package:moderno/ui/screens/user_settings_screen/user_settings_screen.dart';
import 'package:moderno/ui/shared_widgets/products_crads_list.dart';

import 'widgets/authentication_form.dart';

class ProfilePage extends StatelessWidget {
  final UserBloc userBloc;
  const ProfilePage({
    super.key,
    required this.userBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: userBloc,
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ));
          } else if (state is UserUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Changes saved."),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ));
          }
        },
        builder: (context, state) {
          if (state is UserGuest) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: AuthenticationForm(
                onUserCreation: (firstName, lastName, email, password) {
                  BlocProvider.of<UserBloc>(context).add(
                    UserCreated(
                      firstName: firstName,
                      lastName: lastName,
                      email: email,
                      password: password,
                    ),
                  );
                },
                onUserLogIn: (email, password) {
                  BlocProvider.of<UserBloc>(context).add(
                    UserLogedIn(
                      email: email,
                      password: password,
                    ),
                  );
                },
              ),
            );
          } else if (state is UserLoginSuccess) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Welcome, ${state.userInfo.firstName}",
                          style: const TextStyle(fontSize: 22),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserSettingsScreen(userBloc: userBloc),
                              ),
                            );
                          },
                          icon: const Icon(Icons.settings),
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                  if (state.userInfo.orders
                      .any((order) => order.status != OrderStatus.deliverd))
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: OrdersCradsList(
                        orders: state.userInfo.orders
                            .where(
                                (order) => order.status != OrderStatus.deliverd)
                            .toList(),
                        label: "Current Orders",
                        labelSize: 18,
                      ),
                    ),
                  if (state.wishlist.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ProductsCradsList(
                        productBriefs: state.wishlist,
                        label: "Wishlist",
                        showHeartIcon: false,
                      ),
                    ),
                  if (state.userInfo.orders
                      .any((order) => order.status == OrderStatus.deliverd))
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: OrdersCradsList(
                        orders: state.userInfo.orders
                            .where(
                                (order) => order.status == OrderStatus.deliverd)
                            .toList(),
                        label: "Delivered Orders",
                        labelSize: 18,
                      ),
                    ),
                  const SizedBox(height: 70),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
        },
      ),
    );
  }
}
