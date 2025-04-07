import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pfm_sdk_flutter/model/pfm_sdk_params.dart';
import 'package:pfm_sdk_flutter/view/pfm_in_app_web_view_helper.dart';
import 'package:flutter/material.dart';

import 'pfm_sdk_manager.dart';

class PFMSDKLauncher extends StatelessWidget {
  const PFMSDKLauncher(
      {super.key,
      required this.equalSDKConfig,
      required this.onClosed,
      required this.onError});

  final PFMSDKConfig equalSDKConfig;
  final Function(dynamic) onClosed;
  final Function(dynamic) onError;
void _enableWebContentsDebugging() {
      if (defaultTargetPlatform == TargetPlatform.android) {
        InAppWebViewController.setWebContentsDebuggingEnabled(true);
      }
    }
  
  @override
  Widget build(BuildContext context) {
    _enableWebContentsDebugging();
    return Scaffold(
      body: FutureBuilder(
        future: PFMSDKManager().getGatewayURL(
          equalSDKConfig,
          (v) {
            onError(v.toJson());
            Navigator.pop(context);
          },
        ),
        builder: (_, snapShot) {
          switch (snapShot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              return PFMInAppWebViewWidget(
                initialUrl: snapShot.data ?? '',
                onClosed: onClosed,
                onError: onError,
              );
          }
        },
      ),
    );
  }
}
