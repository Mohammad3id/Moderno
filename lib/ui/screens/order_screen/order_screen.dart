import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:moderno/data/models/order.dart';
import 'package:moderno/ui/screens/order_screen/widgets/order_summary.dart';
import 'package:moderno/ui/shared_widgets/app_bottom_navigation_bar.dart';
import 'package:moderno/ui/shared_widgets/app_drawer.dart';
import 'package:moderno/ui/shared_widgets/top_bar.dart';

import 'widgets/order_item_tile.dart';

class OrderScreen extends StatefulWidget {
  final Order order;
  const OrderScreen({super.key, required this.order});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _scrollController = ScrollController();

  bool _showSummary = false;
  bool _showDivider = false;

  Future<void> _updateDividerVisibility() async {
    try {
      setState(() {
        _showDivider = _scrollController.position.extentAfter > 0.0;
      });
    } catch (_) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _updateDividerVisibility(),
      );
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      setState(() {
        _showSummary = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateDividerVisibility(),
    );
    return Scaffold(
      extendBody: true,
      drawer: const AppDrawer(),
      bottomNavigationBar: AnimatedOpacity(
        opacity: _showSummary ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: AppBottomNavigationBar.outsideMainScreen(),
      ),
      body: Stack(
        children: [
          const Positioned(
            height: 85,
            top: 0,
            left: 0,
            right: 0,
            child: TopBar(),
          ),
          Positioned.fill(
            top: 85,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 5,
                bottom: 190,
              ),
              itemCount: widget.order.cart.items.length,
              itemBuilder: (context, index) {
                final cartItem = widget.order.cart.items[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        index == widget.order.cart.items.length - 1 ? 0 : 20,
                  ),
                  child: OrderItemTile(cartItem: cartItem),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedOpacity(
              opacity: _showSummary ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: KeyboardVisibilityBuilder(
                  builder: (context, isKeyboardVisible) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: EdgeInsets.only(bottom: isKeyboardVisible ? 0 : 100),
                  child: Column(
                    children: [
                      OrderSummary(
                        showDivider: _showDivider,
                        order: widget.order,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
