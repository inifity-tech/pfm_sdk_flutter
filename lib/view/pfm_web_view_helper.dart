import 'package:pfm_sdk_flutter/view/i_webview.dart';
import 'package:flutter/material.dart';

class PFMWebViewHelper extends IWebView {
  PFMWebViewHelper(
      {super.key,
      required super.initialUrl,
      required super.onClosed,
      required super.onError});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
