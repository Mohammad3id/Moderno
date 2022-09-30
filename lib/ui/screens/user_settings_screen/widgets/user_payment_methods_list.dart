import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/bloc/user_bloc.dart';
import 'package:moderno/ui/shared_widgets/confirmation_dialog.dart';

import 'user_payment_method_add_dialog.dart';

class UserPaymentMethodsList extends StatelessWidget {
  const UserPaymentMethodsList({super.key, required this.userBloc});

  final UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: userBloc,
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          state as UserLoginSuccess;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Payment Methods",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.userInfo.paymentMethods.length + 1,
                  itemBuilder: (context, index) {
                    if (index == state.userInfo.paymentMethods.length) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return UserPaymentMethodAddDialog(
                                    userBloc: userBloc,
                                  );
                                },
                              );
                            },
                            iconSize: 40,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                    final paymentMethod = state.userInfo.paymentMethods[index];

                    return Container(
                      margin: const EdgeInsets.only(left: 20, bottom: 10),
                      width: 250,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).primaryColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(100, 0, 0, 0),
                            offset: Offset(0, 3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        textStyle: const TextStyle(color: Colors.white),
                        child: InkWell(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) => const ConfirmationDialog(
                                message: "Delete Payment Method?",
                                confirmButtonText: "Delete",
                                denyButtonText: "Cancel",
                              ),
                            ).then((confirmed) {
                              if (confirmed) {
                                BlocProvider.of<UserBloc>(context).add(
                                  UserPaymentMethodRemoved(
                                    paymentMethod.cardNumber,
                                  ),
                                );
                              }
                            });
                          },
                          child: Container(
                            color: const Color.fromARGB(30, 0, 0, 0),
                            padding: const EdgeInsets.all(10),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Text(
                                    paymentMethod.issuingNetwork,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                                Text(
                                  "${paymentMethod.cardNumber.toString().substring(0, 4)}${"".padLeft(paymentMethod.cardNumber.toString().length - 8, "*")}${paymentMethod.cardNumber.toString().substring(paymentMethod.cardNumber.toString().length - 4)}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Positioned(
                                  left: 0,
                                  bottom: 5,
                                  right: 50,
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      paymentMethod.cardHolderName,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 5,
                                  child: Text(
                                    "${paymentMethod.expiryMonth.toString().padLeft(2, "0")}/${paymentMethod.expiryYear % 2000}",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
