import 'package:flutter/foundation.dart';
import 'package:pfm_sdk_flutter/model/pfm_sdk_params.dart';
import 'package:pfm_sdk_flutter/view/pfm_in_app_web_view_helper.dart';
import 'package:flutter/material.dart';

import 'pfm_sdk_manager.dart';

class PFMSDKLauncher extends StatefulWidget {
  const PFMSDKLauncher(
      {super.key,
      required this.equalSDKConfig,
      required this.onClosed,
      required this.onError});

  final PFMSDKConfig equalSDKConfig;
  final Function(dynamic) onClosed;
  final Function(dynamic) onError;

  @override
  State<PFMSDKLauncher> createState() => _PFMSDKLauncherState();
}

class _PFMSDKLauncherState extends State<PFMSDKLauncher> {
  ValueNotifier<String?> url = ValueNotifier(null);

  Future<String?> _getURL() async {
    return await PFMSDKManager().getGatewayURL(
      widget.equalSDKConfig,
      (v) {
        widget.onError(v.toJson());
        Navigator.pop(context);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getURL().then((value) {
      url.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _enableWebContentsDebugging();
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: url,
        builder: (BuildContext context, value, Widget? child) {
          return url.value != null
              ? PFMInAppWebViewWidget(
                  initialUrl: url.value ?? '',
                  onClosed: widget.onClosed,
                  onError: widget.onError,
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
        },
      ),
    );
  }
}
