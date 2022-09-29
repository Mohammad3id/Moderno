import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/bloc/product_bloc.dart';
import 'package:moderno/shared_functionality/calculate_color_value.dart';

class AddToCartDialog extends StatefulWidget {
  final Map<String, String> selectedAttributesOptions;
  final String dialogTitle;
  final String productId;
  final ProductBloc productBloc;
  const AddToCartDialog({
    Key? key,
    required this.selectedAttributesOptions,
    required this.dialogTitle,
    required this.productId,
    required this.productBloc,
  }) : super(key: key);

  @override
  State<AddToCartDialog> createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends State<AddToCartDialog> {
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.productBloc,
      child: Builder(builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  child: Text(
                    widget.dialogTitle,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const Divider(
                  height: 30,
                  color: Colors.black,
                ),
                Table(
                  columnWidths: {
                    0: FixedColumnWidth(MediaQuery.of(context).size.width / 5),
                    1: const FlexColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: widget.selectedAttributesOptions.entries.expand(
                    (entry) {
                      final attributeLabel = entry.key;
                      final attributeValue = entry.value;
                      return [
                        TableRow(
                          children: [
                            Text(
                              attributeLabel,
                              style: const TextStyle(fontSize: 18),
                            ),
                            if (attributeLabel == "Color")
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color(
                                      calculateColorValue(attributeValue),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromARGB(100, 0, 0, 0),
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(100, 0, 0, 0),
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).primaryColor),
                                  child: FittedBox(
                                    child: Text(
                                      attributeValue,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(),
                          ],
                        ),
                      ];
                    },
                  ).toList()
                    ..removeLast(),
                ),
                const Divider(
                  height: 30,
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FittedBox(
                      child: Text(
                        "Quantity",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: _quantity > 1
                              ? Colors.white
                              : const Color.fromARGB(125, 255, 255, 255),
                        ),
                        onPressed: _quantity > 1
                            ? () {
                                setState(() {
                                  _quantity--;
                                });
                              }
                            : null,
                      ),
                    ),
                    Container(
                      color: Theme.of(context).primaryColor,
                      width: 40,
                      height: 50,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text("$_quantity"),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 30,
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        side: BorderSide(
                          width: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: () {
                        BlocProvider.of<ProductBloc>(context).add(
                          ProductAddedToCart(
                            quantity: _quantity,
                            productAttributes: widget.selectedAttributesOptions,
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
