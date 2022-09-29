import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/bloc/product_bloc.dart';
import 'package:moderno/shared_functionality/calculate_color_value.dart';

class ProductAttributeOptionsSelector extends StatelessWidget {
  final String attributeLabel;
  final List<String> attributeOptions;
  final String selectedAttributesOption;
  const ProductAttributeOptionsSelector({
    Key? key,
    required this.attributeLabel,
    required this.attributeOptions,
    required this.selectedAttributesOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            attributeLabel,
            style: const TextStyle(fontSize: 20),
          ),
          Row(
            children: attributeOptions.map((option) {
              if (attributeLabel == "Color") {
                return GestureDetector(
                  onTap: () => BlocProvider.of<ProductBloc>(context).add(
                    ProductAttributeOptionSelected(
                      attributeLabel: attributeLabel,
                      attributeValue: option,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: 10,
                      top: 10,
                    ),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(100, 0, 0, 0),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                          spreadRadius:
                              selectedAttributesOption == option ? 5 : 0,
                        ),
                      ],
                      border: selectedAttributesOption == option
                          ? Border.all(
                              strokeAlign: StrokeAlign.outside,
                              width: 5,
                              color: Theme.of(context).primaryColor)
                          : null,
                      borderRadius: BorderRadius.circular(50),
                      color: Color(
                        calculateColorValue(option),
                      ),
                    ),
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () => BlocProvider.of<ProductBloc>(context).add(
                    ProductAttributeOptionSelected(
                      attributeLabel: attributeLabel,
                      attributeValue: option,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, top: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(100, 0, 0, 0),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                      border: selectedAttributesOption == option
                          ? null
                          : Border.all(
                              width: 1.5,
                            ),
                      borderRadius: BorderRadius.circular(10),
                      color: selectedAttributesOption == option
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    ),
                    child: FittedBox(
                      child: Text(
                        option,
                        style: selectedAttributesOption == option
                            ? const TextStyle(color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                );
              }
            }).toList(),
          ),
        ],
      ),
    );
  }
}
