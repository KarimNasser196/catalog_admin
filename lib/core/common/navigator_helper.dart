import 'package:flutter/material.dart';

/// Navigates to a new screen using pushNamed, so the user can go back.
void navigatePushNamed(
  BuildContext context,
  String routeName, {
  Object? arguments,
}) {
  Navigator.of(context).pushNamed(routeName, arguments: arguments);
}

/// Navigates to a new screen using pushReplacementNamed, replacing the current screen.
/// The user cannot go back to the previous screen.
void navigatePushReplacementNamed(
  BuildContext context,
  String routeName, {
  Object? arguments,
}) {
  Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
}

/// A general purpose navigation function that pushes a new screen.
void navigatePush(BuildContext context, Widget screen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}

/// Goes back to the previous screen.
void navigatePop(BuildContext context) {
  Navigator.of(context).pop();
}
