import 'package:flutter/material.dart';

class SlidePageRoute extends PageRouteBuilder {
  final WidgetBuilder builder;

  SlidePageRoute({required this.builder})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0), // Starting offset
                end: Offset.zero, // Ending offset
              ).animate(animation),
              child: child,
            );
          },
        );
}