import 'package:flutter/material.dart';

/// Navigates to a new screen by pushing it onto the navigation stack.
/// 
/// This function takes a [BuildContext] and a [Widget] representing the screen
/// to navigate to. It returns a [Future] that completes with the result of the
/// navigation.
/// 
/// - `context`: The build context of the current screen.
/// - `screen`: The widget representing the screen to navigate to.
/// 
/// Returns a [Future] that completes with the result of the navigation.
Future<T?> startScreen<T>(BuildContext context, Widget screen) => Navigator.push<T>(context, MaterialPageRoute(builder: (context) => screen));

/// Replaces the current screen with a new screen.
/// 
/// This function takes a [BuildContext] and a [Widget] representing the new
/// screen. It returns a [Future] that completes with the result of the
/// navigation.
/// 
/// - `context`: The build context of the current screen.
/// - `screen`: The widget representing the new screen to navigate to.
/// 
/// Returns a [Future] that completes with the result of the navigation.
Future<T?> replaceScreen<T, TO>(BuildContext context, Widget screen) => Navigator.pushReplacement<T, TO>(context, MaterialPageRoute(builder: (context) => screen));

/// Closes the current screen and optionally returns a result.
/// 
/// This function takes a [BuildContext] and an optional value to return as the
/// result of the navigation.
/// 
/// - `context`: The build context of the current screen.
/// - `value`: The optional value to return as the result of the navigation.
void closeScreen<T>(BuildContext context, [T? value]) => Navigator.pop<T>(context, value);
