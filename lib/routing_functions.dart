// ignore_for_file: public_member_api_docs, type_annotate_public_apis, lines_longer_than_80_chars

library router_manager;

import 'package:flutter/material.dart';

late final BuildContext mainContext;

Future push(BuildContext context, controller) {
  final route = MaterialPageRoute(builder: (BuildContext context) => controller);
  return Navigator.of(context).push(route);
}

void pushReplacement(BuildContext context, controller) {
  final route = MaterialPageRoute(builder: (BuildContext context) => controller);
  Navigator.of(context).pushReplacement(route);
}

Future<dynamic> pushForResult(BuildContext context, controller) async {
  final route = MaterialPageRoute(builder: (BuildContext context) => controller);
  return Navigator.push(context, route);
}

void pushWithRouteName(BuildContext context, String name) {
  Navigator.pushNamed(context, name);
}

void pushReplacementWithRouteName(BuildContext context, String name) {
  Navigator.pushReplacementNamed(context, name);
}

void pop(BuildContext context, {result}) {
  if (result != null) {
    Navigator.pop(context, result);
  } else {
    Navigator.pop(context);
  }
}

void popUntil(BuildContext context, String name) {
  Navigator.popUntil(context, ModalRoute.withName(name));
}

void pushFromMain(controller) {
  final route = MaterialPageRoute(builder: (BuildContext context) => controller);
  Navigator.of(mainContext).push(route);
}

void popFromMain() {
  Navigator.of(mainContext).pop();
}

void pushWithSlideAnimation(BuildContext context, widgetToPush) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => widgetToPush,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1, 0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    ),
  );
}
