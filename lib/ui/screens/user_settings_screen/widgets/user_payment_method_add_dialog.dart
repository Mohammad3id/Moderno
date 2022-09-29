import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:moderno/bloc/user_bloc.dart';
import 'user_payment_method_add_dialog_formatters.dart';

class UserPaymentMethodAddDialog extends StatelessWidget {
  UserPaymentMethodAddDialog({super.key, required this.userBloc});

  final UserBloc userBloc;

  final _formKey = GlobalKey<FormState>();
  final _cardHolderNameTextEditingController = TextEditingController();
  final _cardNumberTextEditingController = TextEditingController();
  final _cardExpiryDateTextEditingController = TextEditingController();
  final _cardCVVTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, keyboardVisible) {
      return WillPopScope(
        onWillPop: () async {
          if (keyboardVisible) {
            if (FocusManager.instance.primaryFocus != null) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
            return false;
          }
          return true;
        },
        child: BlocProvider.value(
          value: userBloc,
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return Dialog(
                insetPadding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
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
                      child: const Text(
                        "Add a Payment Method",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.loose(
                        Size(
                          double.infinity,
                          (MediaQuery.of(context).size.height -
                              MediaQuery.of(context).viewInsets.bottom),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 10,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller:
                                          _cardHolderNameTextEditingController,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      inputFormatters: [
                                        CardHolderNameFormatter()
                                      ],
                                      decoration: InputDecoration(
                                        labelText: "Card Holder Name",
                                        alignLabelWithHint: true,
                                        floatingLabelStyle: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [CardNumberFormatter()],
                                      controller:
                                          _cardNumberTextEditingController,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Card Number",
                                        alignLabelWithHint: true,
                                        floatingLabelStyle: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flex(
                                      direction: Axis.horizontal,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: TextFormField(
                                            controller:
                                                _cardExpiryDateTextEditingController,
                                            cursorColor:
                                                Theme.of(context).primaryColor,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              CardExpirationFormatter()
                                            ],
                                            decoration: InputDecoration(
                                              labelText: "Expiry Date",
                                              hintText: "MM/YY",
                                              alignLabelWithHint: true,
                                              floatingLabelStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Flexible(
                                          child: TextFormField(
                                            inputFormatters: [
                                              CardNumberFormatter()
                                            ],
                                            controller:
                                                _cardCVVTextEditingController,
                                            cursorColor:
                                                Theme.of(context).primaryColor,
                                            keyboardType: TextInputType.number,
                                            maxLength: 3,
                                            decoration: InputDecoration(
                                              labelText: "CVV",
                                              alignLabelWithHint: true,
                                              floatingLabelStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
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
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<UserBloc>(context).add(
                                      UserPaymentMethodAdded(
                                        cardHolderName:
                                            _cardHolderNameTextEditingController
                                                .text,
                                        cardNumber:
                                            _cardNumberTextEditingController
                                                .text,
                                        cardCVV:
                                            _cardCVVTextEditingController.text,
                                        expiryMonth: int.parse(
                                          _cardExpiryDateTextEditingController
                                              .text
                                              .substring(0, 2),
                                        ),
                                        expiryYear: int.parse(
                                          _cardExpiryDateTextEditingController
                                              .text
                                              .substring(3),
                                        ),
                                      ),
                                    );
                                    Navigator.of(context).pop();
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
              );
            },
          ),
        ),
      );
    });
  }
}
