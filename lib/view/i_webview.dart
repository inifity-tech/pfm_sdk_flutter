import 'package:flutter/material.dart';

class IWebView extends StatelessWidget {
  final String initialUrl;
  final Function(dynamic) onClosed;
  final Function(dynamic) onError;

  IWebView(
      {super.key,
      required this.initialUrl,
      required this.onClosed,
      required this.onError});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
