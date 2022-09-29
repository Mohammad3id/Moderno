import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/bloc/user_bloc.dart';

class UserShippingAddresses extends StatelessWidget {
  const UserShippingAddresses({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        state as UserLoginSuccess;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Shipping Addresses",
                style: TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.userInfo.shippingAddresses.length + 1,
                itemBuilder: (context, index) {
                  if (index == state.userInfo.shippingAddresses.length) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          iconSize: 40,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                  final shippingAddress =
                      state.userInfo.shippingAddresses[index];

                  return Container(
                    margin: const EdgeInsets.only(left: 20, bottom: 10),
                    constraints: const BoxConstraints(minWidth: 250),
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
                    child: Container(
                      color: const Color.fromARGB(
                        30,
                        0,
                        0,
                        0,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shippingAddress.name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "${shippingAddress.street}, ${shippingAddress.additionalAddressDetails}",
                          ),
                          Text(
                            "${shippingAddress.city}, ${shippingAddress.state}",
                          ),
                          Text(
                            shippingAddress.country,
                          ),
                          Text(
                            shippingAddress.phoneNumber,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
