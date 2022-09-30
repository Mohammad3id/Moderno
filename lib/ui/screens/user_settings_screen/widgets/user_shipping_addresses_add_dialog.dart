import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:moderno/bloc/user_bloc.dart';
import 'package:moderno/data/models/user.dart';
import 'package:moderno/shared_functionality/keep_numbers_only.dart';
import 'user_payment_method_add_dialog_formatters.dart';

class UserShippingAddressEditDialog extends StatefulWidget {
  UserShippingAddressEditDialog({
    super.key,
    required this.userBloc,
    required this.isNewShippingAddress,
    this.initialShippingAddressValues,
  }) {}

  final UserBloc userBloc;
  final bool isNewShippingAddress;
  final UserShippingAddress? initialShippingAddressValues;

  @override
  State<UserShippingAddressEditDialog> createState() =>
      _UserShippingAddressEditDialogState();
}

class _UserShippingAddressEditDialogState
    extends State<UserShippingAddressEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _governateDropdownKey = GlobalKey<FormFieldState>();
  late final TextEditingController _addressNameTextEditingController;
  late final TextEditingController _cityTextEditingController;
  late final TextEditingController _streetTextEditingController;
  late final TextEditingController _additionalDetailsTextEditingController;
  late final TextEditingController _phoneNumberTextEditingController;

  String? _countryValue;
  String? _governateValue;

  @override
  void initState() {
    _addressNameTextEditingController =
        TextEditingController(text: widget.initialShippingAddressValues?.name);
    _cityTextEditingController =
        TextEditingController(text: widget.initialShippingAddressValues?.city);
    _streetTextEditingController = TextEditingController(
        text: widget.initialShippingAddressValues?.street);
    _additionalDetailsTextEditingController = TextEditingController(
        text: widget.initialShippingAddressValues?.additionalAddressDetails);
    _phoneNumberTextEditingController = TextEditingController(
        text: widget.initialShippingAddressValues?.phoneNumber);
    _countryValue = widget.initialShippingAddressValues?.country;
    _governateValue = widget.initialShippingAddressValues?.governate;

    super.initState();
  }

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
          value: widget.userBloc,
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
                        "Add a Shiiping Address",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.loose(
                        Size(
                          double.infinity,
                          (MediaQuery.of(context).size.height -
                              MediaQuery.of(context).viewInsets.bottom -
                              150),
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "This field can't be empty";
                                        }
                                        return null;
                                      },
                                      controller:
                                          _addressNameTextEditingController,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                        labelText: "Address Name",
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
                                    DropdownButtonFormField(
                                      value: _countryValue,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "This field can't be empty";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Country",
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
                                      items: const [
                                        "Egypt",
                                        "Lebanon",
                                      ]
                                          .map(
                                            (country) => DropdownMenuItem(
                                              value: country,
                                              child: Text(country),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        if (value == _countryValue) {
                                          return;
                                        }
                                        setState(() {
                                          _countryValue = value;
                                          _governateValue = null;
                                          _governateDropdownKey.currentState
                                              ?.reset();
                                        });
                                      },
                                    ),
                                    DropdownButtonFormField(
                                      // disabledHint:
                                      //     Text("Select Country first"),
                                      key: _governateDropdownKey,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "This field can't be empty";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Governate",
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
                                      value: _governateValue,
                                      items: [
                                        if (_countryValue == "Egypt") ...[
                                          "Alexanderia",
                                          "Aswan",
                                          "Asyut",
                                          "Beheira",
                                          "Beni Suef",
                                          "Cairo",
                                          "Dakahlia",
                                          "Damietta",
                                          "Faiyum",
                                          "Gharbia",
                                          "Giza",
                                          "Ismailia",
                                          "Kafr El Sheikh",
                                          "Luxor",
                                          "Matruh",
                                          "Minya",
                                          "Monufia",
                                          "New Valley",
                                          "North Dinai",
                                          "Port Said",
                                          "Qalyubia",
                                          "Qena",
                                          "Red Sea",
                                          "Sharqia",
                                          "Sohag",
                                          "South Sinai",
                                          "Suez",
                                        ] else ...[
                                          "Akkar",
                                          "Baalbeck",
                                          "Beirut",
                                          "Bekaa",
                                          "Mount Lebanon",
                                          "North Lebanon",
                                          "Nabatiyeh",
                                          "South Lebanon",
                                        ],
                                      ]
                                          .map(
                                            (gov) => DropdownMenuItem(
                                              child: Text(gov),
                                              value: gov,
                                            ),
                                          )
                                          .toList(),
                                      onChanged: _countryValue == null
                                          ? null
                                          : (value) {
                                              _governateValue = value as String;
                                            },
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "This field can't be empty";
                                        }
                                        return null;
                                      },
                                      controller: _cityTextEditingController,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                        labelText: "City",
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "This field can't be empty";
                                        }
                                        return null;
                                      },
                                      controller: _streetTextEditingController,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                        labelText: "Street",
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
                                      controller:
                                          _additionalDetailsTextEditingController,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                        labelText: "Additional Details",
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "This field can't be empty";
                                        }
                                        if (keepNumbersOnly(value,
                                                        withSpaces: true)
                                                    .length <
                                                value.length - 1 &&
                                            value.trim()[0] != "+") {
                                          return "Invalid number";
                                        }
                                        return null;
                                      },
                                      controller:
                                          _phoneNumberTextEditingController,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Phone Number",
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
                                    if (_formKey.currentState == null ||
                                        !_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    if (widget.isNewShippingAddress) {
                                      BlocProvider.of<UserBloc>(context).add(
                                        UserShippingAddressAdded(
                                          country: _countryValue!,
                                          governate: _governateValue!,
                                          city: _cityTextEditingController.text,
                                          street:
                                              _streetTextEditingController.text,
                                          additionalAddressDetails:
                                              _additionalDetailsTextEditingController
                                                      .text.isEmpty
                                                  ? null
                                                  : _additionalDetailsTextEditingController
                                                      .text,
                                          name:
                                              _addressNameTextEditingController
                                                  .text,
                                          phoneNumber:
                                              _phoneNumberTextEditingController
                                                  .text,
                                        ),
                                      );
                                    } else {
                                      BlocProvider.of<UserBloc>(context).add(
                                        UserShippingAddressUpdated(
                                          id: widget
                                              .initialShippingAddressValues!.id,
                                          country: _countryValue!,
                                          governate: _governateValue!,
                                          city: _cityTextEditingController.text,
                                          street:
                                              _streetTextEditingController.text,
                                          additionalAddressDetails:
                                              _additionalDetailsTextEditingController
                                                      .text.isEmpty
                                                  ? null
                                                  : _additionalDetailsTextEditingController
                                                      .text,
                                          name:
                                              _addressNameTextEditingController
                                                  .text,
                                          phoneNumber:
                                              _phoneNumberTextEditingController
                                                  .text,
                                        ),
                                      );
                                    }
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
