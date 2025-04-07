import 'package:pfm_sdk_flutter/pfm_web_view.dart';
import 'package:pfm_sdk_flutter/model/pfm_sdk_params.dart';
import 'package:flutter/material.dart';

abstract class PFMSDK {
  static final PFMSDK _instance = _PFMSDKImplementation();

  static PFMSDK get instance => _instance;

  void launchSDK({
    required BuildContext context,
    required PFMSDKConfig pfmSdkConfig,
    required Function(dynamic) onClosed,
    required Function(dynamic) onError,
  });
}

class _PFMSDKImplementation implements PFMSDK {
  @override
  void launchSDK({
    required BuildContext context,
    required PFMSDKConfig pfmSdkConfig,
    required Function(dynamic) onClosed,
    required Function(dynamic) onError,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PFMSDKLauncher(
          equalSDKConfig: pfmSdkConfig,
          onClosed: onClosed,
          onError: onError,
        ),
      ),
    );
  }
}
