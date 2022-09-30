import 'package:flutter/material.dart';

class FadeInPageRoute extends PageRouteBuilder {
  final Widget page;
  FadeInPageRoute(this.page)
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween(begin: 0.0, end: 1.0);

            return FadeTransition(
              opacity: animation.drive(tween),
              child: child,
            );
          },
        );
}
