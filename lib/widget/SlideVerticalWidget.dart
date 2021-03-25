import 'package:flutter/material.dart';

class SlideVerticalRoute extends PageRouteBuilder {
  final Widget child;
  final RouteSettings settings;

  SlideVerticalRoute({this.child, this.settings})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return child;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return new SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.ease)).animate(animation),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 500),
        );
}
